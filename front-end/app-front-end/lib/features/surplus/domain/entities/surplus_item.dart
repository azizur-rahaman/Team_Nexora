import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';

/// Surplus Item Entity
/// Represents surplus food items shared by businesses or users in the community
class SurplusItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final SurplusType type; // donation or discounted
  final double? originalPrice;
  final double? discountedPrice;
  final int? discountPercentage;
  final int quantity;
  final String unit; // kg, pieces, servings, etc.
  final DateTime expiryDate;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final String businessId;
  final String businessName;
  final String businessType; // Restaurant, Bakery, Grocery, etc.
  final String businessLogo;
  final String pickupAddress;
  final double? latitude;
  final double? longitude;
  final SurplusStatus status;
  final List<String> allergens;
  final List<String> dietaryInfo; // Vegan, Halal, Gluten-Free, etc.
  final int views;
  final int claims;
  final DateTime createdAt;
  final String? notes;

  const SurplusItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercentage,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.pickupStartTime,
    required this.pickupEndTime,
    required this.businessId,
    required this.businessName,
    required this.businessType,
    required this.businessLogo,
    required this.pickupAddress,
    this.latitude,
    this.longitude,
    required this.status,
    this.allergens = const [],
    this.dietaryInfo = const [],
    this.views = 0,
    this.claims = 0,
    required this.createdAt,
    this.notes,
  });

  SurplusItem copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    SurplusType? type,
    double? originalPrice,
    double? discountedPrice,
    int? discountPercentage,
    int? quantity,
    String? unit,
    DateTime? expiryDate,
    DateTime? pickupStartTime,
    DateTime? pickupEndTime,
    String? businessId,
    String? businessName,
    String? businessType,
    String? businessLogo,
    String? pickupAddress,
    double? latitude,
    double? longitude,
    SurplusStatus? status,
    List<String>? allergens,
    List<String>? dietaryInfo,
    int? views,
    int? claims,
    DateTime? createdAt,
    String? notes,
  }) {
    return SurplusItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      pickupStartTime: pickupStartTime ?? this.pickupStartTime,
      pickupEndTime: pickupEndTime ?? this.pickupEndTime,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      businessLogo: businessLogo ?? this.businessLogo,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      allergens: allergens ?? this.allergens,
      dietaryInfo: dietaryInfo ?? this.dietaryInfo,
      views: views ?? this.views,
      claims: claims ?? this.claims,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  /// Calculate hours until expiry
  int get hoursUntilExpiry {
    return expiryDate.difference(DateTime.now()).inHours;
  }

  /// Check if item is expiring soon (within 12 hours)
  bool get isExpiringSoon {
    return hoursUntilExpiry <= 12 && hoursUntilExpiry > 0;
  }

  /// Check if pickup time is available now
  bool get isPickupAvailableNow {
    final now = DateTime.now();
    return now.isAfter(pickupStartTime) && now.isBefore(pickupEndTime);
  }

  /// Get formatted pickup time range
  String get pickupTimeRange {
    final start = _formatTime(pickupStartTime);
    final end = _formatTime(pickupEndTime);
    return '$start - $end';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Calculate savings amount
  double get savingsAmount {
    if (type == SurplusType.discounted && originalPrice != null && discountedPrice != null) {
      return originalPrice! - discountedPrice!;
    }
    return 0;
  }
}

/// Surplus Type
enum SurplusType {
  donation,
  discounted;

  String get label {
    switch (this) {
      case SurplusType.donation:
        return 'Free Donation';
      case SurplusType.discounted:
        return 'Discounted';
    }
  }

  Color get color {
    switch (this) {
      case SurplusType.donation:
        return AppColors.successGreen;
      case SurplusType.discounted:
        return AppColors.secondaryOrange;
    }
  }

  dynamic get icon {
    switch (this) {
      case SurplusType.donation:
        return HugeIcons.strokeRoundedGift;
      case SurplusType.discounted:
        return HugeIcons.strokeRoundedDollar02;
    }
  }
}

/// Surplus Status
enum SurplusStatus {
  available,
  claimed,
  expired,
  completed;

  String get label {
    switch (this) {
      case SurplusStatus.available:
        return 'Available';
      case SurplusStatus.claimed:
        return 'Claimed';
      case SurplusStatus.expired:
        return 'Expired';
      case SurplusStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case SurplusStatus.available:
        return AppColors.successGreen;
      case SurplusStatus.claimed:
        return AppColors.warningYellow;
      case SurplusStatus.expired:
        return AppColors.errorRed;
      case SurplusStatus.completed:
        return AppColors.neutralGray;
    }
  }
}

/// Type Badge Widget
class SurplusTypeBadge extends StatelessWidget {
  final SurplusType type;
  final int? discountPercentage;
  final bool large;

  const SurplusTypeBadge({
    super.key,
    required this.type,
    this.discountPercentage,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: type.color,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: type.color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: type.icon,
            size: large ? 18 : 14,
            color: AppColors.neutralWhite,
          ),
          const SizedBox(width: 6),
          Text(
            type == SurplusType.discounted && discountPercentage != null
                ? '$discountPercentage% OFF'
                : type.label,
            style: TextStyle(
              fontSize: large ? 14 : 12,
              fontWeight: FontWeight.w700,
              color: AppColors.neutralWhite,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sample Surplus Items for Development
class SurplusSamples {
  static final featured = SurplusItem(
    id: '1',
    title: 'Fresh Bakery Assortment',
    description: 'Mixed selection of fresh bread, pastries, and croissants from today\'s batch. Perfect condition, just surplus from daily production.',
    imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff',
    type: SurplusType.discounted,
    originalPrice: 25.00,
    discountedPrice: 10.00,
    discountPercentage: 60,
    quantity: 5,
    unit: 'boxes',
    expiryDate: DateTime.now().add(const Duration(hours: 8)),
    pickupStartTime: DateTime.now().add(const Duration(hours: 1)),
    pickupEndTime: DateTime.now().add(const Duration(hours: 6)),
    businessId: 'b1',
    businessName: 'Green Bakery',
    businessType: 'Bakery',
    businessLogo: 'https://via.placeholder.com/100',
    pickupAddress: '123 Main St, Downtown',
    latitude: 40.7128,
    longitude: -74.0060,
    status: SurplusStatus.available,
    allergens: ['Wheat', 'Eggs', 'Dairy'],
    dietaryInfo: ['Vegetarian'],
    views: 45,
    claims: 0,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    notes: 'Please bring your own bag!',
  );

  static final List<SurplusItem> items = [
    featured,
    SurplusItem(
      id: '2',
      title: 'Organic Vegetable Mix',
      description: 'Fresh organic vegetables slightly bruised but perfectly edible. Great for soups and stews.',
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999',
      type: SurplusType.donation,
      quantity: 10,
      unit: 'kg',
      expiryDate: DateTime.now().add(const Duration(hours: 24)),
      pickupStartTime: DateTime.now().add(const Duration(hours: 2)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 8)),
      businessId: 'b2',
      businessName: 'Fresh Farms Market',
      businessType: 'Grocery Store',
      businessLogo: 'https://via.placeholder.com/100',
      pickupAddress: '456 Farm Road, Suburbs',
      latitude: 40.7589,
      longitude: -73.9851,
      status: SurplusStatus.available,
      allergens: [],
      dietaryInfo: ['Vegan', 'Gluten-Free'],
      views: 78,
      claims: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    SurplusItem(
      id: '3',
      title: 'Restaurant Meal Packs',
      description: 'Pre-packaged complete meals from lunch service. Includes rice, curry, and vegetables.',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
      type: SurplusType.discounted,
      originalPrice: 15.00,
      discountedPrice: 5.00,
      discountPercentage: 67,
      quantity: 8,
      unit: 'meals',
      expiryDate: DateTime.now().add(const Duration(hours: 6)),
      pickupStartTime: DateTime.now(),
      pickupEndTime: DateTime.now().add(const Duration(hours: 4)),
      businessId: 'b3',
      businessName: 'Spice Kitchen',
      businessType: 'Restaurant',
      businessLogo: 'https://via.placeholder.com/100',
      pickupAddress: '789 Food Street, City Center',
      latitude: 40.7580,
      longitude: -73.9855,
      status: SurplusStatus.available,
      allergens: ['Dairy', 'Nuts'],
      dietaryInfo: ['Halal'],
      views: 125,
      claims: 5,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      notes: 'Hot meals ready for immediate pickup',
    ),
    SurplusItem(
      id: '4',
      title: 'Dairy Products Bundle',
      description: 'Milk, yogurt, and cheese approaching best-by date but still fresh and safe.',
      imageUrl: 'https://images.unsplash.com/photo-1628088062854-d1870b4553da',
      type: SurplusType.discounted,
      originalPrice: 20.00,
      discountedPrice: 8.00,
      discountPercentage: 60,
      quantity: 15,
      unit: 'items',
      expiryDate: DateTime.now().add(const Duration(days: 2)),
      pickupStartTime: DateTime.now().add(const Duration(hours: 3)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 10)),
      businessId: 'b4',
      businessName: 'Dairy Delight',
      businessType: 'Grocery Store',
      businessLogo: 'https://via.placeholder.com/100',
      pickupAddress: '321 Milk Lane, Northside',
      latitude: 40.7614,
      longitude: -73.9776,
      status: SurplusStatus.available,
      allergens: ['Dairy'],
      dietaryInfo: ['Vegetarian'],
      views: 92,
      claims: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    SurplusItem(
      id: '5',
      title: 'Fruit Basket Surprise',
      description: 'Mixed seasonal fruits - some with minor cosmetic imperfections but delicious!',
      imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf',
      type: SurplusType.donation,
      quantity: 20,
      unit: 'kg',
      expiryDate: DateTime.now().add(const Duration(days: 3)),
      pickupStartTime: DateTime.now().add(const Duration(hours: 1)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 7)),
      businessId: 'b5',
      businessName: 'Fruit Paradise',
      businessType: 'Produce Market',
      businessLogo: 'https://via.placeholder.com/100',
      pickupAddress: '555 Orchard Ave, Eastside',
      latitude: 40.7505,
      longitude: -73.9934,
      status: SurplusStatus.available,
      allergens: [],
      dietaryInfo: ['Vegan', 'Gluten-Free', 'Organic'],
      views: 156,
      claims: 8,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      notes: 'First come, first served!',
    ),
  ];
}
