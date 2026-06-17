import 'dart:io';
import 'package:image/image.dart' as img;

final navy = img.ColorRgb8(30, 42, 96);
final white = img.ColorRgb8(255, 255, 255);

const size = 1024;
const cx = size ~/ 2;

void drawBriefcase(img.Image image, img.Color bg) {
  void stroke(int x1, int y1, int x2, int y2, int radius, int thickness) {
    img.fillRect(image, x1: x1, y1: y1, x2: x2, y2: y2, radius: radius, color: white);
    img.fillRect(
      image,
      x1: x1 + thickness,
      y1: y1 + thickness,
      x2: x2 - thickness,
      y2: y2 - thickness,
      radius: (radius - thickness).clamp(0, radius),
      color: bg,
    );
  }

  const t = 34; // stroke thickness

  stroke(cx - 96, 312, cx + 96, 430, 44, t);

  stroke(cx - 240, 404, cx + 240, 784, 56, t);

  img.fillRect(
    image,
    x1: cx - 56,
    y1: 470 - 24,
    x2: cx + 56,
    y2: 470 + 24,
    radius: 16,
    color: white,
  );
  img.fillRect(
    image,
    x1: cx - 56 + t,
    y1: 470 - 24 + t,
    x2: cx + 56 - t,
    y2: 470 + 24 - t,
    radius: 4,
    color: bg,
  );
}

void main() {
  final full = img.Image(width: size, height: size, numChannels: 4);
  img.fill(full, color: navy);
  drawBriefcase(full, navy);
  File('assets/images/LogoImages/app_icon.png')
      .writeAsBytesSync(img.encodePng(full));

  final fg = img.Image(width: size, height: size, numChannels: 4);
  drawBriefcase(fg, navy);
  File('assets/images/LogoImages/app_icon_foreground.png')
      .writeAsBytesSync(img.encodePng(fg));

  stdout.writeln('Generated app_icon.png and app_icon_foreground.png');
}
