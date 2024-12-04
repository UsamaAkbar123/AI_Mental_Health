import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController? controller;

  const HomeSearchBar({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.w)
      ),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search anything...",
            suffixIcon: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset("assets/signin/search.svg")),
            contentPadding: EdgeInsets.only(top: 8.h,left: 15.w)),
      ),
    );
  }
}
