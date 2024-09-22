import 'package:flutter/material.dart';

class NotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // رسم المستطيل
    path.moveTo(0, 0); // البداية في الزاوية العلوية اليسرى
    path.lineTo(0, size.height); // النزول إلى أسفل اليسار

    // رسم النوتش في الأسفل
    double notchWidth = size.width * 1; // عرض النوتش
    double notchHeight = size.height * 0.3; // ارتفاع النوتش
    double notchStartX =
        (size.width - notchWidth) / 2; // بداية النوتش في المنتصف

    path.lineTo(notchStartX, size.height); // الانتقال إلى بداية النوتش
    path.lineTo(notchStartX + notchWidth / 2,
        size.height - notchHeight); // رسم زاوية النوتش
    path.lineTo(notchStartX + notchWidth, size.height); // إكمال النوتش

    path.lineTo(size.width, size.height); // الانتقال إلى الزاوية السفلى اليمنى
    path.lineTo(size.width, 0); // الرجوع إلى الزاوية العليا اليمنى
    path.close(); // إغلاق المسار

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
