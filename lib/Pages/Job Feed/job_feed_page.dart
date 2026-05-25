import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:trust_hire_app/Common/Widgets_Login_Signup/form_divider.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/all_jobs.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/recent_job_feed.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/custom_button.dart';

import '../../Utilities/Constants/size.dart';

class JobFeedPage extends StatelessWidget {
  const JobFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(length: 2, child: Scaffold(
      backgroundColor: TColors.secondaryColor,
      body: SafeArea(
          child: Padding(padding: const EdgeInsetsGeometry.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding:  EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Find Your Safe Career",
                                style: GoogleFonts.interTight(
                                  fontSize: Tsize.Fontxlg,
                                  fontWeight: FontWeight.bold,
                                ),

                              ),
                              SizedBox(
                                height: Tsize.spaceBtwItems,
                              ),
                              Text(
                                "Verified opportunities in Bangladesh",
                                style: GoogleFonts.jetBrainsMono(
                                  color: TColors.grey,
                                  fontSize: Tsize.Fontmd,
                                ),
                              ),
                              SizedBox(
                                height: Tsize.spaceBtwItems,
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
                Divider(thickness: 2,),
                SizedBox(
                  height: Tsize.spaceBtwSections,
                ),
                Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(24),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Recommended for you",style: GoogleFonts.jetBrainsMono(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Tsize.Fontsm,
                                              color: Colors.black
                                          ),),
                                          SizedBox(width: Tsize.defaultSpace,),
                                          // testing button
                                          CustomButton(onTap: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => RecentJobFeedPage()));
                                          },
                                              buttonText: "see recent test button"),
                                          SizedBox(width: Tsize.defaultSpace,),
                                          TextButton(onPressed: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => RecentJobFeedPage()));
                                          },
                                              child: const Text("See Recent Jobs", style: TextStyle(
                                                  fontSize: Tsize.Fontxs,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                              ))),
                                        ],
                                      ),
                                      SizedBox( height: Tsize.spaceBtwSections,),

                                    ],
                                  )
                                ],

                              ),
                            ),
                          )
                        ],
                      ),
                    )
                )
              ],

            ),


          )),

    ));

  }
}