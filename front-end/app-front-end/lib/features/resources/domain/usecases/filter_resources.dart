import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

class FilterResources implements UseCase<List<Resource>, FilterResourcesParams> {
  final ResourceRepository repository;

  FilterResources(this.repository);

  @override
  Future<Either<Failure, List<Resource>>> call(FilterResourcesParams params) async {
    return await repository.filterAndSortResources(
      categories: params.categories,
      types: params.types,
      sortBy: params.sortBy,
      ascending: params.ascending,
    );
  }
}

class FilterResourcesParams extends Equatable {
  final List<ResourceCategory>? categories;
  final List<ResourceType>? types;
  final String? sortBy;
  final bool? ascending;

  const FilterResourcesParams({
    this.categories,
    this.types,
    this.sortBy,
    this.ascending,
  });

  @override
  List<Object?> get props => [categories, types, sortBy, ascending];
}
