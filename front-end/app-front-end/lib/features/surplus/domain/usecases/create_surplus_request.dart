import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/surplus_request.dart';
import '../repositories/surplus_repository.dart';

class CreateSurplusRequest implements UseCase<SurplusRequest, CreateSurplusRequestParams> {
  final SurplusRepository repository;

  CreateSurplusRequest(this.repository);

  @override
  Future<Either<Failure, SurplusRequest>> call(CreateSurplusRequestParams params) async {
    return await repository.createSurplusRequest(params.request);
  }
}

class CreateSurplusRequestParams extends Equatable {
  final SurplusRequest request;

  const CreateSurplusRequestParams({required this.request});

  @override
  List<Object> get props => [request];
}
