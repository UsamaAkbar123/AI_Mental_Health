import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:freud_ai/application/bloc/app_info_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_event.dart';
import 'package:freud_ai/application/services/openai_services.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:freud_ai/screens/routine/model/tags_model.dart';
import 'package:freud_ai/screens/routine/notification_remainder/local_remainder_notification.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DailyRoutinePlannerDataResource {
  Database database;

  /// basic constructor
  DailyRoutinePlannerDataResource(this.database);

  /// create table of daily routine planner
  Future<void> _createDailyRoutinePlannerTable() async {
    const String tableName = Constants.dailyRoutinePlannerTagsTableName;

    /// Define column names
    const String columnId = 'id';
    const String dayId = 'dayId';
    const String routineTaskModelList = 'routineTaskModelList';

    try {
      await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $dayId TEXT,
        $routineTaskModelList TEXT
      )
    ''');
    } catch (e) {
      log("Error in createRoutinePlannerTable: $e");
    }
  }

  ///  add new routine task
  Future<void> addDailyRoutinePlan(DayDailyRoutinePlannerModel model) async {
    await _createDailyRoutinePlannerTable();

    try {
      // Parse the scheduleStartDate and scheduleEndDate
      DateTime startDate = DateFormat('d MMMM y')
          .parse(model.routineTaskModelList!.first.scheduleStartDate!);
      DateTime endDate = DateFormat('d MMMM y')
          .parse(model.routineTaskModelList!.first.scheduleEndDate!);

      // Calculate the total number of days
      int totalDays = endDate.difference(startDate).inDays + 1;

      // Loop through each day and add/update the routine
      for (int i = 0; i < totalDays; i++) {
        DateTime currentDate = startDate.add(Duration(days: i));
        String currentDayId = DateFormat('d MMMM y').format(currentDate);

        // Create a new routine task model list with unique task IDs
        List<RoutineTaskModel> newTasks =
            model.routineTaskModelList!.map((task) {
          return task.copyWith(taskId: const Uuid().v4());
        }).toList();

        // print("task id: ${newTasks[0].taskId}");

        final notificationRemainderDate = parseRemainderTimeToDateTime(
          notificationRemainderTime: newTasks[0].reminderAt ?? "",
          isNotifyReminder: newTasks[0].isNotifyReminder,
          scheduleDate: currentDate,
        );

        // print("notificationRemainderDate: $notificationRemainderDate");
        // Convert the new routineTaskModelList to JSON
        String routineTaskModelListJson =
            jsonEncode(newTasks.map((task) => task.toJson()).toList());

        List<Map<String, dynamic>> result = await database.query(
          Constants.dailyRoutinePlannerTagsTableName,
          where: 'dayId = ?',
          whereArgs: [currentDayId],
        );

        if (result.isNotEmpty) {
          // Entry exists, merge the existing routine task list with the new tasks
          String existingTaskListJson = result.first['routineTaskModelList'];
          List<dynamic> existingTaskList = jsonDecode(existingTaskListJson);
          List<RoutineTaskModel> existingTasks = existingTaskList
              .map((taskJson) => RoutineTaskModel.fromJson(taskJson))
              .toList();

          List<RoutineTaskModel> mergedTasks = [...existingTasks, ...newTasks];

          String mergedTaskListJson =
              jsonEncode(mergedTasks.map((task) => task.toJson()).toList());

          // Update the entry with the merged task list
          await database
              .update(
            Constants.dailyRoutinePlannerTagsTableName,
            {
              'routineTaskModelList': mergedTaskListJson,
            },
            where: 'dayId = ?',
            whereArgs: [currentDayId],
          )
              .then((value) {
            log("Routine entry updated count: $value for dayId: $currentDayId");

            /// schedule the remainder notification for the added routine task
            if (notificationRemainderDate != null) {
              int notificationId =
                  generateNotificationId(newTasks[0].taskId ?? "");

              // print("task notification id: $notificationId");

              LocalRemainderNotification.showScheduleNotification(
                id: notificationId,
                title: newTasks[0].taskName ?? "",
                body: newTasks[0].tagName ?? "",
                payload: "payload",
                remainderNotificationTime: notificationRemainderDate,
              );
            }
          });
        } else {
          // Entry doesn't exist, insert a new entry
          await database
              .insert(
            Constants.dailyRoutinePlannerTagsTableName,
            {
              'dayId': currentDayId,
              'routineTaskModelList': routineTaskModelListJson,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          )
              .then((value) {
            log("Routine entry inserted count: $value for dayId: $currentDayId");

            /// schedule the remainder notification for the added routine task
            if (notificationRemainderDate != null) {
              int notificationId =
                  generateNotificationId(newTasks[0].taskId ?? "");

              LocalRemainderNotification.showScheduleNotification(
                id: notificationId,
                title: newTasks[0].taskName ?? "",
                body: newTasks[0].tagName ?? "",
                payload: "payload",
                remainderNotificationTime: notificationRemainderDate,
              );
            }
          });
        }
      }
    } catch (e, st) {
      log("Error in addOrUpdateRoutineForDays: $e :: $st");
    }
  }

  ///Create Routine Planner Tags Table
  Future<void> _createRoutinePlannerTagsTable() async{
    const String tableName = Constants.routinePlannerTagsTableName;

    const String columnId = 'id';
    const String tagTitle = 'title';
    const String isSelected = 'isSelected';

    try {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $tagTitle TEXT,
          $isSelected TEXT
        )
      ''');
    } catch (e) {
      log("Error in createRoutinePlannerTable: $e");
    }

  }

  ///Call The OpenAI services here and ask them to make a plan.
  Future<void> createPlanForDailyRoutine() async {
    List<QuestionSummaryModel>? listOfQuestions = await getStoredQuestions();

    Map<String, dynamic> jsonMapString =
        convertToJsonForOpenAI(listOfQuestions!);

    log(jsonMapString.toString());

    await OpenAIServices().startOpenAiService(query: jsonMapString);
  }

  /// Here we will get the ChatHistory
  Future<List<QuestionSummaryModel>?> getStoredQuestions() async {
    if ((await databaseHelper.isTableExist(Constants.goalTableName))) {
      List<Map<String, dynamic>> results =
          await database.query(Constants.goalTableName);

      if (results.isNotEmpty) {
        List<QuestionSummaryModel> questions = results.map((result) {
          return QuestionSummaryModel.fromJson(result);
        }).toList();
        return questions;
      }
    } else {
      return null;
    }
    return null;
  }

  ///Here we will convert the list  of users questions summary model to single unit for open AI
  Map<String, dynamic> convertToJsonForOpenAI(
      List<QuestionSummaryModel> questions) {
    Map<String, dynamic> jsonMap = {};

    for (var question in questions) {
      jsonMap[question.question!] = {
        'answersList': question.answersList != null
            ? jsonEncode(question.answersList)
            : null,
      };
    }

    return jsonMap;
  }

  ///In this method we will add our routine to the database
  Future<void> addRoutinePlannerToDatabaseFromOnboarding(
      List<RoutineTaskModel> routineModel) async {
    AppInfoBloc appInfoBloc = AppInfoBloc();

    await _createDailyRoutinePlannerTable();

    await _createRoutinePlannerTagsTable();

    try {
      for (var model in routineModel) {
        /// when routine tasks are added to database
        /// after onboarding, then we also set
        /// the remainder notification for each routine i.e "Wake up", "Sleep Time", "Drink Water"
        if (model.taskName == "Wake up") {
          model = model.copyWith(
            reminderAt: "6:00 AM",
            isNotifyReminder: true,
            scheduleTotalDays: "8",
            timeSpanForTask: "6:00 AM",
            isPointTimeSelected: true,
            // timeSpanForTask: "6:00 AM",
          );
        }else if(model.taskName == "Sleep Time"){
          model = model.copyWith(
            reminderAt: "10:00 PM",
            isNotifyReminder: true,
            scheduleTotalDays: "8",
            timeSpanForTask: "10:00 PM",
            isPointTimeSelected: true,
            // timeSpanForTask: "10:00 PM"
          );
        }else{
          model = model.copyWith(
            reminderAt: "8:00 AM",
            isNotifyReminder: true,
            scheduleTotalDays: "8",
            timeSpanForTask: "8:00 AM",
            isPointTimeSelected: true,
          );
        }

        DayDailyRoutinePlannerModel dayDailyRoutinePlannerModel =
            DayDailyRoutinePlannerModel(
          dayId: DateFormat('d MMMM y').format(DateTime.now()),
          routineTaskModelList: [model],
        );

        await addDailyRoutinePlan(dayDailyRoutinePlannerModel);
      }


      for (var data in Constants().routinePlannerTags) {
        await database.insert(
            Constants.routinePlannerTagsTableName, data.toJson());
      }

      Constants.completeAppInfoModel = Constants.completeAppInfoModel!
          .copyWith(isRoutinePlannerCreated: true);

      appInfoBloc.add(UpdateAppInfoEvent(Constants.completeAppInfoModel!));
    } catch (e, st) {
      log("Error in insertOrUpdateStepGoal: $e  :: $st");
    }
  }

  int generateNotificationId(String taskId) {
    final bytes = utf8.encode(taskId);
    final digest = sha256.convert(bytes);
    // Use the first 8 characters of the hash and convert to an integer
    final hashString = digest.toString();
    final intHash = int.parse(hashString.substring(0, 8), radix: 16);
    // Ensure the ID is within the 32-bit integer range
    return intHash & 0x7FFFFFFF; // Mask to fit within the range
  }

  /// parse the notification remainder string into datetime
  DateTime? parseRemainderTimeToDateTime({
    required String notificationRemainderTime,
    bool? isNotifyReminder,
    required DateTime scheduleDate,
  }) {
    if (isNotifyReminder == true && notificationRemainderTime != "") {
      // Parse the time string to a TimeOfDay object
      final timeFormat = DateFormat('h:mm a'); // This will handle "2:44 PM"
      final parsedTime = timeFormat.parse(notificationRemainderTime);
      final timeOfDay = TimeOfDay.fromDateTime(parsedTime);

      // Combine the parsed date and time to get a complete DateTime object
      final dateTime = DateTime(
        scheduleDate.year,
        scheduleDate.month,
        scheduleDate.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      return dateTime;
    }

    return null;
  }

  ///Here we will get the routine plan from the database
  Future<List<DayDailyRoutinePlannerModel>?> getDailyRoutinePlan() async {
    if ((await databaseHelper
        .isTableExist(Constants.dailyRoutinePlannerTagsTableName))) {
      List<Map<String, dynamic>> results =
          await database.query(Constants.dailyRoutinePlannerTagsTableName);

      if (results.isNotEmpty) {
        List<DayDailyRoutinePlannerModel> listOfRoutineModel =
            results.map((result) {
          return DayDailyRoutinePlannerModel.fromJson(result);
        }).toList();

        log("daily routine planner list length: ${results.length}");

        return listOfRoutineModel;
      }
    } else {
      return null;
    }
    return null;
  }

  /// mark as complete or un_complete a routine task
  Future<void> routineTaskMarkAsCompleteOrUnComplete({
    required String dayId,
    required RoutineTaskModel routineTaskModel,
  }) async {
    /// first of all get the daily routine planner from database based on day id

    final List<Map<String, dynamic>> maps = await database.query(
      Constants.dailyRoutinePlannerTagsTableName,
      where: 'dayId = ?',
      whereArgs: [dayId],
    );

    if (maps.isNotEmpty) {
      /// set the List<Map<String,dynamic> into DayDailyRoutinePlannerModel object

      DayDailyRoutinePlannerModel dayDailyRoutinePlannerModel =
          DayDailyRoutinePlannerModel.fromJson(maps[0]);
      // log("mark as complete: ${dayDailyRoutinePlannerModel.toJson()}");

      /// Find the index of the routine task from [dayDailyRoutinePlannerModel] based on task id
      int taskIndex = dayDailyRoutinePlannerModel.routineTaskModelList
              ?.indexWhere((task) => task.taskId == routineTaskModel.taskId) ??
          -1;

      if (taskIndex != -1) {
        /// Update the routine task at the found index
        dayDailyRoutinePlannerModel.routineTaskModelList![taskIndex] = routineTaskModel;

        // log("updated day routine task: ${dayDailyRoutinePlannerModel.toJson()}");

        /// Convert the new routineTaskModelList to JSON
        String routineTaskModelListJson = jsonEncode(
            dayDailyRoutinePlannerModel.routineTaskModelList?.map((task) => task.toJson()).toList());

        /// finally update the routine to database
        await database
            .update(
          Constants.dailyRoutinePlannerTagsTableName,
          {
            'routineTaskModelList': routineTaskModelListJson,
          },
          where: 'dayId = ?',
          whereArgs: [dayId],
        )
            .then((value) {
          log("Routine entry updated count: $value for dayId: $dayId");
        });
      } else {
        log('Routine task not found in the daily routine.');
      }
    }
  }


/// get the tag model list
  Future<List<TagsModel>?> getRoutineTags() async {
    if ((await databaseHelper
        .isTableExist(Constants.routinePlannerTagsTableName))) {
      List<Map<String, dynamic>> results =
      await database.query(Constants.routinePlannerTagsTableName);

      if (results.isNotEmpty) {
        List<TagsModel> routineTagsModel = results.map((result) {
          return TagsModel.fromJson(result);
        }).toList();

        return routineTagsModel;
      }
    } else {
      return null;
    }
    return null;
  }


///Add New Tag In Tags List for the Routine Planner Tags
Future<List<TagsModel>?> addNewTagInTagsList(TagsModel tagsModel) async {

  await database.insert(
      Constants.routinePlannerTagsTableName, tagsModel.toJson());

  return await getRoutineTags();
}

  /// update or delete routine planner
  Future<void> updateOrDeleteRoutinePlanner({
    required String dayId,
    required RoutineTaskModel updatedRoutineTaskModel,
  }) async {
    RoutineTaskModel previousRoutinePlanner = RoutineTaskModel();

    /// step 1
    /// get the daily routine planner task by dayId
    final List<Map<String, dynamic>> maps = await database.query(
      Constants.dailyRoutinePlannerTagsTableName,
      where: 'dayId = ?',
      whereArgs: [dayId],
    );

    /// step 2
    /// from routine task model list , filter routine model task, based in task id

    if (maps.isNotEmpty) {
      DayDailyRoutinePlannerModel dayDailyRoutinePlannerModel =
          DayDailyRoutinePlannerModel.fromJson(maps[0]);

      for (RoutineTaskModel model
          in dayDailyRoutinePlannerModel.routineTaskModelList ?? []) {
        if (updatedRoutineTaskModel.taskId == model.taskId) {
          previousRoutinePlanner = model;
          break;
        }
      }
    }

    // log("previous added routine planner task: ${previousRoutinePlanner.toJson()}");
    // log("updated routine planner task: ${updatedRoutineTaskModel.toJson()}");

    /// step 3
    /// calculate the total days of previous added routine planner, from updated routine planner start date, and previous routine planner end data
    /// also calculate the updated total days, from updated routine planner, schedule start and end date

    // Parse the scheduleStartDate and scheduleEndDate
    DateTime updatedStartDate = DateFormat('d MMMM y').parse(
      updatedRoutineTaskModel.scheduleStartDate!,
    );
    DateTime updatedEndDate = DateFormat('d MMMM y').parse(
      updatedRoutineTaskModel.scheduleEndDate!,
    );

    DateTime previousEndDate = DateFormat('d MMMM y').parse(
      previousRoutinePlanner.scheduleEndDate!,
    );

    // Calculate the total number of days
    int updatedTotalDays =
        updatedEndDate.difference(updatedStartDate).inDays + 1;
    int previousTotalDays =
        previousEndDate.difference(updatedStartDate).inDays + 1;

    log("previous total days: $previousTotalDays");
    log("updated total days: $updatedTotalDays");

    /// case 1
    /// if previous total days == updated total days
    if (previousTotalDays == updatedTotalDays) {
      for (int i = 0; i < previousTotalDays; i++) {
        /// get the day id
        DateTime currentDate = updatedStartDate.add(Duration(days: i));
        String currentDayId = DateFormat('d MMMM y').format(currentDate);

        /// get daily routine planner based on current id
        final List<Map<String, dynamic>> maps = await database.query(
          Constants.dailyRoutinePlannerTagsTableName,
          where: 'dayId = ?',
          whereArgs: [currentDayId],
        );

        /// convert to daily routine planner model

        DayDailyRoutinePlannerModel dayDailyRoutinePlannerModel =
            DayDailyRoutinePlannerModel.fromJson(maps[0]);

        /// inside dayDailyRoutinePlannerModel , from routine task model list
        /// get the index of routine which is going to be update based of common task id

        int taskIndex = dayDailyRoutinePlannerModel.routineTaskModelList
                ?.indexWhere((task) =>
                    task.taskRoutineCommonId ==
                    updatedRoutineTaskModel.taskRoutineCommonId) ??
            -1;

        if (taskIndex != -1) {
          /// Update the routine task at the found index
          dayDailyRoutinePlannerModel.routineTaskModelList![taskIndex] =
              updatedRoutineTaskModel;

          // log("updated day routine task: ${dayDailyRoutinePlannerModel.toJson()}");

          /// Convert the new routineTaskModelList to JSON
          String routineTaskModelListJson = jsonEncode(
              dayDailyRoutinePlannerModel.routineTaskModelList
                  ?.map((task) => task.toJson())
                  .toList());

          /// finally update the routine to database
          await database
              .update(
            Constants.dailyRoutinePlannerTagsTableName,
            {
              'routineTaskModelList': routineTaskModelListJson,
            },
            where: 'dayId = ?',
            whereArgs: [currentDayId],
          )
              .then((value) async {
            // log("Routine entry updated count: $value for dayId: $currentDayId");

            /// if isNotifyReminder == true and previous added routine planner remindAt time and updated routine planner remindAt time is not equal
            /// then
            /// first cancel the schedule notification based on notification id
            /// second schedule new notification based on taskId

            if (updatedRoutineTaskModel.isNotifyReminder == true) {
              final notificationRemainderDate = parseRemainderTimeToDateTime(
                notificationRemainderTime:
                    updatedRoutineTaskModel.reminderAt ?? "",
                isNotifyReminder: updatedRoutineTaskModel.isNotifyReminder,
                scheduleDate: currentDate,
              );

              if (notificationRemainderDate != null) {
                int notificationId = generateNotificationId(
                    dayDailyRoutinePlannerModel
                            .routineTaskModelList?[taskIndex].taskId ??
                        "");

                /// cancel the notification
                await LocalRemainderNotification.cancel(notificationId)
                    .then((value) {
                  // log("notification cancel by id: $notificationId");
                }).onError((error, stackTrace) {
                  log("cancel notification error: $error");
                });

                /// reschedule the notification
                await LocalRemainderNotification.showScheduleNotification(
                  id: notificationId,
                  title: updatedRoutineTaskModel.taskName ?? "",
                  body: updatedRoutineTaskModel.tagName ?? "",
                  payload: "payload",
                  remainderNotificationTime: notificationRemainderDate,
                ).then((value) {
                  log("notification reschedule with id: $notificationId");
                }).onError((error, stackTrace) {
                  log("reschedule notification error: $error");
                });
              }
            } else {
              int notificationId = generateNotificationId(
                  dayDailyRoutinePlannerModel
                          .routineTaskModelList?[taskIndex].taskId ??
                      "");

              /// cancel the notification
              await LocalRemainderNotification.cancel(notificationId)
                  .then((value) {
                // log("notification cancel by $notificationId");
              }).onError((error, stackTrace) {
                log("cancel notification error: $error");
              });
            }
          });
        }
      }
    }

    /// case 2
    /// if previous total days < updated total days
    if (updatedTotalDays < previousTotalDays) {
      for (int i = 0; i < previousTotalDays; i++) {
        if (updatedTotalDays >= i + 1) {
          /// get the day id
          DateTime currentDate = updatedStartDate.add(Duration(days: i));
          String currentDayId = DateFormat('d MMMM y').format(currentDate);

          /// get daily routine planner based on current id
          final List<Map<String, dynamic>> maps = await database.query(
            Constants.dailyRoutinePlannerTagsTableName,
            where: 'dayId = ?',
            whereArgs: [currentDayId],
          );

          /// convert to daily routine planner model

          DayDailyRoutinePlannerModel dayDailyRoutinePlannerModel =
              DayDailyRoutinePlannerModel.fromJson(maps[0]);

          /// inside dayDailyRoutinePlannerModel , from routine task model list
          /// get the index of routine which is going to be update based of common task id

          int taskIndex = dayDailyRoutinePlannerModel.routineTaskModelList
                  ?.indexWhere((task) =>
                      task.taskRoutineCommonId ==
                      updatedRoutineTaskModel.taskRoutineCommonId) ??
              -1;

          if (taskIndex != -1) {
            /// Update the routine task at the found index
            dayDailyRoutinePlannerModel.routineTaskModelList![taskIndex] =
                updatedRoutineTaskModel;

            // log("updated day routine task: ${dayDailyRoutinePlannerModel.toJson()}");

            /// Convert the new routineTaskModelList to JSON
            String routineTaskModelListJson = jsonEncode(
                dayDailyRoutinePlannerModel.routineTaskModelList
                    ?.map((task) => task.toJson())
                    .toList());

            /// finally update the routine to database
            await database
                .update(
              Constants.dailyRoutinePlannerTagsTableName,
              {
                'routineTaskModelList': routineTaskModelListJson,
              },
              where: 'dayId = ?',
              whereArgs: [currentDayId],
            )
                .then((value) async {
              // log("Routine entry updated count: $value for dayId: $currentDayId");

              /// if isNotifyReminder == true and previous added routine planner remindAt time and updated routine planner remindAt time is not equal
              /// then
              /// first cancel the schedule notification based on notification id
              /// second schedule new notification based on taskId

              if (updatedRoutineTaskModel.isNotifyReminder == true) {
                final notificationRemainderDate = parseRemainderTimeToDateTime(
                  notificationRemainderTime:
                      updatedRoutineTaskModel.reminderAt ?? "",
                  isNotifyReminder: updatedRoutineTaskModel.isNotifyReminder,
                  scheduleDate: currentDate,
                );

                if (notificationRemainderDate != null) {
                  int notificationId = generateNotificationId(
                      dayDailyRoutinePlannerModel
                              .routineTaskModelList?[taskIndex].taskId ??
                          "");

                  /// cancel the notification
                  await LocalRemainderNotification.cancel(notificationId)
                      .then((value) {
                    // log("notification cancel by id: $notificationId");
                  }).onError((error, stackTrace) {
                    log("cancel notification error: $error");
                  });

                  /// reschedule the notification
                  await LocalRemainderNotification.showScheduleNotification(
                    id: notificationId,
                    title: updatedRoutineTaskModel.taskName ?? "",
                    body: updatedRoutineTaskModel.tagName ?? "",
                    payload: "payload",
                    remainderNotificationTime: notificationRemainderDate,
                  ).then((value) {
                    // log("notification reschedule with id: $notificationId");
                  }).onError((error, stackTrace) {
                    log("reschedule notification error: $error");
                  });
                }
              } else {
                int notificationId = generateNotificationId(
                    dayDailyRoutinePlannerModel
                            .routineTaskModelList?[taskIndex].taskId ??
                        "");

                /// cancel the notification
                await LocalRemainderNotification.cancel(notificationId)
                    .then((value) {
                  // log("notification cancel by $notificationId");
                }).onError((error, stackTrace) {
                  log("cancel notification error: $error");
                });
              }
            });
          }
        } else {
          /// get the day id
          DateTime currentDate = updatedStartDate.add(Duration(days: i));
          String currentDayId = DateFormat('d MMMM y').format(currentDate);

          /// get daily routine planner based on current id
          final List<Map<String, dynamic>> maps = await database.query(
            Constants.dailyRoutinePlannerTagsTableName,
            where: 'dayId = ?',
            whereArgs: [currentDayId],
          );

          /// convert to daily routine planner model

          DayDailyRoutinePlannerModel dayDailyRoutinePlannerModel =
              DayDailyRoutinePlannerModel.fromJson(maps[0]);

          /// inside dayDailyRoutinePlannerModel , from routine task model list
          /// get the index of routine which is going to be update based of common task id

          int taskIndex = dayDailyRoutinePlannerModel.routineTaskModelList
                  ?.indexWhere((task) =>
                      task.taskRoutineCommonId ==
                      updatedRoutineTaskModel.taskRoutineCommonId) ??
              -1;

          if (taskIndex != -1) {
            /// Update the routine task at the found index
            dayDailyRoutinePlannerModel.routineTaskModelList!
                .removeAt(taskIndex);

            /// Convert the new routineTaskModelList to JSON
            String routineTaskModelListJson = jsonEncode(
                dayDailyRoutinePlannerModel.routineTaskModelList
                    ?.map((task) => task.toJson())
                    .toList());

            /// finally update the routine to database
            await database
                .update(
              Constants.dailyRoutinePlannerTagsTableName,
              {
                'routineTaskModelList': routineTaskModelListJson,
              },
              where: 'dayId = ?',
              whereArgs: [currentDayId],
            )
                .then((value) async {
              /// just cancel the schedule notification

              int notificationId = generateNotificationId(
                  dayDailyRoutinePlannerModel
                          .routineTaskModelList?[taskIndex].taskId ??
                      "");

              /// cancel the notification
              await LocalRemainderNotification.cancel(notificationId)
                  .then((value) {
                // log("notification cancel by $notificationId");
              }).onError((error, stackTrace) {
                log("cancel notification error: $error");
              });
            });
          }
        }
      }
    }
  }

  /// delete routine by dayId and taskRoutineCommonId
  Future<void> deleteRoutineTaskBYDayIdAndTaskRoutineCommonId({
    required List<DayDailyRoutinePlannerModel> routinePlans,
    required String commonId,
  }) async {
    for (var plan in routinePlans) {
      // Find the routine in the current day's routineTaskModelList
      RoutineTaskModel? routineToDelete = plan.routineTaskModelList?.firstWhere(
        (routine) => routine.taskRoutineCommonId == commonId,
        orElse: () => RoutineTaskModel(),
      );

      if (routineToDelete?.taskId != null) {
        // Routine found, remove it from the database
        await deleteRoutineTask(
          plan.dayId!,
          routineToDelete?.taskRoutineCommonId ?? "",
        ).then((value) async {
          log('Routine with commonId $commonId deleted.');

          if (routineToDelete?.isNotifyReminder == true) {
            /// just cancel the schedule notification

            int notificationId = generateNotificationId(
              routineToDelete?.taskId ?? "",
            );

            // print("task notification id deleted: $notificationId");

            /// cancel the notification
            await LocalRemainderNotification.cancel(notificationId)
                .then((value) {
              log("notification cancel by $notificationId");
            }).onError((error, stackTrace) {
              log("cancel notification error: $error");
            });
          }
        });
      } else {
        // Routine not found in this day's plan, stop execution
        log('Routine with commonId $commonId not found in dayId: ${plan.dayId}. Stopping execution.');
        break;
      }
    }
  }

  Future<void> deleteRoutineTask(
    String dayId,
    String taskRoutineCommonId,
  ) async {
    // Retrieve the record for the specified dayId
    final List<Map<String, dynamic>> records = await database.query(
      Constants.dailyRoutinePlannerTagsTableName,
      where: 'dayId = ?',
      whereArgs: [dayId],
    );

    if (records.isNotEmpty) {
      final record = records.first;
      List<dynamic> routineTaskModelList =
          jsonDecode(record['routineTaskModelList']);

      // Find and remove the task with the specified taskRoutineCommonId
      routineTaskModelList.removeWhere(
          (task) => task['taskRoutineCommonId'] == taskRoutineCommonId);

      // Update the database with the modified routineTaskModelList
      await database.update(
        Constants.dailyRoutinePlannerTagsTableName,
        {
          'routineTaskModelList': jsonEncode(routineTaskModelList),
        },
        where: 'dayId = ?',
        whereArgs: [dayId],
      );
    }
  }
}
