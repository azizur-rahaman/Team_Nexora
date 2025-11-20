import '../models/surplus_item_model.dart';
import '../models/surplus_request_model.dart';
import '../../domain/entities/surplus_item.dart';

abstract class SurplusDataSource {
  Future<List<SurplusItemModel>> getAllSurplusItems();
  Future<SurplusItemModel> getSurplusItemById(String id);
  Future<List<SurplusItemModel>> getSurplusItemsByType(SurplusType type);
  Future<List<SurplusItemModel>> searchSurplusItems(String query);
  Future<List<SurplusItemModel>> filterSurplusItems({
    SurplusType? type,
    double? maxPrice,
    int? maxDistance,
  });
  Future<SurplusRequestModel> createSurplusRequest(SurplusRequestModel request);
  Future<List<SurplusRequestModel>> getUserRequests(String userId);
  Future<void> incrementViews(String id);
}

class SurplusDataSourceImpl implements SurplusDataSource {
  final List<SurplusItemModel> _mockItems = [];
  final List<SurplusRequestModel> _mockRequests = [];

  SurplusDataSourceImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final now = DateTime.now();
    _mockItems.addAll([
      SurplusItemModel(
        id: '1',
        title: 'Fresh Baguettes & Croissants',
        description: 'End-of-day fresh baguettes and croissants from our bakery.',
        imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff',
        type: SurplusType.discounted,
        originalPrice: 25.00,
        discountedPrice: 8.00,
        discountPercentage: 68,
        quantity: 5,
        unit: 'bags',
        expiryDate: now.add(const Duration(hours: 12)),
        pickupStartTime: now.add(const Duration(hours: 1)),
        pickupEndTime: now.add(const Duration(hours: 4)),
        businessId: 'b1',
        businessName: 'Artisan Bakery',
        businessType: 'Bakery',
        businessLogo: 'https://images.unsplash.com/photo-1509440159596-0249088772ff',
        pickupAddress: '123 Main Street, City Center',
        latitude: 23.8103,
        longitude: 90.4125,
        status: SurplusStatus.available,
        allergens: const ['Wheat', 'Eggs', 'Dairy'],
        dietaryInfo: const ['Vegetarian'],
        views: 245,
        claims: 12,
        createdAt: now.subtract(const Duration(hours: 2)),
        notes: 'Please bring your own bags for pickup',
      ),
      SurplusItemModel(
        id: '2',
        title: 'Mixed Vegetables Box',
        description: 'Fresh vegetables with minor cosmetic imperfections.',
        imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999',
        type: SurplusType.donation,
        quantity: 3,
        unit: 'boxes',
        expiryDate: now.add(const Duration(days: 2)),
        pickupStartTime: now.add(const Duration(hours: 2)),
        pickupEndTime: now.add(const Duration(hours: 6)),
        businessId: 'b2',
        businessName: 'Green Grocers',
        businessType: 'Grocery Store',
        businessLogo: 'https://images.unsplash.com/photo-1540420773420-3366772f4999',
        pickupAddress: '456 Market Road, Downtown',
        latitude: 23.7805,
        longitude: 90.4207,
        status: SurplusStatus.available,
        dietaryInfo: const ['Vegan', 'Gluten-Free'],
        views: 189,
        claims: 8,
        createdAt: now.subtract(const Duration(hours: 3)),
        notes: 'Various seasonal vegetables',
      ),
    ]);
  }

  @override
  Future<List<SurplusItemModel>> getAllSurplusItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockItems.where((item) => item.status == SurplusStatus.available).toList();
  }

  @override
  Future<SurplusItemModel> getSurplusItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockItems.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('Surplus item not found'),
    );
  }

  @override
  Future<List<SurplusItemModel>> getSurplusItemsByType(SurplusType type) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockItems.where((item) => item.type == type && item.status == SurplusStatus.available).toList();
  }

  @override
  Future<List<SurplusItemModel>> searchSurplusItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lowerQuery = query.toLowerCase();
    return _mockItems.where((item) {
      return item.status == SurplusStatus.available &&
          (item.title.toLowerCase().contains(lowerQuery) ||
              item.description.toLowerCase().contains(lowerQuery) ||
              item.businessName.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  @override
  Future<List<SurplusItemModel>> filterSurplusItems({
    SurplusType? type,
    double? maxPrice,
    int? maxDistance,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var filtered = _mockItems.where((item) => item.status == SurplusStatus.available);

    if (type != null) {
      filtered = filtered.where((item) => item.type == type);
    }

    if (maxPrice != null) {
      filtered = filtered.where((item) {
        final price = item.discountedPrice ?? item.originalPrice ?? 0.0;
        return price <= maxPrice;
      });
    }

    return filtered.toList();
  }

  @override
  Future<SurplusRequestModel> createSurplusRequest(SurplusRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newRequest = SurplusRequestModel(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      surplusItemId: request.surplusItemId,
      userId: request.userId,
      userName: request.userName,
      userPhone: request.userPhone,
      message: request.message,
      requestedPickupTime: request.requestedPickupTime,
      status: request.status,
      createdAt: DateTime.now(),
    );
    
    _mockRequests.add(newRequest);
    
    final itemIndex = _mockItems.indexWhere((item) => item.id == request.surplusItemId);
    if (itemIndex != -1) {
      final item = _mockItems[itemIndex];
      _mockItems[itemIndex] = SurplusItemModel.fromEntity(item);
    }
    
    return newRequest;
  }

  @override
  Future<List<SurplusRequestModel>> getUserRequests(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockRequests.where((request) => request.userId == userId).toList();
  }

  @override
  Future<void> incrementViews(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final itemIndex = _mockItems.indexWhere((item) => item.id == id);
    if (itemIndex != -1) {
      final item = _mockItems[itemIndex];
      _mockItems[itemIndex] = SurplusItemModel.fromEntity(item);
    }
  }
}