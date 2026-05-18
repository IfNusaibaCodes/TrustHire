import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/image_strings.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';

import '../Authentication/controllers/onboarding_controller.dart';
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {

    final double screenwidth = MediaQuery.of(Get.context!).size.width;
    final double screenheight = MediaQuery.of(Get.context!).size.height;
    final Size screensize = MediaQuery.of(Get.context!).size;

    final p_controller = Get.put(OnBoardingController());
    final d_controller = OnBoardingController.instance;


    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: p_controller.pageController,
            onPageChanged: p_controller.updatePageIndicator,
            children: [
              On_Boarding_Page(screenwidth: screenwidth, screenheight: screenheight, image: Timages.onBoardingImage1, title: Ttexts.OnBoardingTitle1, subTitle: Ttexts.OnBoardingSubTitle1,),
              On_Boarding_Page(screenwidth: screenwidth, screenheight: screenheight, image: Timages.onBoardingImage2, title: Ttexts.OnBoardingTitle2, subTitle: Ttexts.OnBoardingSubTitle2,),
              On_Boarding_Page(screenwidth: screenwidth, screenheight: screenheight, image: Timages.onBoardingImage3, title: Ttexts.OnBoardingTitle3, subTitle: Ttexts.OnBoardingSubTitle3,),
            ],
          ),
          Positioned(top : kToolbarHeight,
          right: 24,
          child: TextButton(onPressed: () => OnBoardingController.instance.skipPage(), child: const Text("Skip"))),

          Positioned(
            bottom: kBottomNavigationBarHeight + 25,
              left: 24,
              child: SmoothPageIndicator(
                controller: d_controller.pageController,
                onDotClicked: d_controller.dotNavigatorClick,
                count: 3,
                effect: ExpandingDotsEffect(activeDotColor: Colors.black, dotHeight: 6),)),

          Positioned(
              right: 24,
              bottom: kBottomNavigationBarHeight,
              child: ElevatedButton(onPressed: () => OnBoardingController.instance.nextPage(),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), backgroundColor: Colors.black,foregroundColor: Colors.white
                  ),
                  child: Icon(Iconsax.arrow_right_3)))
        ],
      )

    );
  }
}

class On_Boarding_Page extends StatelessWidget {
  const On_Boarding_Page({
    super.key,
    required this.screenwidth,
    required this.screenheight, required this.image, required this.title, required this.subTitle,
  });

  final double screenwidth;
  final double screenheight;

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Image(

              width: screenwidth * 0.8,
              height: screenheight * 0.6,
              image: AssetImage(image)),
          Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
