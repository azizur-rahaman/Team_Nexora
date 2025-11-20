import 'package:equatable/equatable.dart';
import '../../domain/entities/surplus_item.dart';
import '../../domain/entities/surplus_request.dart';

/// Surplus States
abstract class SurplusState extends Equatable {
  const SurplusState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SurplusInitial extends SurplusState {
  const SurplusInitial();
}

/// Loading state
class SurplusLoading extends SurplusState {
  const SurplusLoading();
}

/// Surplus items loaded successfully
class SurplusLoaded extends SurplusState {
  final List<SurplusItem> items;
  final SurplusType? activeFilter;

  const SurplusLoaded({
    required this.items,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [items, activeFilter];

  SurplusLoaded copyWith({
    List<SurplusItem>? items,
    SurplusType? activeFilter,
  }) {
    return SurplusLoaded(
      items: items ?? this.items,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

/// Single surplus item loaded
class SurplusItemDetailLoaded extends SurplusState {
  final SurplusItem item;

  const SurplusItemDetailLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Request created successfully
class SurplusRequestCreated extends SurplusState {
  final SurplusRequest request;

  const SurplusRequestCreated(this.request);

  @override
  List<Object?> get props => [request];
}

/// Error state
class SurplusError extends SurplusState {
  final String message;

  const SurplusError(this.message);

  @override
  List<Object?> get props => [message];
}
