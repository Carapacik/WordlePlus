import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:wordly/data/models/daily_result_data.dart';
import 'package:wordly/domain/daily_result_repository.dart';

class DailyResultRepositoryImp implements DailyResultRepository {
  late DailyResultData _dailyResult;

  @override
  DailyResultData get dailyResult => _dailyResult;

  @override
  Future<void> initDailyResult() async {
    final result = await GetIt.I<Isar>().dailyResultDatas.get(0);
    _dailyResult = result ?? DailyResultData();
  }

  @override
  Future<void> saveDailyResult(DailyResultData data) async {
    await GetIt.I<Isar>().writeTxn((isar) async {
      await isar.dailyResultDatas.put(_dailyResult);
    });
  }
}