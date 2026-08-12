import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// Wraps image selection + on-device OCR (Optical Character Recognition).
///
/// WHAT OCR IS: turning the pixels of a screenshot (a WhatsApp/email job offer)
/// back into an editable text string we can feed to the scam detector.
///
/// WHY GOOGLE ML KIT: it runs fully ON-DEVICE (the image never leaves the phone
/// — good privacy), is free, offline, and accurate on phone screenshots. It only
/// supports Android/iOS, which matches this app's primary targets.
class OcrService {
  final ImagePicker _picker = ImagePicker();

  // The recognizer for Latin-script text. Created once and closed in dispose().
  final TextRecognizer _recognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  /// Lets the user pick an image, then returns the recognised text.
  /// Returns null if the user cancels the picker.
  Future<String?> pickAndExtract(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      // Keep full quality — downscaling hurts OCR accuracy on small text.
      imageQuality: 100,
    );
    if (file == null) return null; // user backed out
    return _extractText(file.path);
  }

  Future<String> _extractText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final RecognizedText result = await _recognizer.processImage(inputImage);
    // result.text is the full text with line breaks preserved.
    return result.text.trim();
  }

  void dispose() => _recognizer.close();
}
