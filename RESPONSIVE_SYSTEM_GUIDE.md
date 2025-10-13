# 📱 Responsive System Guide

## Overview

This guide explains how to use the comprehensive responsive system implemented for your Flutter app, optimized specifically for iPhone and iPad devices.

## 🎯 Key Features

- **Device-Specific Optimization**: Tailored for iPhone, iPad Mini, and iPad Pro
- **Consistent Spacing**: Unified spacing system across all components
- **Responsive Typography**: Font sizes that adapt to device type
- **Smart Modal Sizing**: Optimized modal and dialog configurations
- **Easy-to-Use Widgets**: Pre-built responsive components

## 📱 Device Types Supported

| Device Type | Screen Width Range | Optimizations |
|-------------|-------------------|---------------|
| iPhone | ≤ 430pt | Compact layouts, smaller spacing |
| iPad Mini | 431pt - 768pt | Balanced layouts, medium spacing |
| iPad Pro | > 768pt | Spacious layouts, larger spacing |

## 🔧 Core Components

### 1. ResponsiveUtils Class

The main utility class that provides all responsive functionality:

```dart
import 'package:ai_cook_project/utils/responsive_utils.dart';

// Device detection
bool isIPhone = ResponsiveUtils.isIPhone(context);
bool isIPad = ResponsiveUtils.isIPad(context);
DeviceType deviceType = ResponsiveUtils.getDeviceType(context);

// Responsive spacing
double spacing = ResponsiveUtils.spacing(context, ResponsiveSpacing.md);
EdgeInsets padding = ResponsiveUtils.padding(context, ResponsiveSpacing.lg);

// Responsive typography
double fontSize = ResponsiveUtils.fontSize(context, ResponsiveFontSize.title);

// Modal configuration
ResponsiveModalConfig config = ResponsiveUtils.getModalConfig(context);
```

### 2. Responsive Widgets

Pre-built widgets that handle responsiveness automatically:

#### ResponsiveText
```dart
ResponsiveText(
  'Hello World',
  fontSize: ResponsiveFontSize.title,
  fontWeight: FontWeight.bold,
  color: Colors.black,
)
```

#### ResponsiveContainer
```dart
ResponsiveContainer(
  padding: ResponsiveSpacing.lg,
  borderRadius: ResponsiveBorderRadius.md,
  backgroundColor: Colors.white,
  constrainWidth: true, // Limits width for better readability on iPad
  child: YourContent(),
)
```

#### ResponsiveIcon
```dart
ResponsiveIcon(
  Icons.home,
  size: ResponsiveIconSize.lg,
  color: Colors.blue,
)
```

#### ResponsiveSpacingWidget
```dart
// Vertical spacing
ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md)

// Horizontal spacing
ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.sm)
```

#### ResponsiveModalBottomSheet
```dart
ResponsiveModalBottomSheet.show(
  context: context,
  builder: (context, scrollController) => YourModalContent(),
);
```

## 📐 Spacing System

### Available Spacing Sizes

| Size | iPhone | iPad Mini | iPad Pro | Use Case |
|------|--------|-----------|----------|----------|
| `xxs` | 3.4pt | 4.0pt | 5.0pt | Minimal spacing |
| `xs` | 6.8pt | 8.0pt | 10.0pt | Small gaps |
| `sm` | 10.2pt | 12.0pt | 15.0pt | Standard spacing |
| `md` | 13.6pt | 16.0pt | 20.0pt | Default spacing |
| `lg` | 20.4pt | 24.0pt | 30.0pt | Section spacing |
| `xl` | 27.2pt | 32.0pt | 40.0pt | Large spacing |
| `xxl` | 40.8pt | 48.0pt | 60.0pt | Major sections |

### Usage Examples

```dart
// Using spacing directly
double spacing = ResponsiveUtils.spacing(context, ResponsiveSpacing.md);

// Using padding
EdgeInsets padding = ResponsiveUtils.padding(context, ResponsiveSpacing.lg);

// Using spacing widgets
ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md)
```

## 🎨 Typography System

### Font Size Scale

| Size | iPhone | iPad Mini | iPad Pro | Use Case |
|------|--------|-----------|----------|----------|
| `xs` | 12pt | 13.2pt | 14.4pt | Captions, small text |
| `sm` | 14pt | 15.4pt | 16.8pt | Secondary text |
| `md` | 16pt | 17.6pt | 19.2pt | Body text |
| `lg` | 18pt | 19.8pt | 21.6pt | Subheadings |
| `xl` | 20pt | 22.0pt | 24.0pt | Section titles |
| `xxl` | 24pt | 26.4pt | 28.8pt | Page titles |
| `title` | 28pt | 30.8pt | 33.6pt | Major headings |
| `display` | 34pt | 37.4pt | 40.8pt | Hero text |

### Usage

```dart
ResponsiveText(
  'Your text here',
  fontSize: ResponsiveFontSize.title,
  fontWeight: FontWeight.bold,
)
```

## 🔘 Icon System

### Icon Size Scale

| Size | iPhone | iPad Mini | iPad Pro |
|------|--------|-----------|----------|
| `xs` | 16pt | 17.6pt | 20.0pt |
| `sm` | 20pt | 22.0pt | 25.0pt |
| `md` | 24pt | 26.4pt | 30.0pt |
| `lg` | 28pt | 30.8pt | 35.0pt |
| `xl` | 32pt | 35.2pt | 40.0pt |
| `xxl` | 40pt | 44.0pt | 50.0pt |

