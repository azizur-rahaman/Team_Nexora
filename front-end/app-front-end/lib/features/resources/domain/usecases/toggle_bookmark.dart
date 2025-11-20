import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

class ToggleBookmark implements UseCase<Resource, ToggleBookmarkParams> {
  final ResourceRepository repository;

  ToggleBookmark(this.repository);

  @override
  Future<Either<Failure, Resource>> call(ToggleBookmarkParams params) async {
    return await repository.toggleBookmark(params.id);
  }
}

class ToggleBookmarkParams extends Equatable {
  final String id;

  const ToggleBookmarkParams({required this.id});

  @override
  List<Object> get props => [id];
}
