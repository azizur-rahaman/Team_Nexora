import '../../domain/entities/surplus_request.dart';

/// Surplus Request Model
/// Data transfer object for SurplusRequest entity
class SurplusRequestModel extends SurplusRequest {
  const SurplusRequestModel({
    required super.id,
    required super.surplusItemId,
    required super.userId,
    required super.userName,
    required super.userPhone,
    super.message,
    required super.requestedPickupTime,
    required super.status,
    required super.createdAt,
  });

  factory SurplusRequestModel.fromJson(Map<String, dynamic> json) {
    return SurplusRequestModel(
      id: json['id'] as String,
      surplusItemId: json['surplusItemId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhone: json['userPhone'] as String,
      message: json['message'] as String?,
      requestedPickupTime: DateTime.parse(json['requestedPickupTime'] as String),
      status: RequestStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surplusItemId': surplusItemId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'message': message,
      'requestedPickupTime': requestedPickupTime.toIso8601String(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SurplusRequestModel.fromEntity(SurplusRequest request) {
    return SurplusRequestModel(
      id: request.id,
      surplusItemId: request.surplusItemId,
      userId: request.userId,
      userName: request.userName,
      userPhone: request.userPhone,
      message: request.message,
      requestedPickupTime: request.requestedPickupTime,
      status: request.status,
      createdAt: request.createdAt,
    );
  }
}
