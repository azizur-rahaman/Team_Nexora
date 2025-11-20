# FoodFlow Design System

**Version:** 1.0.0  
**Last Updated:** November 20, 2025

## Table of Contents
- [Introduction](#introduction)
- [Design Principles](#design-principles)
- [Color System](#color-system)
- [Typography](#typography)
- [Spacing & Layout](#spacing--layout)
- [Components](#components)
- [Animations](#animations)
- [Accessibility](#accessibility)
- [Usage Guidelines](#usage-guidelines)

---

## Introduction

The FoodFlow Design System is a comprehensive collection of reusable components, design tokens, and guidelines that ensure consistency, accessibility, and efficiency across the application. Built with Flutter and following Material Design 3 principles, this system emphasizes sustainability, clarity, and user-friendliness.

### Design Philosophy

- **Sustainable**: Green color palette reflecting eco-friendly values
- **Modern**: Clean, minimalist aesthetics with purposeful elements
- **Accessible**: WCAG 2.1 AA compliant with high contrast ratios
- **Responsive**: Adaptive layouts using 8px grid system
- **Consistent**: Unified visual language across all screens

---

## Design Principles

### 1. **Clarity First**
Every element should have a clear purpose. Avoid unnecessary decorations that don't enhance user understanding.

### 2. **Sustainable Design**
Reflect environmental consciousness through green color palette and nature-inspired imagery.

### 3. **Progressive Disclosure**
Show information progressively to avoid overwhelming users. Use animations to guide attention.

### 4. **Feedback & Response**
Provide immediate, clear feedback for all user actions through animations, colors, and micro-interactions.

### 5. **Accessibility**
Design for everyone. Maintain high contrast, support screen readers, and provide alternative interactions.

---

## Color System

### Primary Colors - Green Theme

The green color palette represents freshness, sustainability, and environmental consciousness.

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Primary Green** | `#4CAF50` | `76, 175, 80` | Primary actions, CTAs, active states |
| **Primary Green Light** | `#81C784` | `129, 199, 132` | Hover states, backgrounds, highlights |
| **Primary Green Dark** | `#388E3C` | `56, 142, 60` | Pressed states, accents |

```dart
AppColors.primaryGreen
AppColors.primaryGreenLight
AppColors.primaryGreenDark
```

### Secondary Colors - Orange Accent

Orange brings energy and warmth, used for secondary actions and highlights.

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Secondary Orange** | `#FF9800` | `255, 152, 0` | Secondary actions, warnings |
| **Secondary Orange Light** | `#FFB74D` | `255, 183, 77` | Hover states, badges |
| **Secondary Orange Dark** | `#F57C00` | `245, 124, 0` | Active states, emphasis |

```dart
AppColors.secondaryOrange
AppColors.secondaryOrangeLight
AppColors.secondaryOrangeDark
```

### Neutral Colors

Professional grayscale for text, backgrounds, and UI elements.

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Neutral White** | `#FFFFFF` | `255, 255, 255` | Backgrounds, surfaces |
| **Neutral Light Gray** | `#F5F5F5` | `245, 245, 245` | Secondary backgrounds |
| **Neutral Gray** | `#9E9E9E` | `158, 158, 158` | Borders, disabled text |
| **Neutral Dark Gray** | `#616161` | `97, 97, 97` | Secondary text |
| **Neutral Black** | `#212121` | `33, 33, 33` | Primary text, headings |

```dart
AppColors.neutralWhite
AppColors.neutralLightGray
AppColors.neutralGray
AppColors.neutralDarkGray
AppColors.neutralBlack
```

### Semantic Colors

Status-specific colors for feedback and alerts.

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| **Success Green** | `#66BB6A` | `102, 187, 106` | Success messages, confirmations |
| **Error Red** | `#E53935` | `229, 57, 53` | Errors, destructive actions |
| **Warning Yellow** | `#FFC107` | `255, 193, 7` | Warnings, important info |
| **Info Blue** | `#42A5F5` | `66, 165, 245` | Informational messages |

```dart
AppColors.successGreen
AppColors.errorRed
AppColors.warningYellow
AppColors.infoBlue
```

### Gradients

Pre-defined gradients for visual interest and depth.

```dart
// Primary Gradient (Green to Dark Green)
AppColors.primaryGradient

// Secondary Gradient (Orange to Dark Orange)
AppColors.secondaryGradient
```

### Color Usage Guidelines

#### Contrast Ratios
- **Primary Text on White**: 16.1:1 (AAA)
- **Primary Green on White**: 3.1:1 (AA for large text)
- **Secondary Text on White**: 5.9:1 (AA)

#### Best Practices
- Use primary green for main CTAs and important actions
- Use secondary orange sparingly for emphasis
- Maintain at least 4.5:1 contrast for body text
- Use semantic colors consistently across the app
- Avoid pure black (`#000000`); use Neutral Black instead

---

## Typography

### Font Families

**Primary Font:** Roboto (Sans-serif)  
**Secondary Font:** Poppins (For special emphasis)

### Type Scale

| Style | Size | Weight | Line Height | Letter Spacing | Usage |
|-------|------|--------|-------------|----------------|-------|
| **H1** | 32px | Bold (700) | 1.2 | -0.5px | Page titles |
| **H2** | 28px | Bold (700) | 1.2 | -0.5px | Section headers |
| **H3** | 24px | SemiBold (600) | 1.2 | 0px | Card titles |
| **H4** | 20px | SemiBold (600) | 1.5 | 0px | Subsections |
| **H5** | 18px | Medium (500) | 1.5 | 0px | Small headings |
| **H6** | 16px | Medium (500) | 1.5 | 0.5px | Labels, tags |
| **Body Large** | 16px | Regular (400) | 1.5 | 0.5px | Main content |
| **Body Medium** | 14px | Regular (400) | 1.5 | 0px | Secondary content |
| **Body Small** | 12px | Regular (400) | 1.5 | 0px | Captions |
| **Button** | 14px | SemiBold (600) | - | 0.5px | Button text |
| **Caption** | 10px | Regular (400) | 1.5 | 0.5px | Fine print |

### Usage Examples

```dart
// Headings
Text('Welcome', style: AppTypography.h1)
Text('Dashboard', style: AppTypography.h2)

// Body Text
Text('Your food inventory', style: AppTypography.bodyLarge)
Text('Expires soon', style: AppTypography.bodyMedium)

// Special
Text('Learn more', style: AppTypography.link)
Text('Required*', style: AppTypography.caption)
```

### Font Weight System

```dart
AppTypography.light      // 300 - Rarely used
AppTypography.regular    // 400 - Body text
AppTypography.medium     // 500 - Emphasis
AppTypography.semiBold   // 600 - Headings, buttons
AppTypography.bold       // 700 - Titles, strong emphasis
```

### Typography Guidelines

#### Hierarchy
1. Use one H1 per screen for the main title
2. Progressively decrease heading sizes for sub-sections
3. Maintain consistent hierarchy throughout the app

#### Line Length
- Optimal: 50-75 characters per line
- Maximum: 90 characters per line
- Use padding to constrain text width

#### Readability
- Minimum font size: 12px (captions only)
- Body text: 14-16px for optimal readability
- Line height: 1.5 for body text, 1.2 for headings

---

## Spacing & Layout

### 8px Grid System

All spacing follows an 8px base unit for consistency and rhythm.

| Token | Value | Usage |
|-------|-------|-------|
| **XS** | 4px | Tight spacing, icon padding |
| **SM** | 8px | Compact layouts, chip padding |
| **MD** | 16px | Default spacing, button padding |
| **LG** | 24px | Section spacing, card padding |
| **XL** | 32px | Page margins, large gaps |
| **XXL** | 40px | Major section breaks |
| **XXXL** | 48px | Screen padding |

```dart
// Padding
EdgeInsets.all(AppSpacing.md)        // 16px
EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md)

// Margins
SizedBox(height: AppSpacing.xl)      // 32px vertical gap
SizedBox(width: AppSpacing.sm)       // 8px horizontal gap
```

### Border Radius

Rounded corners for modern, friendly aesthetics.

| Token | Value | Usage |
|-------|-------|-------|
| **XS** | 4px | Small elements, tags |
| **SM** | 8px | Buttons, inputs, chips |
| **MD** | 12px | Cards, containers |
| **LG** | 16px | Large cards, modals |
| **XL** | 20px | Special containers |
| **Round** | 100px | Circular elements |

```dart
BorderRadius.circular(AppSpacing.radiusSM)  // 8px
BorderRadius.circular(AppSpacing.radiusMD)  // 12px
```

### Component Heights

Standardized heights for interactive elements.

| Component | Size | Height |
|-----------|------|--------|
| **Button SM** | Small | 32px |
| **Button MD** | Medium | 40px |
| **Button LG** | Large | 48px |
| **Button XL** | Extra Large | 56px |
| **Input SM** | Small | 32px |
| **Input MD** | Medium | 40px |
| **Input LG** | Large | 48px |
| **App Bar** | Standard | 56px |
| **App Bar** | Large | 64px |
| **Bottom Nav** | Fixed | 56px |

### Icon Sizes

| Token | Size | Usage |
|-------|------|-------|
| **XS** | 16px | Inline icons, small badges |
| **SM** | 20px | List items, small buttons |
| **MD** | 24px | Default icons, toolbar |
| **LG** | 32px | Featured icons, FAB |
| **XL** | 48px | Large illustrations |

```dart
Icon(Icons.home, size: AppSpacing.iconMD)  // 24px
Icon(Icons.add, size: AppSpacing.iconLG)   // 32px
```

### Elevation System

Shadow depths for Material Design hierarchy.

| Level | Value | Usage |
|-------|-------|-------|
| **None** | 0dp | Flat surfaces |
| **Low** | 2dp | Cards, raised buttons |
| **Medium** | 4dp | FAB, elevated cards |
| **High** | 8dp | Modals, dialogs |

```dart
elevation: AppSpacing.elevationLow     // 2dp
elevation: AppSpacing.elevationMedium  // 4dp
```

### Responsive Breakpoints

Using `flutter_screenutil` for responsive design:

```dart
// Design base: 375x812 (iPhone standard)

// Width
100.w   // 100 logical pixels scaled to screen width
50.w    // 50 logical pixels scaled

// Height
100.h   // 100 logical pixels scaled to screen height
50.h    // 50 logical pixels scaled

// Font Size
16.sp   // 16sp scaled font size

// Radius
8.r     // 8 radius scaled
```

---

## Components

### Buttons

#### Elevated Button (Primary)
Primary action buttons with filled background.

```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Save'),
)
```

**Properties:**
- Background: Primary Green
- Text: White
- Height: 40-56px
- Border Radius: 8px
- Elevation: 2dp

**States:**
- Default: Primary Green
- Hover: Primary Green Light
- Pressed: Primary Green Dark
- Disabled: Neutral Gray

#### Outlined Button (Secondary)
Secondary actions with outlined style.

```dart
OutlinedButton(
  onPressed: () {},
  child: Text('Cancel'),
)
```

**Properties:**
- Border: Primary Green (1.5px)
- Text: Primary Green
- Background: Transparent
- Height: 40-56px

#### Text Button (Tertiary)
Low-emphasis actions.

```dart
TextButton(
  onPressed: () {},
  child: Text('Skip'),
)
```

### Input Fields

Standard text input with Material Design styling.

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Food Name',
    hintText: 'Enter food item',
  ),
)
```

**Properties:**
- Background: Neutral Light Gray
- Border: Neutral Gray (1px)
- Focused Border: Primary Green (2px)
- Error Border: Error Red (2px)
- Border Radius: 8px
- Height: 40-48px

### Cards

Contained content with elevation.

```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(AppSpacing.md),
    child: Column(children: [...]),
  ),
)
```

**Properties:**
- Background: White
- Border Radius: 12px
- Elevation: 2dp
- Padding: 16px

### Bottom Navigation

Fixed bottom navigation bar.

**Properties:**
- Height: 56px
- Background: White
- Selected: Primary Green
- Unselected: Neutral Gray
- Elevation: 4dp

### App Bar

Top navigation bar.

**Properties:**
- Height: 56px
- Background: White
- Text: Neutral Black
- Elevation: 0dp (flat)
- Icon Size: 24px

---

## Animations

### Loading Animations

#### Horizontal Rotating Dots
Used in splash screen for loading indication.

```dart
LoadingAnimationWidget.horizontalRotatingDots(
  color: AppColors.primaryGreen,
  size: 50.w,
)
```

### Text Animations

#### Typewriter Effect
Engaging text reveal for onboarding.

```dart
AnimatedTextKit(
  animatedTexts: [
    TypewriterAnimatedText(
      'Track Your Food Smarter',
      textStyle: AppTypography.h2,
      speed: Duration(milliseconds: 100),
    ),
  ],
  totalRepeatCount: 1,
  displayFullTextOnTap: true,
)
```

**Configuration:**
- Title Speed: 100ms per character
- Description Speed: 50ms per character
- Repeat: Once only
- Tap to complete: Enabled

### Transition Animations

#### Page Transitions
Smooth navigation between screens.

```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(opacity: animation, child: child);
  },
  transitionDuration: Duration(milliseconds: 500),
)
```

**Standard Durations:**
- Quick: 200ms (UI feedback)
- Standard: 300ms (page elements)
- Slow: 500ms (page transitions)

---

## Accessibility

### Color Contrast

All color combinations meet WCAG 2.1 AA standards.

| Combination | Ratio | Standard |
|-------------|-------|----------|
| Primary Text / White | 16.1:1 | AAA |
| Secondary Text / White | 5.9:1 | AA |
| Primary Green / White | 3.1:1 | AA (Large) |
| Error Red / White | 4.8:1 | AA |

### Touch Targets

Minimum touch target size: **44x44 px**

All interactive elements meet this minimum to ensure easy tapping.

### Screen Reader Support

- All images have descriptive alt text
- Buttons have semantic labels
- Form fields have proper labels
- Navigation is keyboard accessible

### Font Scaling

Support for system font size preferences:
- Minimum: 12sp
- Default: 14-16sp
- Maximum: 24sp (with graceful degradation)

---

## Usage Guidelines

### Do's ✅

- Use primary green for main actions and CTAs
- Maintain 8px grid alignment
- Follow typography hierarchy
- Provide visual feedback for interactions
- Use semantic colors for status messages
- Keep text contrast above 4.5:1
- Use responsive units (.w, .h, .sp, .r)

### Don'ts ❌

- Don't use pure black (#000000)
- Don't mix font families randomly
- Don't ignore spacing tokens
- Don't create custom colors outside the system
- Don't use small font sizes (<12px) except captions
- Don't stack more than 3 levels of elevation
- Don't use hard-coded pixel values

### Component Checklist

When creating new components:

- [ ] Uses design tokens (colors, spacing, typography)
- [ ] Follows 8px grid system
- [ ] Has proper hover/pressed/disabled states
- [ ] Meets accessibility standards (contrast, touch targets)
- [ ] Responsive with flutter_screenutil
- [ ] Has clear visual hierarchy
- [ ] Provides user feedback
- [ ] Documented with usage examples

---

## Code Examples

### Creating a Themed Button

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryGreen,
    foregroundColor: AppColors.neutralWhite,
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.lg.w,
      vertical: AppSpacing.md.h,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSM.r),
    ),
  ),
  child: Text('Save Changes', style: AppTypography.button),
)
```

### Creating a Themed Card

```dart
Card(
  elevation: AppSpacing.elevationLow,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSpacing.radiusMD.r),
  ),
  child: Padding(
    padding: EdgeInsets.all(AppSpacing.md.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Food Item', style: AppTypography.h5),
        SizedBox(height: AppSpacing.sm.h),
        Text('Expires in 2 days', style: AppTypography.bodyMedium),
      ],
    ),
  ),
)
```

### Creating Consistent Spacing

```dart
Column(
  children: [
    Widget1(),
    SizedBox(height: AppSpacing.md.h),
    Widget2(),
    SizedBox(height: AppSpacing.lg.h),
    Widget3(),
  ],
)
```

---

## Resources

### Design Tools
- **Figma**: For design mockups and prototypes
- **Material Theme Builder**: For color palette generation
- **Contrast Checker**: For accessibility validation

### Flutter Packages Used
- `flutter_screenutil`: Responsive design
- `animated_text_kit`: Text animations
- `loading_animation_widget`: Loading indicators

### References
- [Material Design 3](https://m3.material.io/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter Design Patterns](https://flutter.dev/docs/development/ui/widgets)

---

## Changelog

### Version 1.0.0 (November 20, 2025)
- Initial design system documentation
- Defined color palette with sustainability theme
- Established typography scale
- Created 8px grid spacing system
- Documented component specifications
- Added animation guidelines
- Included accessibility standards

---

**FoodFlow Design System**  
*Reduce Waste, Save Food* 🌱

**Maintained by:** Team Nexora  
**Last Review:** November 20, 2025
