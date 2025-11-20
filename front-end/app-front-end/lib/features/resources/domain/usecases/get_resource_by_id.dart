import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

class GetResourceById implements UseCase<Resource, GetResourceByIdParams> {
  final ResourceRepository repository;

  GetResourceById(this.repository);

  @override
  Future<Either<Failure, Resource>> call(GetResourceByIdParams params) async {
    return await repository.getResourceById(params.id);
  }
}

class GetResourceByIdParams extends Equatable {
  final String id;

  const GetResourceByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
