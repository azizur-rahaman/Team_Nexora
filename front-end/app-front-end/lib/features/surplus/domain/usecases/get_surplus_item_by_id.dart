import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/surplus_item.dart';
import '../repositories/surplus_repository.dart';

class GetSurplusItemById implements UseCase<SurplusItem, GetSurplusItemByIdParams> {
  final SurplusRepository repository;

  GetSurplusItemById(this.repository);

  @override
  Future<Either<Failure, SurplusItem>> call(GetSurplusItemByIdParams params) async {
    return await repository.getSurplusItemById(params.id);
  }
}

class GetSurplusItemByIdParams extends Equatable {
  final String id;

  const GetSurplusItemByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
