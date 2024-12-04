import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_state.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';

class StepCounterGoalListWidget extends StatelessWidget {
  const StepCounterGoalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 13,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Row(
                children: [
                  const Text(
                    "Pedometer Value:",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(context.read<StepsBloc>().pedometerStep.toString()),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<StepsBloc, StepsState>(
                builder: (context, state) {
                  if (state is StepsCounterGoalLoadedState &&
                      state.status == AddStepsGoalsStatus.loaded) {
                    List<StepCounterGoalModel> list =
                        state.listOfStepCounterGoalModel ?? [];

                    return ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Row(
                              children: [
                                const Text(
                                  "Date:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  list[index].todayDateId.toString(),
                                  style: textStyle,
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Start Steps:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      list[index].dayStartStepValue.toString(),
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 7),
                                Row(
                                  children: [
                                    const Text(
                                      "End Steps:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      list[index].dayEndStepValue.toString(),
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Goal Steps",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // const SizedBox(width: 8),
                                Text(
                                  list[index].goalStep.toString(),
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("Empty"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
