import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';

/// Resource Entity
/// Represents educational content (articles, videos, tips) for food waste reduction
class Resource {
  final String id;
  final String title;
  final String description;
  final String content; // Full article/video content
  final ResourceCategory category;
  final ResourceType type;
  final String imageUrl;
  final String? videoUrl;
  final int readTimeMinutes; // Estimated reading time
  final DateTime publishedDate;
  final List<String> tags;
  final int views;
  final int likes;
  final bool isBookmarked;

  const Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.type,
    required this.imageUrl,
    this.videoUrl,
    required this.readTimeMinutes,
    required this.publishedDate,
    required this.tags,
    this.views = 0,
    this.likes = 0,
    this.isBookmarked = false,
  });

  Resource copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    ResourceCategory? category,
    ResourceType? type,
    String? imageUrl,
    String? videoUrl,
    int? readTimeMinutes,
    DateTime? publishedDate,
    List<String>? tags,
    int? views,
    int? likes,
    bool? isBookmarked,
  }) {
    return Resource(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      category: category ?? this.category,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      publishedDate: publishedDate ?? this.publishedDate,
      tags: tags ?? this.tags,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

/// Resource Categories
enum ResourceCategory {
  wasteReduction,
  storageTips,
  budgetPlanning,
  recipes,
  composting,
  nutrition,
  sustainability,
  mealPrep;

  String get label {
    switch (this) {
      case ResourceCategory.wasteReduction:
        return 'Waste Reduction';
      case ResourceCategory.storageTips:
        return 'Storage Tips';
      case ResourceCategory.budgetPlanning:
        return 'Budget Planning';
      case ResourceCategory.recipes:
        return 'Recipes';
      case ResourceCategory.composting:
        return 'Composting';
      case ResourceCategory.nutrition:
        return 'Nutrition';
      case ResourceCategory.sustainability:
        return 'Sustainability';
      case ResourceCategory.mealPrep:
        return 'Meal Prep';
    }
  }

  dynamic get icon {
    switch (this) {
      case ResourceCategory.wasteReduction:
        return HugeIcons.strokeRoundedRecycle03;
      case ResourceCategory.storageTips:
        return HugeIcons.strokeRoundedPackage;
      case ResourceCategory.budgetPlanning:
        return HugeIcons.strokeRoundedDollar02;
      case ResourceCategory.recipes:
        return HugeIcons.strokeRoundedCookBook;
      case ResourceCategory.composting:
        return HugeIcons.strokeRoundedLeaf01;
      case ResourceCategory.nutrition:
        return HugeIcons.strokeRoundedApple;
      case ResourceCategory.sustainability:
        return HugeIcons.strokeRoundedEarth;
      case ResourceCategory.mealPrep:
        return HugeIcons.strokeRoundedKitchenUtensils;
    }
  }

  Color get color {
    switch (this) {
      case ResourceCategory.wasteReduction:
        return AppColors.primaryGreen;
      case ResourceCategory.storageTips:
        return AppColors.infoBlue;
      case ResourceCategory.budgetPlanning:
        return AppColors.secondaryOrange;
      case ResourceCategory.recipes:
        return AppColors.errorRed;
      case ResourceCategory.composting:
        return AppColors.successGreen;
      case ResourceCategory.nutrition:
        return const Color(0xFFE91E63); // Pink
      case ResourceCategory.sustainability:
        return const Color(0xFF00BCD4); // Cyan
      case ResourceCategory.mealPrep:
        return AppColors.warningYellow;
    }
  }
}

/// Resource Types
enum ResourceType {
  article,
  video,
  infographic,
  guide;

  String get label {
    switch (this) {
      case ResourceType.article:
        return 'Article';
      case ResourceType.video:
        return 'Video';
      case ResourceType.infographic:
        return 'Infographic';
      case ResourceType.guide:
        return 'Guide';
    }
  }

  dynamic get icon {
    switch (this) {
      case ResourceType.article:
        return HugeIcons.strokeRoundedFileView;
      case ResourceType.video:
        return HugeIcons.strokeRoundedVideo01;
      case ResourceType.infographic:
        return HugeIcons.strokeRoundedImage01;
      case ResourceType.guide:
        return HugeIcons.strokeRoundedBookOpen02;
    }
  }
}

/// Category Badge Widget
class ResourceCategoryBadge extends StatelessWidget {
  final ResourceCategory category;
  final bool small;

  const ResourceCategoryBadge({
    super.key,
    required this.category,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 12,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: category.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: category.icon,
            size: small ? 12 : 14,
            color: category.color,
          ),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: TextStyle(
              fontSize: small ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sample Resources for Development
class ResourceSamples {
  static final featured = Resource(
    id: '1',
    title: '5 Ways to Use Overripe Bananas',
    description: 'Don\'t throw them away! Transform overripe bananas into delicious treats with these creative recipes.',
    content: '''
# 5 Ways to Use Overripe Bananas

Don't throw those brown bananas away! They're perfect for:

## 1. Banana Bread
The classic use for overripe bananas. The sweeter and softer they are, the better your bread will taste.

## 2. Smoothies
Frozen overripe bananas make smoothies extra creamy and sweet without added sugar.

## 3. Pancakes
Mash them into your pancake batter for naturally sweet, fluffy pancakes.

## 4. Nice Cream
Blend frozen bananas for a healthy, dairy-free ice cream alternative.

## 5. Banana Muffins
Similar to banana bread but in convenient, portable portions.

These methods help reduce food waste while creating delicious treats!
    ''',
    category: ResourceCategory.recipes,
    type: ResourceType.article,
    imageUrl: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e',
    readTimeMinutes: 5,
    publishedDate: DateTime.now().subtract(const Duration(days: 2)),
    tags: ['banana', 'recipes', 'food waste', 'baking'],
    views: 1245,
    likes: 89,
  );

  static final List<Resource> items = [
    featured,
    Resource(
      id: '2',
      title: 'Smart Food Storage Tips',
      description: 'Learn professional techniques to keep your produce fresh longer and reduce waste.',
      content: '''
# Smart Food Storage Tips

Proper storage can extend the life of your food significantly.

## Vegetables
- Store leafy greens in airtight containers with paper towels
- Keep onions and potatoes separate and in dark, cool places
- Store herbs like flowers in water

## Fruits
- Separate ethylene producers (apples, bananas) from sensitive items
- Store berries unwashed until ready to eat
- Keep citrus at room temperature for best flavor

## Dairy
- Store cheese in wax paper, not plastic
- Keep milk in the coldest part of the fridge (not the door)
- Freeze butter for long-term storage

These tips will help you save money and reduce waste!
      ''',
      category: ResourceCategory.storageTips,
      type: ResourceType.guide,
      imageUrl: 'https://images.unsplash.com/photo-1588964895597-cfccd6e2dbf9',
      readTimeMinutes: 8,
      publishedDate: DateTime.now().subtract(const Duration(days: 5)),
      tags: ['storage', 'preservation', 'vegetables', 'fruits'],
      views: 2156,
      likes: 143,
    ),
    Resource(
      id: '3',
      title: 'Meal Planning on a Budget',
      description: 'Plan your meals efficiently to save money and minimize food waste throughout the week.',
      content: '''
# Meal Planning on a Budget

Strategic meal planning is key to reducing waste and saving money.

## Weekly Planning Tips
1. Inventory your pantry first
2. Plan meals around sales and seasonal produce
3. Use overlapping ingredients
4. Prep ingredients in advance
5. Cook in batches

## Budget-Friendly Strategies
- Buy generic brands
- Shop seasonally
- Use frozen vegetables
- Cook from scratch
- Embrace meatless meals

Start small and build the habit gradually!
      ''',
      category: ResourceCategory.budgetPlanning,
      type: ResourceType.article,
      imageUrl: 'https://images.unsplash.com/photo-1466637574441-749b8f19452f',
      readTimeMinutes: 6,
      publishedDate: DateTime.now().subtract(const Duration(days: 7)),
      tags: ['budget', 'meal planning', 'savings', 'weekly prep'],
      views: 3421,
      likes: 267,
    ),
    Resource(
      id: '4',
      title: 'Composting Basics for Beginners',
      description: 'Turn your food scraps into nutrient-rich soil for your garden with this beginner-friendly guide.',
      content: '''
# Composting Basics for Beginners

Transform food waste into garden gold!

## What to Compost
✅ Fruit and vegetable scraps
✅ Coffee grounds and filters
✅ Eggshells
✅ Yard waste

❌ Meat and dairy
❌ Diseased plants
❌ Pet waste

## Getting Started
1. Choose a composting method
2. Start collecting scraps
3. Layer greens and browns
4. Keep it moist
5. Turn regularly

Your garden will thank you!
      ''',
      category: ResourceCategory.composting,
      type: ResourceType.guide,
      imageUrl: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449',
      readTimeMinutes: 7,
      publishedDate: DateTime.now().subtract(const Duration(days: 10)),
      tags: ['composting', 'sustainability', 'gardening', 'eco-friendly'],
      views: 1876,
      likes: 156,
    ),
    Resource(
      id: '5',
      title: 'Understanding Food Labels and Dates',
      description: 'Decode expiration dates to prevent throwing away perfectly good food prematurely.',
      content: '''
# Understanding Food Labels and Dates

Stop wasting food due to confusion about dates!

## Types of Dates
- **Best By**: Quality date, not safety
- **Use By**: Last recommended use date
- **Sell By**: For retailers, not consumers
- **Freeze By**: When to freeze for best quality

## General Guidelines
Most foods are safe past these dates if stored properly. Use your senses:
- Look for mold or discoloration
- Smell for off odors
- Check texture changes

When in doubt, research the specific food item!
      ''',
      category: ResourceCategory.wasteReduction,
      type: ResourceType.article,
      imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136',
      readTimeMinutes: 4,
      publishedDate: DateTime.now().subtract(const Duration(days: 3)),
      tags: ['food labels', 'expiration dates', 'food safety', 'waste reduction'],
      views: 2943,
      likes: 198,
    ),
    Resource(
      id: '6',
      title: 'Zero Waste Kitchen Swaps',
      description: 'Simple sustainable swaps to reduce waste in your kitchen and help the planet.',
      content: '''
# Zero Waste Kitchen Swaps

Small changes, big impact!

## Easy Swaps
1. Beeswax wraps instead of plastic wrap
2. Glass containers instead of zip bags
3. Cloth napkins instead of paper
4. Reusable produce bags
5. Compostable dish sponges

## Benefits
- Reduce plastic waste
- Save money long-term
- Healthier for your family
- Better for the environment

Start with one swap and build from there!
      ''',
      category: ResourceCategory.sustainability,
      type: ResourceType.infographic,
      imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09',
      readTimeMinutes: 5,
      publishedDate: DateTime.now().subtract(const Duration(days: 12)),
      tags: ['zero waste', 'sustainability', 'eco-friendly', 'kitchen'],
      views: 1654,
      likes: 123,
    ),
  ];
}
