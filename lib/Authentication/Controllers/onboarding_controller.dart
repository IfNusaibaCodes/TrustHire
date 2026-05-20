import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_hire_app/Pages/Login/login_page.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();

  //Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;


  //Update current index when page scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  //Jump to specific dot selected page
  void dotNavigatorClick(index){
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  //Update current index and jump to next page
  void nextPage(){
    if(currentPageIndex.value==2){
      Get.offAll( const LoginPage());
    }
    else{
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  //Update current index and jump to last page
  void skipPage(){
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }

}