import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

class GetAllResources implements UseCase<List<Resource>, NoParams> {
  final ResourceRepository repository;

  GetAllResources(this.repository);

  @override
  Future<Either<Failure, List<Resource>>> call(NoParams params) async {
    return await repository.getAllResources();
  }
}
