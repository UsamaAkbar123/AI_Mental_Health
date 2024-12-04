import 'package:freud_ai/screens/mood/model/mood_model.dart';

abstract class MoodEvent {}


///Mood initial Event
class MoodInitialEvent extends MoodEvent {}



///Mood Event
class GetMoodEvent extends MoodEvent {}



///Add Mood Event
class AddMoodEvent extends MoodEvent {
  MoodModel? moodModel;

  AddMoodEvent({this.moodModel});
}


///Update Mood Event
class UpdateMoodEvent extends MoodEvent {}

/// delete mood event by id
class DeleteMoodByIdEvent extends MoodEvent {
  final String moodId;

  DeleteMoodByIdEvent({required this.moodId});
}