## 📱 Modal & Dialog System

### Automatic Configuration

The system automatically configures modal and dialog sizes based on device type:

| Device | Initial Size | Min Size | Max Size | Snap Points |
|--------|-------------|----------|----------|-------------|
| iPhone | 85% | 60% | 95% | [0.6, 0.85, 0.95] |
| iPad Mini | 75% | 50% | 90% | [0.5, 0.75, 0.9] |
| iPad Pro | 70% | 45% | 85% | [0.45, 0.7, 0.85] |

### Usage

```dart
// Get modal configuration
final config = ResponsiveUtils.getModalConfig(context);

// Use in DraggableScrollableSheet
DraggableScrollableSheet(
  initialChildSize: config.initialSize,
  minChildSize: config.minSize,
  maxChildSize: config.maxSize,
  snapSizes: config.snapSizes,
  // ... rest of your modal
)

// Or use the convenience widget
ResponsiveModalBottomSheet.show(
  context: context,
  builder: (context, scrollController) => YourContent(),
)
```

## 🔄 Migration Guide

### From Old System to New System

#### Old Way:
```dart
// Old responsive helper methods
double _getInitialSize(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth < 600) return 0.9;
  return 0.8;
}

// Old spacing
padding: EdgeInsets.all(16),

// Old text
Text('Hello', style: TextStyle(fontSize: 20))
```

#### New Way:
```dart
// Use ResponsiveUtils
final config = ResponsiveUtils.getModalConfig(context);

// Responsive spacing
padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),

// Responsive text
ResponsiveText('Hello', fontSize: ResponsiveFontSize.xl)
```

## 🏗️ Layout Helpers

### Grid Layouts
```dart
// Automatic column count based on device
int columns = ResponsiveUtils.getGridColumns(context);
// iPhone: 2, iPad Mini: 3, iPad Pro: 4

// Use with ResponsiveGridView
ResponsiveGridView(
  children: yourWidgets,
  childAspectRatio: ResponsiveUtils.getCardAspectRatio(context),
)
```

### Content Width
```dart
// Optimal content width for readability
double optimalWidth = ResponsiveUtils.getOptimalContentWidth(context);

// Use with ResponsiveContainer
ResponsiveContainer(
  constrainWidth: true,
  maxWidth: optimalWidth,
  child: YourContent(),
)
```

## 🎯 Best Practices

### 1. Use Semantic Sizing
```dart
// ✅ Good - semantic sizing
ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md)

// ❌ Avoid - hardcoded values
SizedBox(height: 16)
```

### 2. Leverage Device-Specific Layouts
```dart
ResponsiveWidget(
  iPhone: CompactLayout(),
  iPadMini: MediumLayout(),
  iPadPro: SpaciousLayout(),
)
```

### 3. Use Responsive Containers for Content
```dart
ResponsiveContainer(
  padding: ResponsiveSpacing.lg,
  constrainWidth: true, // Improves readability on iPad
  child: ArticleContent(),
)
```

### 4. Consistent Typography
```dart
// ✅ Good - responsive typography
ResponsiveText('Title', fontSize: ResponsiveFontSize.title)

// ❌ Avoid - fixed font sizes
Text('Title', style: TextStyle(fontSize: 28))
```

## 🚀 Advanced Usage

### Custom Modal Configurations
```dart
final customConfig = ResponsiveModalConfig(
  initialSize: 0.8,
  minSize: 0.4,
  maxSize: 0.95,
  snapSizes: [0.4, 0.8, 0.95],
);

ResponsiveModalBottomSheet.show(
  context: context,
  customConfig: customConfig,
  builder: (context, scrollController) => YourContent(),
)
```

### Conditional Layouts
```dart
ResponsiveBuilder(
  builder: (context, deviceType) {
    return switch (deviceType) {
      DeviceType.iPhone => PhoneLayout(),
      DeviceType.iPadMini => TabletLayout(),
      DeviceType.iPadPro => DesktopLikeLayout(),
    };
  },
)
```

## 📊 Performance Benefits

- **Reduced MediaQuery calls**: Centralized responsive logic
- **Consistent calculations**: Cached device type detection
- **Optimized layouts**: Device-specific optimizations
- **Better UX**: Tailored experiences for each device type

## 🐛 Troubleshooting

### Common Issues

1. **Text too small on iPad**: Use `ResponsiveText` instead of `Text`
2. **Inconsistent spacing**: Use `ResponsiveSpacing` enum values
3. **Modal too large on iPhone**: Use `ResponsiveUtils.getModalConfig()`
4. **Icons not scaling**: Use `ResponsiveIcon` instead of `Icon`

### Debug Device Detection
```dart
print('Device Type: ${ResponsiveUtils.getDeviceType(context)}');
print('Is iPhone: ${ResponsiveUtils.isIPhone(context)}');
print('Is iPad: ${ResponsiveUtils.isIPad(context)}');
```

## 📝 Examples in Your Codebase

See the updated `expanded_recipe_dialog.dart` for a complete example of how to migrate from the old system to the new responsive system.

---

This responsive system provides a solid foundation for building consistent, beautiful interfaces across all iOS devices. The system is designed to grow with your app and can be easily extended as needed.
