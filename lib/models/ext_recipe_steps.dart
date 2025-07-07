class ExternalRecipeSteps {
  final int? id;
  final List<RecipeStep>? steps;

  ExternalRecipeSteps({this.id, this.steps});

  factory ExternalRecipeSteps.fromJson(Map<String, dynamic> json) {
    return ExternalRecipeSteps(
      id: json['id'] as int?,
      steps:
          (json['steps'] as List?)
              ?.map((e) => RecipeStep.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'steps': steps?.map((e) => e.toJson()).toList(),
  };
}

class RecipeStep {
  final int? number;
  final String? step;

  RecipeStep({this.number, this.step});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      number: json['number'] as int?,
      step: json['step'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'number': number, 'step': step};
}
