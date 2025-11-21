# Consumption Feature - UI Components Gallery

## Widget Showcase

This document provides visual descriptions and usage examples for all created UI components.

---

## 1. ConsumptionLogCard

**File:** `consumption_log_card.dart`

### Visual Description
```
┌────────────────────────────────────────────────┐
│  🥛 Dairy                          [✏️] [🗑️]   │
│                                                │
│  Oat Milk                                      │
│  ⚖️ 0.5 L                                      │
│                                                │
│  ┌──────────────────────────────────────────┐ │
│  │ 📝 Used in breakfast cereal.             │ │
│  └──────────────────────────────────────────┘ │
│                                                │
│  🕐 3 hours ago    📅 Today                    │
└────────────────────────────────────────────────┘
```

### Features
- **Header:** Category badge + action buttons (edit/delete)
- **Body:** Item name, quantity with icon, optional notes
- **Footer:** Time ago + formatted date
- **Interactive:** Tap to view details, edit and delete buttons
- **Elevation:** 2dp shadow for depth
- **Radius:** 12px rounded corners

### Usage
```dart
ConsumptionLogCard(
  log: ConsumptionLog(
    id: 'log-001',
    itemName: 'Oat Milk',
    quantity: 0.5,
    unit: 'L',
    category: ConsumptionCategory.dairy,
    date: DateTime.now().subtract(Duration(hours: 3)),
    notes: 'Used in breakfast cereal.',
    userId: 'user-123',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  onTap: () => print('View details'),
  onEdit: () => print('Edit log'),
  onDelete: () => print('Delete log'),
)
```

---

## 2. CategoryFilterChip

**File:** `category_filter_chip.dart`

### Visual Description
```
Unselected State:
┌─────────────────┐
│ 🥛  Dairy       │  ← Light green background, green border
└─────────────────┘

Selected State:
┌─────────────────┐
│ 🥛  Dairy       │  ← Solid green background, white text
└─────────────────┘
```

### Features
- **States:** Selected (filled) / Unselected (outlined)
- **Animation:** Smooth 200ms transition between states
- **Customizable:** Icon, label, and accent color
- **Rounded:** Pill-shaped (100px radius)

### Usage
```dart
Row(
  children: [
    CategoryFilterChip(
      label: 'Dairy',
      icon: Icons.local_drink_outlined,
      isSelected: selectedCategory == 'dairy',
      onTap: () => setState(() => selectedCategory = 'dairy'),
      accentColor: AppColors.primaryGreenLight,
    ),
    SizedBox(width: 8),
    CategoryFilterChip(
      label: 'Fruit',
      icon: Icons.energy_savings_leaf_outlined,
      isSelected: selectedCategory == 'fruit',
      onTap: () => setState(() => selectedCategory = 'fruit'),
      accentColor: AppColors.secondaryOrangeLight,
    ),
  ],
)
```

---

## 3. StatisticsCard

**File:** `statistics_card.dart`

### Visual Description
```
┌────────────────────────────────────┐
│  ┌────┐                         →  │
│  │ 🍽️ │                            │
│  └────┘                            │
│                                    │
│  87                                │
│  Total Logs                        │
│  +12 this week                     │
└────────────────────────────────────┘
```

### Features
- **Icon:** Colored background with 10% opacity
- **Value:** Large heading (h2) typography
- **Title:** Descriptive label
- **Subtitle:** Optional additional info (e.g., growth)
- **Arrow:** Shows when tappable
- **Elevation:** 2dp card shadow

### Usage
```dart
GridView.count(
  crossAxisCount: 2,
  children: [
    StatisticsCard(
      title: 'Total Logs',
      value: '87',
      icon: Icons.restaurant,
      iconColor: AppColors.primaryGreen,
      subtitle: '+12 this week',
      onTap: () => navigateToDetails(),
    ),
    StatisticsCard(
      title: 'This Month',
      value: '32',
      icon: Icons.calendar_month,
      iconColor: AppColors.secondaryOrange,
    ),
  ],
)
```

---

## 4. CategoryDistributionChart

**File:** `category_distribution_chart.dart`

### Visual Description
```
┌──────────────────────────────────────────┐
│  Category Distribution                   │
│                                          │
│  Dairy               36.8%               │
│  ████████████████████░░░░░░░░░           │
│                                          │
│  Fruit               32.2%               │
│  ████████████████░░░░░░░░░░░░            │
│                                          │
│  Grain               31.0%               │
│  ███████████████░░░░░░░░░░░░░            │
└──────────────────────────────────────────┘
```

