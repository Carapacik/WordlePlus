import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:wordly/data/models/board_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/domain/board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  late BoardData _boardData;

  @override
  BoardData get boardData => _boardData;

  @override
  Future<void> initBoardData(
    final DictionaryLanguages dictionaryLanguage,
  ) async {
    final result =
        await GetIt.I<Isar>().boardDatas.get(dictionaryLanguage.index);
    _boardData = result ?? BoardData.init(dictionaryLanguage.index);
  }

  @override
  Future<void> saveBoardData(BoardData data) async {
    await GetIt.I<Isar>().writeTxn((isar) async {
      _boardData = data;
      await isar.boardDatas.put(_boardData);
    });
  }
}
