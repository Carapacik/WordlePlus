part of 'game_bloc.dart';

@freezed
class GameEvent with _$GameEvent {
  const GameEvent._();

  const factory GameEvent.letterPressed(KeyboardKeys letter) =
      _LetterPressedEvent;

  const factory GameEvent.keyListen(RawKeyDownEvent keyDown) = _KeyListenEvent;

  const factory GameEvent.deletePressed() = _DeletePressedEvent;

  const factory GameEvent.deleteLongPressed() = _DeleteLongPressedEvent;

  const factory GameEvent.enterPressed() = _EnterPressedEvent;

  const factory GameEvent.loadGame({@Default(true) bool isDaily}) =
      _LoadGameEvent;

  const factory GameEvent.resetGame() = _ResetGameEvent;

  const factory GameEvent.changeDictionary(DictionaryEnum dictionary) =
      _ChangeDictionaryEvent;
}