### Features
- **Bars:** Horizontal progress bars scaled to max value
- **Labels:** Category name + percentage
- **Colors:** Custom per category (from categoryColors map)
- **Empty State:** Shows message when no data
- **Responsive:** Bars adjust based on values

### Usage
```dart
CategoryDistributionChart(
  categoryData: {
    'Dairy': 32.0,
    'Fruit': 28.0,
    'Grain': 27.0,
  },
  categoryColors: {
    'Dairy': AppColors.primaryGreenLight,
    'Fruit': AppColors.secondaryOrangeLight,
    'Grain': Color(0xFFB8D4C5),
  },
)
```

---

## 5. EmptyStateWidget

**File:** `empty_state_widget.dart`

### Visual Description
```
┌──────────────────────────────────────┐
│                                      │
│           ┌────────┐                 │
│           │        │                 │
│           │   🍽️   │                 │
│           │        │                 │
│           └────────┘                 │
│                                      │
│        No Logs Yet                   │
│   Start tracking your food           │
│        consumption                   │
│                                      │
│      ┌──────────────────┐            │
│      │  + Add First Log │            │
│      └──────────────────┘            │
└──────────────────────────────────────┘
```

### Features
- **Icon:** Large (72px) in circular background (10% opacity)
- **Title:** h3 heading
- **Subtitle:** Body text explaining state
- **Action:** Optional button to resolve empty state
- **Centered:** All elements vertically and horizontally centered

### Usage
```dart
// In list view when empty
if (logs.isEmpty)
  EmptyStateWidget(
    title: 'No Logs Yet',
    subtitle: 'Start tracking your food consumption to see insights',
    icon: Icons.eco_outlined,
    actionText: 'Add First Log',
    onAction: () => showAddLogDialog(),
  )
```

---

## 6. LoadingWidget

**File:** `loading_and_error_widgets.dart`

### Visual Description
```
┌──────────────────────────────────────┐
│                                      │
│              ⟳                       │
│        (Spinner animation)           │
│                                      │
│      Loading your logs...            │
│                                      │
└──────────────────────────────────────┘
```

### Features
- **Spinner:** Primary green CircularProgressIndicator
- **Message:** Optional descriptive text
- **Centered:** Vertically and horizontally
- **Simple:** Minimal distraction during loading

### Usage
```dart
if (state is ConsumptionLoading)
  LoadingWidget(
    message: 'Loading your consumption logs...',
  )
```

---

## 7. ErrorWidget

**File:** `loading_and_error_widgets.dart`

### Visual Description
```
┌──────────────────────────────────────┐
│                                      │
│           ┌────────┐                 │
│           │   ⚠️   │                 │
│           └────────┘                 │
│                                      │
│       Failed to Load                 │
│   Could not fetch consumption        │
│            logs                      │
│                                      │
│      ┌──────────────────┐            │
│      │   🔄  Retry      │            │
│      └──────────────────┘            │
└──────────────────────────────────────┘
```

### Features
- **Icon:** Error icon (48px) in red circular background
- **Title:** h4 heading
- **Message:** Descriptive error text
- **Retry:** Optional outlined button
- **Colors:** Error red for icon, primary green for retry button

### Usage
```dart
if (state is ConsumptionError)
  ErrorWidget(
    title: 'Failed to Load',
    message: state.message,
    onRetry: () => context.read<ConsumptionBloc>().add(LoadLogs()),
  )
```

---

## Design System Compliance Summary

### All Widgets Follow:

