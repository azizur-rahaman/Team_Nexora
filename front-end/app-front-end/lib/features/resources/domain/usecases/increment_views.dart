import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/resource_repository.dart';

class IncrementViews implements UseCase<void, IncrementViewsParams> {
  final ResourceRepository repository;

  IncrementViews(this.repository);

  @override
  Future<Either<Failure, void>> call(IncrementViewsParams params) async {
    return await repository.incrementViews(params.id);
  }
}

class IncrementViewsParams extends Equatable {
  final String id;

  const IncrementViewsParams({required this.id});

  @override
  List<Object> get props => [id];
}
