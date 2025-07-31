# Enhanced Recipe Seeding Guide

This guide explains how to use the enhanced recipe seeding functionality that automatically creates missing ingredients with proper categorization and validation.

## Overview

The enhanced seeding system can:
- ✅ Automatically create missing ingredients from recipes
- 🏷️ Categorize ingredients using intelligent mapping
- 🥗 Assign dietary flags (vegan, vegetarian, gluten-free, lactose-free)
- 📊 Normalize ingredient names and quantities
- 🔄 Handle recipes.json format directly
- 🛡️ Provide comprehensive validation and error handling

## Setup Steps

### 1. Seed Basic Entities First

Before seeding recipes, you need to create the basic categories, units, and recipe tags:

```bash
# Using the script
npx ts-node src/scripts/seed-basic-entities.ts

# Or via API endpoint
POST /api/admin/seed/categories
POST /api/admin/seed/units  
POST /api/admin/seed/recipe_tags
```

This creates:
- **9 ingredient categories** (Grains & Cereals, Dairy & Eggs, Vegetables, etc.)
- **27 measurement units** (g, ml, cup, tsp, etc.)
- **50+ recipe tags** (Italian, Baking, Vegetarian, etc.)

### 2. Seed Recipes

#### Option A: Using the Script (Recommended)

```bash
# Seed all recipes from recipes.json
npx ts-node src/scripts/seed-recipes-from-json.ts

# Seed only first 5 recipes (for testing)
npx ts-node src/scripts/seed-recipes-from-json.ts --limit=5

# Seed first 10 recipes
npx ts-node src/scripts/seed-recipes-from-json.ts --limit=10
```

#### Option B: Using API Endpoint

```bash
POST /api/admin/seed/recipes-from-json
Content-Type: application/json

{
  "recipes": [
    {
      "name": "Recipe Name",
      "description": "Recipe description",
      "steps": ["Step 1", "Step 2"],
      "cookingTime": "30min",
      "difficulty": "Easy",
      "servings": "4 servings",
      "image": "https://example.com/image.jpg",
      "ingredients": [
        {
          "name": "Flour",
          "quantity": "200",
          "unit": "g",
          "additionalInfo": "all-purpose",
          "relativeQuantity": "1 cup"
        }
      ],
      "tags": ["Baking", "Easy"]
    }
  ]
}
```

## Intelligent Ingredient Processing

### Automatic Categorization

The system uses a comprehensive mapping to categorize ingredients:

```typescript
'flour' → 'Grains & Cereals'
'milk' → 'Dairy & Eggs'
'tomatoes' → 'Vegetables'
'beef' → 'Meat & Seafood'
'salt' → 'Pantry & Spices'
```

### Dietary Flag Assignment

Ingredients are automatically assigned dietary flags:

```typescript
'milk' → { isVegetarian: true, isLactoseFree: false }
'beef' → { isVegan: false, isVegetarian: false }
'flour' → { isVegan: true, isVegetarian: true, isGlutenFree: false }
'tofu' → { isVegan: true, isVegetarian: true, isGlutenFree: true, isLactoseFree: true }
```

### Name Normalization

Ingredient names are normalized by:
- Removing preparation words (fresh, dried, ground, chopped, etc.)
- Standardizing formats
- Handling variations

```typescript
"Fresh basil leaves" → "basil leaves"
"Ground black pepper" → "black pepper"
"Extra-virgin olive oil" → "olive oil"
```

### Quantity Parsing

The system handles various quantity formats:

```typescript
"45-75" → 60 (average of range)
"1/2" → 0.5 (fraction conversion)
"2.5" → 2.5 (decimal)
"to taste" → 1 (default fallback)
```

## Data Validation

### Recipe Validation
- ✅ Name and description required
- ✅ At least one ingredient required
- ✅ Tags must be an array
- ✅ Each ingredient must have name and quantity

### Ingredient Validation
- ✅ Name normalization and deduplication
- ✅ Category assignment (with fallback to "Others")
- ✅ Dietary flag assignment (with safe defaults)
- ✅ Quantity parsing with error handling

### Unit Validation
- ✅ Missing units logged as warnings (continues without unit)
- ✅ Support for both names and abbreviations
- ✅ Fallback to null if unit not found

## Error Handling

The system provides comprehensive error handling:

### Missing Dependencies
- ❌ **Categories/Units Missing**: Run basic entities seeding first
- ⚠️ **Missing Units**: Logged as warnings, continues without unit
- ✅ **Missing Ingredients**: Automatically created with categorization

### Validation Errors
- Clear error messages for invalid recipe data
- Detailed logging of what went wrong
- Graceful handling of edge cases

### Concurrent Operations
- Handles duplicate creation attempts
- Race condition protection
- Transaction safety

## Monitoring and Logging

The system provides detailed logging:

```
🍳 Processing 5 recipe(s) for seeding...
📊 Found 45 unique ingredients, 12 units, 8 tags
🥬 Creating missing ingredient: All-purpose flour
🏷️ Creating missing recipe tag: Baking
✅ Created 23 new ingredients: Flour, Milk, Eggs...
🍽️ Creating recipe: Chocolate Cake
✅ Successfully created recipe: Chocolate Cake with 12 ingredients
🎉 Successfully processed 5 recipe(s)
```

## Best Practices

### 1. Development/Testing
```bash
# Test with small batches first
npx ts-node src/scripts/seed-recipes-from-json.ts --limit=3
```

### 2. Production Seeding
```bash
# Seed basic entities first
npx ts-node src/scripts/seed-basic-entities.ts

# Then seed all recipes
npx ts-node src/scripts/seed-recipes-from-json.ts
```

### 3. Incremental Updates
- The system handles duplicate ingredients gracefully
- You can re-run seeding to add new recipes
- Existing data won't be duplicated

### 4. Custom Categories
- Add custom categories via `/api/admin/seed/categories`
- Update the `INGREDIENT_CATEGORIES` mapping as needed
- Categories are created automatically if missing

## Troubleshooting

### Common Issues

1. **Database Connection Error**
   ```
   Solution: Ensure database is running and credentials are correct
   ```

2. **Missing recipes.json**
   ```
   Solution: Ensure file exists at server/src/utils/recipes.json
   ```

3. **Unit Not Found Warnings**
   ```
   Solution: Add missing units via basic entities seeding or update BASIC_UNITS
   ```

4. **Categorization Issues**
   ```
   Solution: Update INGREDIENT_CATEGORIES mapping for better categorization
   ```

### Debug Mode
Add detailed logging for troubleshooting:

```typescript
console.log('Ingredient name:', ingredientName);
console.log('Normalized name:', normalizeIngredientName(ingredientName));
console.log('Assigned category:', findIngredientCategory(ingredientName));
```

## API Endpoints Summary

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/admin/seed/categories` | POST | Create ingredient categories |
| `/api/admin/seed/units` | POST | Create measurement units |
| `/api/admin/seed/recipe_tags` | POST | Create recipe tags |
| `/api/admin/seed/recipes-from-json` | POST | Seed recipes with auto-ingredient creation |
| `/api/admin/seed/recipes` | POST | Seed recipes (requires existing ingredients) |
| `/api/admin/seed/ingredients` | POST | Create ingredients manually |

## Future Enhancements

- 🔄 **Batch processing**: Handle very large recipe sets
- 🤖 **AI categorization**: Use AI for better ingredient categorization
- 📸 **Image processing**: Extract ingredients from recipe images
- 🌐 **Multi-language**: Support for multiple languages
- 📈 **Analytics**: Track seeding performance and accuracy