import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/surplus_item.dart';
import '../repositories/surplus_repository.dart';

class GetAllSurplusItems implements UseCase<List<SurplusItem>, NoParams> {
  final SurplusRepository repository;

  GetAllSurplusItems(this.repository);

  @override
  Future<Either<Failure, List<SurplusItem>>> call(NoParams params) async {
    return await repository.getAllSurplusItems();
  }
}
