import 'package:flutter/material.dart';

import '../Utilities/Constants/size.dart';

class ScamDetectorPage extends StatefulWidget {
  const ScamDetectorPage({super.key});

  @override
  State<ScamDetectorPage> createState() => _ScamDetectorPageState();
}

class _ScamDetectorPageState extends State<ScamDetectorPage> {
  int selectedMethod = 0;

  final TextEditingController textController = TextEditingController();

  void selectMethod(int index) {
    setState(() {
      selectedMethod = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// BACK BUTTON
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                  ),

                  const Icon(
                    Icons.help_outline,
                    size: 28,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// TITLE
              const Text(
                "Scam Detector",
                style: TextStyle(
                  fontSize:Tsize.Fontxlg,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Verify job offers before you apply or share personal data.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 30),

              /// STAY PROTECTED CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [

                          Text(
                            "Stay Protected",
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 12),

                          Text(
                            "Our AI analyzes 20+ risk\nfactors including email\ndomains and salary realism.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.shield,
                      color: Colors.cyanAccent,
                      size: 50,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              /// CHOOSE INPUT
              const Center(
                child: Text(
                  "Choose input method",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// PASTE TEXT
              buildInputCard(
                index: 0,
                icon: Icons.description,
                title: "Paste Text",
                subtitle: "Job description, email, or message",
              ),

              const SizedBox(height: 20),

              /// UPLOAD SCREENSHOT
              buildInputCard(
                index: 1,
                icon: Icons.image,
                title: "Upload Screenshot",
                subtitle: "WhatsApp, Facebook, or Email caps",
              ),

              const SizedBox(height: 20),

              /// ENTER URL
              buildInputCard(
                index: 2,
                icon: Icons.link,
                title: "Enter URL",
                subtitle: "Link to the job posting",
              ),

              const SizedBox(height: 30),

              /// TEXT FIELD
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                ),

                child: Column(
                  children: [

                    TextField(
                      controller: textController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Paste the job post here...",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "${textController.text.length} / 5000",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ANALYZE BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: () {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Analyzing for scams..."),
                      ),
                    );
                  },

                  child: const Text(
                    "Analyze for Scams",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// LEARN CARD
              InkWell(
                borderRadius: BorderRadius.circular(18),

                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Learning lab clicked"),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  child: Row(
                    children: [

                      const Icon(
                        Icons.lightbulb_outline,
                        size: 30,
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Not sure what to look for?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "Learn common red flags in our Lab",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 50,
                        width: 50,

                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = selectedMethod == index;

    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        selectMethod(index);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$title selected"),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 2,
          ),
        ),

        child: Row(
          children: [

            Container(
              height: 65,
              width: 65,

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(
                icon,
                size: 32,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.black : Colors.grey,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}