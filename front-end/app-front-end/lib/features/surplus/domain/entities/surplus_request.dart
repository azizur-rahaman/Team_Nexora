/// Surplus Request Entity
/// Represents a user's request/claim for surplus items
class SurplusRequest {
  final String id;
  final String surplusItemId;
  final String userId;
  final String userName;
  final String userPhone;
  final String? message;
  final DateTime requestedPickupTime;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final String? cancellationReason;

  const SurplusRequest({
    required this.id,
    required this.surplusItemId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    this.message,
    required this.requestedPickupTime,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.completedAt,
    this.cancellationReason,
  });

  SurplusRequest copyWith({
    String? id,
    String? surplusItemId,
    String? userId,
    String? userName,
    String? userPhone,
    String? message,
    DateTime? requestedPickupTime,
    RequestStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? completedAt,
    String? cancellationReason,
  }) {
    return SurplusRequest(
      id: id ?? this.id,
      surplusItemId: surplusItemId ?? this.surplusItemId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      message: message ?? this.message,
      requestedPickupTime: requestedPickupTime ?? this.requestedPickupTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      completedAt: completedAt ?? this.completedAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}

/// Request Status
enum RequestStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.confirmed:
        return 'Confirmed';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }
}
