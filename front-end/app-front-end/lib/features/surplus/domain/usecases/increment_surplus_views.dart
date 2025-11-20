import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/surplus_repository.dart';

class IncrementSurplusViews implements UseCase<void, IncrementSurplusViewsParams> {
  final SurplusRepository repository;

  IncrementSurplusViews(this.repository);

  @override
  Future<Either<Failure, void>> call(IncrementSurplusViewsParams params) async {
    return await repository.incrementViews(params.id);
  }
}

class IncrementSurplusViewsParams extends Equatable {
  final String id;

  const IncrementSurplusViewsParams({required this.id});

  @override
  List<Object> get props => [id];
}
