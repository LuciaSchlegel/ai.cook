class ExternalRecipePreview {
  final int? id;
  final String? title;
  final String? image;
  final int? readyInMinutes;
  final int? servings;

  final List<String>? cuisines;
  final List<String>? dishTypes;
  final List<String>? diets;

  final List<RecipeIngredient>? extendedIngredients;

  ExternalRecipePreview({
    this.id,
    this.title,
    this.image,
    this.readyInMinutes,
    this.servings,
    this.cuisines,
    this.dishTypes,
    this.diets,
    this.extendedIngredients,
  });

  factory ExternalRecipePreview.fromJson(Map<String, dynamic> json) {
    return ExternalRecipePreview(
      id: json['id'] as int?,
      title: json['title'] as String?,
      image: json['image'] as String?,
      readyInMinutes: json['readyInMinutes'] as int?,
      servings: json['servings'] as int?,
      cuisines:
          (json['cuisines'] as List?)?.map((e) => e.toString()).toList() ?? [],
      dishTypes:
          (json['dishTypes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      diets: (json['diets'] as List?)?.map((e) => e.toString()).toList() ?? [],
      extendedIngredients:
          (json['extendedIngredients'] as List?)
              ?.map((e) => RecipeIngredient.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'readyInMinutes': readyInMinutes,
    'servings': servings,
    'cuisines': cuisines,
    'dishTypes': dishTypes,
    'diets': diets,
    'extendedIngredients': extendedIngredients?.map((e) => e.toJson()).toList(),
  };
}

class RecipeIngredient {
  final int? id;
  final String? name;
  final String? original;
  final double? amount;
  final String? unit;

  RecipeIngredient({this.id, this.name, this.original, this.amount, this.unit});

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'] as int?,
      name: json['name'] as String?,
      original: json['original'] as String?,
      amount:
          (json['amount'] is num) ? (json['amount'] as num).toDouble() : null,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'original': original,
    'amount': amount,
    'unit': unit,
  };
}
