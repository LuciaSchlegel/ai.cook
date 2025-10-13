# Font Styling Organization Guide

## 🎯 **Font Hierarchy & Usage**

### **Font Families**

#### **1. Compagnon (Primary - UI Elements)**
- **Purpose**: Main UI text, body content, readable interfaces
- **Characteristics**: Clean, professional, highly readable
- **Usage**: Navigation, buttons, cards, lists, general UI text

#### **2. Melodrama (Secondary - Headers & Emphasis)**
- **Purpose**: Headlines, titles, emphasis, branding elements
- **Characteristics**: Distinctive, decorative, attention-grabbing
- **Usage**: Page titles, section headers, call-to-action text

#### **3. Inter (Tertiary - Forms & Technical)**
- **Purpose**: Forms, technical content, data display
- **Characteristics**: Clean, minimal, excellent for small text
- **Usage**: Form fields, labels, technical information, code

---

## 🔧 **Implementation Examples**

### **✅ Recommended Usage**

```dart
// Headers and Titles - Use Melodrama
Text(
  'Welcome to AI Cook',
  style: AppTextStyles.melodrama(
    fontWeight: AppFontWeights.bold,
    fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xl),
    color: AppColors.button,
  ),
)

// Body Text - Use Compagnon
Text(
  'This is readable body content that users will read comfortably.',
  style: AppTextStyles.compagnon(
    fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
    color: AppColors.button,
    height: 1.4,
  ),
)

// Form Labels - Use Inter
Text(
  'Email Address',
  style: AppTextStyles.inter(
    fontWeight: AppFontWeights.semiBold,
    fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
    color: AppColors.button.withValues(alpha: 0.8),
    letterSpacing: 0.2,
  ),
)

// Button Text - Use Compagnon
Text(
  'Get Started',
  style: AppTextStyles.compagnon(
    fontWeight: AppFontWeights.semiBold,
    fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
    color: AppColors.white,
    letterSpacing: 0.3,
  ),
)
```

### **❌ Avoid These Patterns**

```dart
// DON'T: Hardcode font families
TextStyle(
  fontFamily: 'Inter',  // ❌ Use AppFontFamilies.inter
  fontWeight: FontWeight.w600,  // ❌ Use AppFontWeights.semiBold
)

// DON'T: Mix inconsistent approaches
style: MelodramaTextStyles.bold(...)  // ❌ Old system
style: TextStyle(fontFamily: 'Compagnon', ...)  // ❌ Manual approach

// DON'T: Use wrong font for context
Text(
  'Form Field Label',
  style: AppTextStyles.melodramaBold(...)  // ❌ Too decorative for forms
)
```

---

## 📋 **Migration Strategy**

### **Phase 1: Update Existing Code**
1. Replace all `MelodramaTextStyles.*` with `AppTextStyles.melodrama*`
2. Replace all `CompagnonTextStyles.*` with `AppTextStyles.compagnon*`
3. Replace hardcoded `fontFamily: 'Inter'` with `AppTextStyles.inter*`

### **Phase 2: Apply Font Hierarchy**
1. **Headers/Titles** → `AppTextStyles.melodrama*`
2. **Body/UI Text** → `AppTextStyles.compagnon*`
3. **Forms/Technical** → `AppTextStyles.inter*`

### **Phase 3: Cleanup**
1. Remove old `MelodramaTextStyles` class
2. Remove manual `TextStyle` constructions
3. Standardize letter spacing and line height

---

## 🎨 **Design Guidelines**

### **Typography Scale**
```dart
// Display (Hero text)
AppTextStyles.melodrama(
  fontWeight: AppFontWeights.bold,
  fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.display),
)

// Headlines (Section titles)
AppTextStyles.melodrama(
  fontWeight: AppFontWeights.semiBold,
  fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xl),
)

// Titles (Card headers)
AppTextStyles.compagnon(
  fontWeight: AppFontWeights.semiBold,
  fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.lg),
)

// Body (Content text)
AppTextStyles.compagnon(
  fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
)

// Labels (Form fields)
AppTextStyles.inter(
  fontWeight: AppFontWeights.medium,
  fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
)

// Captions (Small text)
AppTextStyles.inter(
  fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xs),
)
```

### **Common Properties**
```dart
// Standard line height for readability
height: 1.4

// Form labels letter spacing
letterSpacing: 0.2

// Button text letter spacing
letterSpacing: 0.3

// Header letter spacing
letterSpacing: 0.1
```

---

## 🚀 **Benefits of New System**

1. **Consistency**: All fonts managed centrally
2. **Maintainability**: Easy to update font choices globally
3. **Performance**: Proper font loading with weights
4. **Flexibility**: Easy to swap fonts for different contexts
5. **Responsive**: Integrates seamlessly with responsive utilities
6. **Type Safety**: Centralized font family constants prevent typos

---

## 📚 **Quick Reference**

### **Font Family Constants**
```dart
AppFontFamilies.compagnon  // Primary UI font
AppFontFamilies.melodrama  // Headers/emphasis font
AppFontFamilies.inter      // Forms/technical font
AppFontFamilies.primary    // Alias for compagnon
AppFontFamilies.secondary  // Alias for melodrama  
AppFontFamilies.tertiary   // Alias for inter
```

### **Weight Constants**
```dart
AppFontWeights.light      // 300
AppFontWeights.regular    // 400
AppFontWeights.medium     // 500
AppFontWeights.semiBold   // 600
AppFontWeights.bold       // 700
```

### **Style Methods**
```dart
// Simplified approach - Flutter handles font weights automatically
AppTextStyles.compagnon(fontWeight: AppFontWeights.light, {...})
AppTextStyles.compagnon(fontWeight: AppFontWeights.regular, {...})
AppTextStyles.compagnon(fontWeight: AppFontWeights.medium, {...})
AppTextStyles.compagnon(fontWeight: AppFontWeights.semiBold, {...})
AppTextStyles.compagnon(fontWeight: AppFontWeights.bold, {...})

AppTextStyles.melodrama(fontWeight: AppFontWeights.light, {...})
AppTextStyles.melodrama(fontWeight: AppFontWeights.regular, {...})
AppTextStyles.melodrama(fontWeight: AppFontWeights.medium, {...})
AppTextStyles.melodrama(fontWeight: AppFontWeights.semiBold, {...})
AppTextStyles.melodrama(fontWeight: AppFontWeights.bold, {...})

AppTextStyles.inter(fontWeight: AppFontWeights.regular, {...})
AppTextStyles.inter(fontWeight: AppFontWeights.medium, {...})
AppTextStyles.inter(fontWeight: AppFontWeights.semiBold, {...})
AppTextStyles.inter(fontWeight: AppFontWeights.bold, {...})
```
