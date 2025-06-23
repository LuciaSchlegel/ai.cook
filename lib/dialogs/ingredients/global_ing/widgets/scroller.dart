import 'package:ai_cook_project/dialogs/ingredients/global_ing/widgets/ing_selection_tile.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IngListScroller extends StatefulWidget {
  final List<Ingredient> filteredIngredients;
  final List<UserIng> selectedIngredients;
  final Function(UserIng) onAdd;
  final Function(UserIng) onRemove;

  const IngListScroller({
    super.key,
    required this.filteredIngredients,
    required this.selectedIngredients,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<IngListScroller> createState() => _IngListScrollerState();
}

class _IngListScrollerState extends State<IngListScroller> {
  @override
  Widget build(BuildContext context) {
    final resourceProvider = Provider.of<ResourceProvider>(
      context,
      listen: false,
    );

    return CupertinoScrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.filteredIngredients.length,
        itemBuilder: (context, index) {
          final ing = widget.filteredIngredients[index];
          final ingEntry = widget.selectedIngredients.firstWhere(
            (ui) => ui.ingredient?.id == ing.id,
            orElse:
                () => UserIng(
                  id: -1,
                  uid: '',
                  ingredient: ing,
                  quantity: 0,
                  unit:
                      resourceProvider.units.isNotEmpty
                          ? resourceProvider.units.first
                          : Unit(
                            id: -1,
                            name: 'unit',
                            abbreviation: 'u',
                            type: 'general',
                          ),
                ),
          );
          final selected = ingEntry.id != -1;

          return IngredientSelectionTile(
            ingredient: ing,
            selected: selected,
            quantity: ingEntry.quantity,
            unit: ingEntry.unit!,
            units: resourceProvider.units,
            onConfirm: (qty, unit) {
              widget.onAdd(
                UserIng(
                  id: ing.id,
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  ingredient: ing,
                  quantity: qty,
                  unit: unit,
                ),
              );
            },
            onDeselect: () {
              widget.onRemove(ingEntry);
            },
          );
        },
      ),
    );
  }
}
