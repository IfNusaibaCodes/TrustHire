import 'package:flutter/material.dart';

class ScamDetectorPage extends StatefulWidget {
  const ScamDetectorPage({super.key});

  @override
  State<ScamDetectorPage> createState() =>
      _ScamDetectorPageState();
}

class _ScamDetectorPageState
    extends State<ScamDetectorPage> {

  TextEditingController textController =
  TextEditingController();

  String resultText = "";
  String riskLevel = "";
  List<String> detectedIssues = [];
  List<String> positiveSigns = [];

  bool isLoading = false;

  void analyzeScam() async {

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    String text =
    textController.text.toLowerCase();

    detectedIssues.clear();
    positiveSigns.clear();

    int score = 100;



    if (text.contains("urgent")) {
      detectedIssues.add(
          "Urgent hiring pressure");
      score -= 20;
    }

    if (text.contains("payment")) {
      detectedIssues.add(
          "Requests payment");
      score -= 30;
    }

    if (text.contains("gmail")) {
      detectedIssues.add(
          "Uses free email");
      score -= 15;
    }

    if (text.contains("salary 5000")) {
      detectedIssues.add(
          "Unrealistic salary");
      score -= 20;
    }



    if (text.contains("website")) {
      positiveSigns.add(
          "Has company website");
    }

    if (text.contains("experience")) {
      positiveSigns.add(
          "Proper job description");
    }



    if (score >= 70) {
      riskLevel = "Low Risk";
    }

    else if (score >= 40) {
      riskLevel = "Medium Risk";
    }

    else {
      riskLevel = "High Risk";
    }

    resultText = "$score% Safe";

    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Scam Detector"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [


            const Text(
              "Check Job Safety",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),


            const Text(
              "Paste Job Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(

              controller: textController,

              maxLines: 8,

              decoration: InputDecoration(
                hintText:
                "Paste job post, email, or message...",
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),


            ElevatedButton.icon(

              onPressed: () {},

              icon: const Icon(Icons.image),

              label:
              const Text("Upload Screenshot"),

              style: ElevatedButton.styleFrom(
                minimumSize:
                const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 20),


            const Text(
              "Enter URL",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(

              decoration: InputDecoration(
                hintText:
                "Paste job post link...",
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),


            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed: analyzeScam,

                child: const Text(
                  "Analyze Now",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),


            if (isLoading)
              Column(
                children: const [

                  CircularProgressIndicator(),

                  SizedBox(height: 15),

                  Text(
                    "Analyzing job safety...",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),


            if (resultText.isNotEmpty &&
                !isLoading)

              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    resultText,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: riskLevel == "High Risk"
                          ? Colors.red
                          : riskLevel == "Medium Risk"
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Risk Level: $riskLevel",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 25),


                  const Text(
                    "Detected Issues",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...detectedIssues.map(
                        (issue) => ListTile(
                      leading: const Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      title: Text(issue),
                    ),
                  ),

                  const SizedBox(height: 20),


                  const Text(
                    "Positive Signs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...positiveSigns.map(
                        (sign) => ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(sign),
                    ),
                  ),

                ],
              )

          ],
        ),
      ),
    );
  }
}