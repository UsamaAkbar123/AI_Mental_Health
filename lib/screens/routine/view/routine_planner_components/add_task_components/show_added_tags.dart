import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/routine/bloc/routine_event.dart';
import 'package:freud_ai/screens/routine/bloc/routine_state.dart';
import 'package:freud_ai/screens/routine/model/tags_model.dart';

class ShowAddedTags extends StatefulWidget {
  final String? selectedTag;

  const ShowAddedTags({super.key, this.selectedTag});

  @override
  State<ShowAddedTags> createState() => _ShowAddedTagsState();
}

class _ShowAddedTagsState extends State<ShowAddedTags> {
  bool isShowTextField = false;
  FocusNode customEventFocus = FocusNode();
  List<TagsModel> listOfAddedTagsModel = [];
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///addTagItemContainer(false, AddedTagsModel(name: "Custom Events")),
          // 20.height,

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 180.h,
            child: BlocBuilder<RoutineBloc, RoutinePlannerState>(
                builder: (context, state) {
              listOfAddedTagsModel.clear();

              for (var data in state.listOfTags!) {
                listOfAddedTagsModel.add(TagsModel(
                    title: data.title,
                    isSelected: widget.selectedTag == data.title ? true : false,
                    id: data.id));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: listOfAddedTagsModel.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  if (listOfAddedTagsModel[index].title != 'All') {
                    return addTagItemContainer(listOfAddedTagsModel[index]);
                  } else {
                    return const SizedBox();
                  }
                },
              );
            }),
          ),

          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
                child: CommonWidgets().customAppBar(
                  text: "Tags",
                  //actionWidget: appBarCancelButton(),
                ),
              ),
              20.height,
              addCustomEvent(),
            ],
          ),
        ],
      ),
    );
  }

  ///Add Custom Event
  Widget addCustomEvent() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(22.w)),
      child: Column(
        children: [
          ///TextField
          isShowTextField
              ? SizedBox(
                  height: 56.h,
                  child: TextField(
                    focusNode: customEventFocus,
                    controller: editingController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12.w, top: 14.h),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        alignment: Alignment.center,
                        onPressed: () => addSubTaskItemToList(),
                        icon: const Icon(Icons.check_circle_outline),
                      ), // Replace with your desired icon
                    ),
                  ),
                )
              : const SizedBox(),

          ///
          !isShowTextField
              ? Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: AppTheme.cT!.whiteColor,
                      borderRadius: BorderRadius.circular(22.w)),
                  child: Row(
                    children: [
                      CommonWidgets().makeDynamicText(
                          text: "Custom Event",
                          size: 18,
                          weight: FontWeight.w700,
                          color: AppTheme.cT!.appColorLight),
                      const Spacer(),
                      Icon(Icons.add_circle_outline_outlined,
                          color: AppTheme.cT!.appColorLight!)
                    ],
                  ),
                ).clickListener(click: () {
                  isShowTextField = true;
                  customEventFocus.requestFocus();
                  setState(() => {});
                })
              : const SizedBox(),
        ],
      ),
    );
  }

  ///Add SubTasks Item to List
  addSubTaskItemToList() {
    if (editingController.text.isNotEmpty) {
      TagsModel tagsModel = TagsModel(
        title: editingController.text,
        isSelected: false,
      );

      BlocProvider.of<RoutineBloc>(context).add(
        AddRoutinePlannerTagEvent(tagsModel),
      );
      BlocProvider.of<RoutineBloc>(context).add(GetRoutinePlanTagEvent());

      ///Call Bloc Here
      listOfAddedTagsModel.clear();
      editingController.clear();

      isShowTextField = false;
    } else {
      editingController.clear();
      isShowTextField = false;
    }

    setState(() => {});
  }



  ///Notification Container
  Widget addTagItemContainer(TagsModel model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(22.w)),
      child: Row(
        children: [
          CommonWidgets().makeDynamicText(
              text: model.title,
              size: 18,
              weight: FontWeight.w700,
              color: AppTheme.cT!.appColorLight),
          const Spacer(),
          customRadioButton(model.isSelected!)
        ],
      ),
    ).clickListener(click: () {
      // model.isSelected = !model.isSelected!;

      model = model.copyWith(
          isSelected: !model.isSelected!,
      );

      Navigate.pop(model.title);

      setState(() => {});
    });
  }

  ///Custom Radio Button
  Widget customRadioButton(bool isSelected) {
    return Container(
      height: 18.h,
      width: 18.w,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.cT!.appColorLight!,
          width: 2.0.w,
        ),
      ),
      child: Container(
        height: 16.h,
        width: 16.w,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cT!.appColorLight : AppTheme.cT!.whiteColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
