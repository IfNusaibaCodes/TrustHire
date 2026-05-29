import 'package:flutter/material.dart';
import 'package:trust_hire_app/Model/guide_section_model.dart';
import 'package:trust_hire_app/Utilities/Constants/image_strings.dart';
import 'package:trust_hire_app/Utilities/Constants/size.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';

class RemoteWorkGuidePage extends StatefulWidget {
  const RemoteWorkGuidePage({super.key});

  @override
  State<RemoteWorkGuidePage> createState() => _RemoteWorkGuidePageState();
}

class _RemoteWorkGuidePageState extends State<RemoteWorkGuidePage> {

  final List<bool> _isRead     = [true, true, true, false, false];
  final List<bool> _isExpanded = [true, false, false, false, false];

  int get _completedCount => _isRead.where((v) => v).length;

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

              /// JOB GUARD HEADER
              _buildJobGuardHeader(),

              const SizedBox(height: 20),

              /// PROGRESS CARD
              _buildProgressCard(),

              const SizedBox(height: 20),

              /// HERO BANNER
              _buildHeroBanner(),

              const SizedBox(height: 25),

              /// SECTION LIST
              ...List.generate(
                GuideSections.all.length,
                    (i) => _buildSectionCard(i),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── JOB GUARD HEADER ────────────────────────────────────────────────────────
  Widget _buildJobGuardHeader() {
    return Row(
      children: [
        const Text(
          'TrustHire',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),

        const Spacer(),

        const Icon(Icons.search, color: Color(0xFF1A56DB), size: 26),
      ],
    );
  }

  // ─── PROGRESS CARD ───────────────────────────────────────────────────────────
  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Your Progress',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: Tsize.Fontxs,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '$_completedCount of ${GuideSections.all.length} sections\ncompleted',
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: Tsize.Fontxlg,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _completedCount / GuideSections.all.length,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HERO BANNER ─────────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          Timages.remoteWorkGuide,
          width: double.infinity,
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // ─── SECTION CARD ─────────────────────────────────────────────────────────────
  Widget _buildSectionCard(int index) {
    final section = GuideSections.all[index];
    final isRead  = _isRead[index];
    final isOpen  = _isExpanded[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [

            /// HEADER ROW
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [

                  // Left color bar
                  Container(
                    width: 4, height: 46,
                    decoration: BoxDecoration(
                      color: section.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Icon box
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(section.icon, size: 22, color: section.color),
                  ),

                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: Tsize.Fontsm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Read / Mark as Read button
                  GestureDetector(
                    onTap: () => setState(() => _isRead[index] = !_isRead[index]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isRead ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isRead ? Colors.black : Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isRead ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 13,
                            color: isRead ? Colors.white : Colors.black54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isRead ? 'Read' : 'Mark as\nRead',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isRead ? Colors.white : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Expand / collapse arrow
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded[index] = !_isExpanded[index]),
                    child: Icon(
                      isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            /// EXPANDED BODY
            if (isOpen)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffF0F4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                // ── ONLY THIS PART CHANGED ──
                child: index == 0
                    ? _buildSetupTips()
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: section.points.map((point) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          point,
                          style: const TextStyle(
                            fontSize: Tsize.Fontxs,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ),
                  ).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── SETUP TIPS ──────────────────────────────────────────────────────────────
  Widget _buildSetupTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          Ttexts.guideSetupTips,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A56DB),
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 12),

        _tip(Icons.wifi, 'Reliable Connection:',
            'Always have a backup mobile hotspot. Aim for at least 20Mbps for smooth video calls.'),
        const SizedBox(height: 10),
        _tip(Icons.chair_outlined, 'Ergonomics:',
            'Invest in a chair with lumbar support. Your health is your primary career asset.'),
        const SizedBox(height: 10),
        _tip(Icons.headset_outlined, 'Noise Control:',
            'Use noise-cancelling headphones and tools like Krisp to maintain professionalism.'),
        const SizedBox(height: 10),
        _tip(Icons.access_time_outlined, 'Time Discipline:',
            'Set fixed start and end times each day. Clear boundaries prevent burnout and boost focus.'),
      ],
    );
  }

  Widget _tip(IconData icon, String bold, String rest) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF1A56DB)),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: Tsize.Fontxs,
                color: Colors.black87,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '$bold ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: rest),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
