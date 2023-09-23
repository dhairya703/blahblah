import 'package:firestore/core/app_export.dart';
import 'package:firestore/theme/app_decoration.dart';
import 'package:firestore/theme/custom_text_style.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_image_view.dart';
// import '../frame_243_screen/frame_243_screen.dart';
import '../2nd/frame_243_screen.dart';
import 'controller/frame_244_controller.dart';
import 'package:flutter/material.dart';

import 'package:firestore/widgets/custom_outlined_button.dart';

class Frame244Screen extends GetWidget<Frame244Controller> {
  const Frame244Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                    child: SizedBox(
                        height: mediaQueryData.size.height,
                        width: double.maxFinite,
                        child: Stack(alignment: Alignment.topRight, children: [
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 17.h, vertical: 62.v),
                                  decoration: AppDecoration.fillGray,
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 25.v),
                                        CustomImageView(
                                            svgPath: ImageConstant.imgArrowleft,
                                            height: 36.adaptSize,
                                            width: 36.adaptSize,
                                            onTap: () {
                                              onTapImgArrowleftone();
                                            }),
                                        SizedBox(height: 395.v),
                                        Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                width: 245.h,
                                                child: Text(
                                                    "Choose the best verified lawyer profiles\n in your area based on qualifications, \nexperience, and reviews."
                                                        .tr,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: theme
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                            height: 1.54)))),
                                       CustomOutlinedButton(
                                            text: "Next".tr,
                                              onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Frame243Screen()),
                                              );
                                            },
                                            margin: EdgeInsets.only(
                                                left: 42.h,
                                                top: 167.v,
                                                right: 58.h),
                                            rightIcon: Container(
                                                margin:
                                                    EdgeInsets.only(left: 7.h),
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgArrowrightGray90002)),
                                            buttonTextStyle: CustomTextStyles
                                                .labelLargeInterGray90002)
                                      ])))

                                  ,
                          CustomImageView(
                              imagePath: ImageConstant
                                  .imgCloseofgavelincourtroom251x317,
                              height: 251.v,
                              width: 317.h,
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 217.v)),
                          CustomImageView(
                              imagePath:
                                  ImageConstant.imgCloseofgavelincourtroom,
                              height: 81.v,
                              width: 192.h,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(bottom: 361.v))
                        ]))))));
  }

  /// Navigates to the previous screen.
  ///
  /// When the action is triggered, this function uses the [Get] package to
  /// navigate to the previous screen in the navigation stack.
  onTapImgArrowleftone() {
    Get.back();
  }
}
