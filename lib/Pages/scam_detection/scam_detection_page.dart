import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/reusable_widgets.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/trust_hire_app_bar.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'red_flags_page.dart';
import 'scam_analyzer.dart';
import 'scam_detection_database.dart';
import 'ml_scam_service.dart';
import 'ocr_service.dart';


class ScamDetectorPage extends StatefulWidget {
  const ScamDetectorPage({super.key});

  @override
  State<ScamDetectorPage> createState() => _ScamDetectorPageState();
}

class _ScamDetectorPageState extends State<ScamDetectorPage> {
  int _method = 0;
  final _textCtrl = TextEditingController();
  final _repo = ScamCheckRepository();
  final _mlService = MlScamService();
  final _ocrService = OcrService();
  ScamResult? _result;
  bool _analyzing = false;
  bool _ocrRunning = false;
  bool _hasOcrText = false;

  /// Lets the user choose camera or gallery, runs OCR, and puts the extracted
  /// text into the same controller the paste box uses — so it flows into the
  /// exact same ML analysis path.
  Future<void> _pickAndOcr(ImageSource source) async {
    setState(() {
      _ocrRunning = true;
      _result = null;
    });
    try {
      final text = await _ocrService.pickAndExtract(source);
      if (!mounted) return;
      if (text == null) {
        // user cancelled the picker
        setState(() => _ocrRunning = false);
        return;
      }
      if (text.trim().isEmpty) {
        setState(() => _ocrRunning = false);
        showAppSnackBar(context,
            'No readable text found in that image. Try a clearer screenshot.',
            background: TColors.appBlue);
        return;
      }
      setState(() {
        _textCtrl.text = text;
        _hasOcrText = true;
        _ocrRunning = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _ocrRunning = false);
      showAppSnackBar(context, 'Could not read image: $e',
          background: TColors.appBlue);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndOcr(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndOcr(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _analyze() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) {
      showAppSnackBar(context, 'Paste a job post to analyze.',
          background: TColors.appBlue);
      return;
    }

    setState(() => _analyzing = true);

    // Calls the ML API; transparently falls back to the offline rule engine if
    // the server is unreachable.
    final analysis = await _mlService.analyze(text);
    final result = analysis.result;

    if (!mounted) return;
    setState(() {
      _result = result;
      _analyzing = false;
    });

    if (analysis.usedFallback) {
      showAppSnackBar(context,
          'Scam server unavailable — used the offline detector.',
          background: TColors.appBlue);
    }

    // Only persist real analyses (skip the guard results that aren't job posts).
    if (result.riskLevel == 'Unknown' || result.riskLevel == 'Not Enough Info') {
      return;
    }

    try {
      await _repo.saveResult(
        inputText: text,
        score: result.score,
        riskLevel: result.riskLevel,
        issues: result.issues,
        positives: result.positives,
      );
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context, 'Could not sync result: $e',
            background: TColors.appBlue);
      }
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _mlService.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.appScaffoldBg,
      appBar: const TrustHireAppBar(title: 'Detect Scam'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientBannerCard(
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stay Protected',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                        SizedBox(height: 8),
                        Text(
                          'Analyze job offers for 20+ risk factors — suspicious emails, unrealistic salaries, and known scam patterns.',
                          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.shield_rounded, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text('Choose input method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: TColors.appNavy)),
            const SizedBox(height: 14),

            Row(
              children: [
                OptionCard(
                  icon: Icons.description_outlined,
                  label: 'Paste Text',
                  selected: _method == 0,
                  onTap: () => setState(() => _method = 0),
                ),
                const SizedBox(width: 12),
                OptionCard(
                  icon: Icons.image_outlined,
                  label: 'Screenshot',
                  selected: _method == 1,
                  onTap: () => setState(() => _method = 1),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_method == 0) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _textCtrl,
                      maxLines: 7,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Paste the job post, email or message here...',
                        hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14, bottom: 10),
                      child: Text(
                        '${_textCtrl.text.length} / 5000',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              GestureDetector(
                onTap: _ocrRunning ? null : _showImageSourceSheet,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: _ocrRunning
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(strokeWidth: 2),
                            SizedBox(height: 12),
                            Text('Extracting text…',
                                style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w600)),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_rounded,
                                size: 40, color: Color(0xFF9CA3AF)),
                            SizedBox(height: 10),
                            Text('Tap to upload screenshot',
                                style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Text('WhatsApp, email or job site caps',
                                style: TextStyle(
                                    color: Color(0xFF9CA3AF), fontSize: 12)),
                          ],
                        ),
                ),
              ),

              // After OCR, show the extracted text so the user can review/fix it
              // before analysing (OCR is rarely 100% perfect).
              if (_hasOcrText) ...[
                const SizedBox(height: 14),
                const Text('Extracted text (edit if needed)',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: TColors.appNavy)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: TextField(
                    controller: _textCtrl,
                    maxLines: 7,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Extracted text will appear here...',
                      hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                // Both methods analyse the text in _textCtrl (typed, or filled
                // by OCR), so the same ML pipeline runs for screenshots too.
                onPressed: (_analyzing || _ocrRunning) ? null : _analyze,
                icon: _analyzing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.shield_rounded, size: 20),
                label: Text(_analyzing ? 'Analyzing…' : 'Analyze for Scams',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.appNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_result != null) ...[
              ScamResultCard(
                score: _result!.score,
                riskLevel: _result!.riskLevel,
                issues: _result!.issues,
                positives: _result!.positives,
              ),
              const SizedBox(height: 16),
            ],

            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RedFlagsPage()),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.warning_amber_rounded,
                          color: Colors.amber, size: 26),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Know the Warning Signs',
                              style: TextStyle(fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1F36))),
                          SizedBox(height: 3),
                          Text('Learn common job scam red flags',
                              style: TextStyle(fontSize: 12,
                                  color: Color(0xFF9CA3AF))),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: Color(0xFF9CA3AF)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
