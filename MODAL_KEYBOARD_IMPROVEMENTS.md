# Modal Bottom Sheet Keyboard Behavior Improvements

## 🔧 **What was implemented:**
Fixed modal bottom sheet widgets to properly respond to device keyboard opening and closing by implementing keyboard-aware padding and scroll behavior.

## 💡 **Why this approach:**
Modal bottom sheets in Flutter don't automatically adjust to keyboard visibility by default. When a user taps on a text field within a modal, the keyboard can cover the input field, making it impossible to see what they're typing. This creates a poor user experience, especially on smaller screens.

## 📋 **Step-by-step breakdown:**

### 1. **Added Keyboard-Aware Padding**
- Wrapped modal content with `Padding` that uses `MediaQuery.of(context).viewInsets.bottom`
- This pushes the modal content up when the keyboard appears
- Applied to all `showModalBottomSheet` calls throughout the app

### 2. **Enhanced ScrollView Behavior**
- Added `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag` to `SingleChildScrollView`
- Added `physics: const BouncingScrollPhysics()` for better scroll feel
- Enhanced bottom padding calculations to account for keyboard presence

### 3. **Created Reusable Utility**
- Created `ModalUtils.showKeyboardAwareModalBottomSheet()` function
- Created `KeyboardAwareModalWrapper` widget for consistent behavior
- Centralized keyboard handling logic for maintainability

### 4. **Updated Form Dialogs**
- Enhanced `IngredientFormDialog` with better keyboard handling
- Enhanced `CustomIngLayout` with responsive padding
- Added conditional padding based on popup vs bottom sheet mode

## ⚖️ **Trade-offs & considerations:**

### **Benefits:**
- ✅ Text fields no longer get hidden by keyboard
- ✅ Smooth animation when keyboard appears/disappears
- ✅ Consistent behavior across all modal bottom sheets
- ✅ Better user experience on all device sizes
- ✅ Centralized utility for future modal implementations

### **Considerations:**
- Minor performance overhead from `MediaQuery` listening
- Additional padding calculations on each rebuild
- Need to maintain consistency when adding new modals

### **Performance Impact:**
- Minimal - only adds lightweight padding calculations
- Uses Flutter's built-in `MediaQuery` system efficiently
- No custom keyboard listeners or complex state management

## 🚀 **Integration notes:**

### **Files Modified:**
1. `lib/dialogs/ingredients/ingredient_dialogs.dart` - Main ingredient dialog wrapper
2. `lib/dialogs/ingredients/form/ingredient_form_dialog.dart` - Ingredient form improvements
3. `lib/dialogs/ingredients/custom_ing/widgets/custom_ing_layout.dart` - Custom ingredient layout
4. `lib/screens/recipes/widgets/recipe_card.dart` - Recipe card modal
5. `lib/screens/recipes/widgets/recipe_ov_card.dart` - Recipe overview modal
6. `lib/utils/modal_utils.dart` - New utility for keyboard-aware modals
7. `lib/dialogs/ingredients/global_ing/add/widgets/picker.dart` - QuantityUnitPicker with enhanced keyboard handling

### **How to Use the New Utilities:**

**For Modal Bottom Sheets:**
```dart
// Instead of showModalBottomSheet:
showModalBottomSheet(
  context: context,
  builder: (context) => MyWidget(),
);

// Use the new keyboard-aware version:
ModalUtils.showKeyboardAwareModalBottomSheet(
  context: context,
  child: MyWidget(),
);
```

**For Cupertino Modal Popups:**
```dart
// Instead of showCupertinoModalPopup:
showCupertinoModalPopup(
  context: context,
  builder: (context) => MyPicker(),
);

// Use the new keyboard-aware version:
ModalUtils.showKeyboardAwareCupertinoModalPopup(
  context: context,
  child: MyPicker(),
);
```

### **Responsive Behavior:**
- **iPhone**: Bottom sheet with keyboard-aware padding
- **iPad**: Popup dialog (keyboard handling still works)
- **All devices**: Smooth keyboard appearance/disappearance

### **Future Maintenance:**
- Always use `ModalUtils.showKeyboardAwareModalBottomSheet()` for new modal bottom sheets
- Always use `ModalUtils.showKeyboardAwareCupertinoModalPopup()` for new Cupertino modals
- The utilities handle all keyboard behavior automatically
- No need to manually add padding or keyboard listeners
- Especially important for modals with text input fields

## 🧪 **Testing Recommendations:**

### **Manual Testing:**
1. Open ingredient dialog on iPhone
2. Tap on quantity or name field
3. Verify keyboard doesn't cover input
4. Scroll to see all form elements
5. Test on iPad in popup mode
6. Test keyboard dismissal by dragging

### **Edge Cases to Test:**
- Very long ingredient names
- Multiple rapid keyboard open/close
- Device rotation during keyboard visibility
- Different keyboard types (numeric, text)
- **QuantityUnitPicker-Specific Tests:**
  - Quantity input field visibility when keyboard appears
  - Switching between quantity input and unit picker
  - Scrolling behavior with keyboard open
  - Confirm button accessibility with keyboard visible

## 📱 **Device-Specific Behavior:**

### **iPhone (Bottom Sheet Mode):**
- Modal slides up from bottom
- Keyboard pushes modal content up
- Drag to dismiss keyboard works
- Content remains scrollable

### **iPad (Popup Mode):**
- Modal appears as centered dialog
- Keyboard handling still functional
- No bottom sheet drag behavior
- Fixed maximum width constraints

This implementation ensures consistent, user-friendly keyboard behavior across all modal bottom sheets in the application while maintaining the existing responsive design patterns.