#### ✅ Color System
- Primary: `AppColors.primaryGreen` (#307A59)
- Secondary: `AppColors.secondaryOrange` (#FF9800)
- Neutrals: White, grays, black
- Semantic: Success, error, warning, info

#### ✅ Typography
- Headings: h1-h6 (32px to 16px)
- Body: bodyLarge (16px), bodyMedium (14px), bodySmall (12px)
- Button: semiBold, 0.5px letter spacing
- Caption: 10px for metadata

#### ✅ Spacing (8px Grid)
- XS: 4px
- SM: 8px
- MD: 16px (default)
- LG: 24px
- XL: 32px
- XXL: 40px
- XXXL: 48px

#### ✅ Border Radius
- XS: 4px (progress bars)
- SM: 8px (buttons, small containers)
- MD: 12px (cards, main containers)
- Round: 100px (chips, pills)

#### ✅ Elevation
- Low: 2dp (cards)
- Medium: 4dp (elevated elements)
- None: 0dp (flat surfaces)

#### ✅ Icon Sizes
- XS: 16px (metadata icons)
- SM: 20px (list icons, chips)
- MD: 24px (standard icons)
- LG: 32px (featured icons)
- XL: 48px (empty states)

#### ✅ Accessibility
- Contrast ratios: WCAG AA compliant
- Touch targets: ≥ 44x44px
- Semantic colors for status
- Screen reader friendly
- Clear visual hierarchy

---

## Integration Examples

### Complete Page Layout

```dart
class ConsumptionLogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumption Logs'),
        backgroundColor: AppColors.neutralWhite,
        foregroundColor: AppColors.neutralBlack,
        elevation: 0,
      ),
      body: BlocBuilder<ConsumptionBloc, ConsumptionState>(
        builder: (context, state) {
          if (state is ConsumptionLoading) {
            return LoadingWidget(
              message: 'Loading your logs...',
            );
          }
          
          if (state is ConsumptionError) {
            return ErrorWidget(
              title: 'Failed to Load',
              message: state.message,
              onRetry: () => context.read<ConsumptionBloc>().add(LoadLogs()),
            );
          }
          
          if (state is ConsumptionLoaded) {
            if (state.logs.isEmpty) {
              return EmptyStateWidget(
                title: 'No Logs Yet',
                subtitle: 'Start tracking your food consumption',
                icon: Icons.eco_outlined,
                actionText: 'Add First Log',
                onAction: () => showAddDialog(context),
              );
            }
            
            return Column(
              children: [
                // Filters
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      CategoryFilterChip(
                        label: 'All',
                        icon: Icons.filter_list,
                        isSelected: selectedFilter == null,
                        onTap: () => clearFilter(),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      CategoryFilterChip(
                        label: 'Dairy',
                        icon: Icons.local_drink_outlined,
                        isSelected: selectedFilter == 'dairy',
                        onTap: () => filterByCategory('dairy'),
                        accentColor: AppColors.primaryGreenLight,
                      ),
                      // More filters...
                    ],
                  ),
                ),
                
                // List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: state.logs.length,
                    itemBuilder: (context, index) {
                      final log = state.logs[index];
                      return ConsumptionLogCard(
                        log: log,
                        onTap: () => navigateToDetails(log),
                        onEdit: () => showEditDialog(log),
                        onDelete: () => confirmDelete(log),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddDialog(context),
        backgroundColor: AppColors.primaryGreen,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Statistics Dashboard

```dart
class StatisticsDashboard extends StatelessWidget {
  final ConsumptionStatistics stats;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.2,
            children: [
              StatisticsCard(
                title: 'Total Logs',
                value: '${stats.totalLogs}',
                icon: Icons.restaurant,
                iconColor: AppColors.primaryGreen,
              ),
              StatisticsCard(
                title: 'Avg/Day',
                value: stats.averageLogsPerDay.toStringAsFixed(1),
                icon: Icons.show_chart,
                iconColor: AppColors.secondaryOrange,
              ),
            ],
          ),
          
          SizedBox(height: AppSpacing.lg),
          
          // Distribution Chart
          CategoryDistributionChart(
            categoryData: {
              'Dairy': stats.byCategory['dairy']?.count.toDouble() ?? 0,
              'Fruit': stats.byCategory['fruit']?.count.toDouble() ?? 0,
              'Grain': stats.byCategory['grain']?.count.toDouble() ?? 0,
            },
            categoryColors: {
              'Dairy': AppColors.primaryGreenLight,
              'Fruit': AppColors.secondaryOrangeLight,
              'Grain': Color(0xFFB8D4C5),
            },
          ),
          
          SizedBox(height: AppSpacing.lg),
          
          // Top Items
          Text('Most Consumed', style: AppTypography.h4),
          SizedBox(height: AppSpacing.md),
          ...stats.topItems.map((item) => _buildTopItemRow(item)),
        ],
      ),
    );
  }
}
```

---

## Color Reference Quick Guide

### Category Colors
```dart
Map<ConsumptionCategory, Color> categoryColors = {
  ConsumptionCategory.dairy: AppColors.primaryGreenLight,    // #81C784
  ConsumptionCategory.fruit: AppColors.secondaryOrangeLight, // #FFB74D
  ConsumptionCategory.grain: Color(0xFFB8D4C5),              // Muted herb
};
```

### Status Colors
```dart
// Success states
AppColors.successGreen  // #66BB6A

// Error states
AppColors.errorRed      // #E53935

// Warning states
AppColors.warningYellow // #FFC107

// Info states
AppColors.infoBlue      // #42A5F5
```

---

**UI Components Gallery**  
*Created following FoodFlow Design System v1.0.0*  
*Date: November 21, 2025*
