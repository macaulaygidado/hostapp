//******************************************************************
// This file contain App Default Texts  that will use throughout the entire App
//***********************************************************************
import 'package:hostapp/src/style/AppImage.dart';

class AppText{
  static const String appName = "Guest Registration";
   static const String slogan = "Easiest way for Guest Registration";
  static const String skip = "Skip";
  static const String next = "Next";
  static const String done = "Done";

  /// the welcome screen data
  static const List onBoardingData = [
    {
      "title": "Welcome to Guest Registration",
      "image": AppImage.board1,
      "desc": "Verify your guests and protect your property against bad actors"
    },
    {
      "title": "Sign up",
      "image": AppImage.board2,
      "desc": "Customize your registration flow depending on what you require from guests."
    },
    {
      "title": "Share Link",
      "image": AppImage.board3,
      "desc": "Share your unique link with guests so they can walk through ahead of time"
    },
    {
      "title": "Receive Document",
      "image": AppImage.board4,
      "desc": "Once guests go through your registration flow, you receive all the documentation instantly."
    },

  ];
}