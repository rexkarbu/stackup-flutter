import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final dir = Directory('assets/icon');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  const size = 512;
  final image = img.Image(width: size, height: size);

  // Background #12131C
  img.fill(image, color: img.ColorRgba8(0x12, 0x13, 0x1C, 255));

  // Lingkaran luar glowing halus
  img.fillCircle(
    image,
    x: 256,
    y: 256,
    radius: 200,
    color: img.ColorRgba8(0x1E, 0x1F, 0x2E, 255),
  );

  // Gambar simbol controller / tumpukan (StackUp)
  // Stack card bawah (Indigo #6366F1)
  img.fillRect(
    image,
    x1: 140,
    y1: 160,
    x2: 372,
    y2: 210,
    radius: 16,
    color: img.ColorRgba8(0x63, 0x66, 0xF1, 255),
  );

  // Stack card tengah (Purple #8B5CF6)
  img.fillRect(
    image,
    x1: 120,
    y1: 235,
    x2: 392,
    y2: 285,
    radius: 16,
    color: img.ColorRgba8(0x8B, 0x5C, 0xF6, 255),
  );

  // Stack card atas / Gamepad base (Cyan #06B6D4)
  img.fillRect(
    image,
    x1: 100,
    y1: 310,
    x2: 412,
    y2: 360,
    radius: 16,
    color: img.ColorRgba8(0x06, 0xB6, 0xD4, 255),
  );

  // D-Pad aksen di kartu atas
  img.fillRect(image,
      x1: 150,
      y1: 325,
      x2: 175,
      y2: 345,
      color: img.ColorRgba8(0x12, 0x13, 0x1C, 255));
  img.fillRect(image,
      x1: 157,
      y1: 318,
      x2: 168,
      y2: 352,
      color: img.ColorRgba8(0x12, 0x13, 0x1C, 255));

  // Action button dots
  img.fillCircle(image,
      x: 340,
      y: 335,
      radius: 6,
      color: img.ColorRgba8(0x12, 0x13, 0x1C, 255));
  img.fillCircle(image,
      x: 365,
      y: 335,
      radius: 6,
      color: img.ColorRgba8(0x12, 0x13, 0x1C, 255));

  final pngBytes = img.encodePng(image);
  File('assets/icon/app_icon.png').writeAsBytesSync(pngBytes);
  stdout.writeln('✅ Icon generated: assets/icon/app_icon.png');
}
