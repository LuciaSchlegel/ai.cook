import { Ingredient } from '../entities/Ingredient';
import { IngredientRepository } from '../repositories/ingredient.repository';
//import { fetch } from 'node-fetch'; // Ensure you have node-fetch installed
import { IsNull } from 'typeorm';

export class IngredientEnrichmentService {
  static async enrichMissingIngredientInfo() {
    const ingredientsToEnrich = await IngredientRepository.find({
      where: [
        { isVegan: IsNull() },
        { isVegetarian: IsNull() },
        { isGlutenFree: IsNull() },
        { isLactoseFree: IsNull() },
      ],
      take: 5,
    });

    console.log(`🔍 ${ingredientsToEnrich.length} Zutaten zur Anreicherung gefunden.`);

    for (const ingredient of ingredientsToEnrich) {
      try {
        const enrichment = await this.fetchOpenFoodData(ingredient.name);
        console.log(`🔍 Anreicherung für ${ingredient.name} gefunden:`, enrichment);

        ingredient.isVegan = enrichment.isVegan;
        ingredient.isVegetarian = enrichment.isVegetarian;
        ingredient.isGlutenFree = enrichment.isGlutenFree;
        ingredient.isLactoseFree = enrichment.isLactoseFree;
        ingredient.tags = enrichment.tags;
        ingredient.category ??= enrichment.category;

        await IngredientRepository.save(ingredient);
        console.log(`✅ ${ingredient.name} angereichert.`);
      } catch (error: any) {
        console.warn(`⚠️ ${ingredient.name} konnte nicht angereichert werden:`, error.message);
      }

      await new Promise(resolve => setTimeout(resolve, 1000)); // rate limit
    }
  }

  static async fetchOpenFoodData(name: string) {
    const url = `https://world.openfoodfacts.org/cgi/search.pl?search_terms=${encodeURIComponent(name)}&search_simple=1&action=process&json=1&page_size=1`;
    const res = await fetch(url);
    const json = await res.json();
    const product = json.products?.[0];

    if (!product) throw new Error("Kein Produkt gefunden");

    const labels = product.labels_tags || [];
    const allergens = product.allergens_tags || [];
    const description = product.generic_name || product.ingredients_text || null;
    const category = product.categories_tags?.[0]?.split(':')[1] || null;

    return {
      isVegan: labels.includes('en:vegan'),
      isVegetarian: labels.includes('en:vegetarian'),
      isGlutenFree: labels.includes('en:gluten-free') || !labels.includes('en:contains-gluten'),
      isLactoseFree: labels.includes('en:lactose-free') || !labels.includes('en:contains-lactose'),
      allergens: allergens.map( (tag: string) => tag.split(':').pop()),
      description,
      category,
      tags: labels.map( (tag: string) => tag.split(':').pop()),
    };
  }
}
