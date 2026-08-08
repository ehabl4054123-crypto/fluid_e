import 'package:flutter/material.dart';

class WaterDropButton extends StatefulWidget {
  const WaterDropButton({super.key});

  @override
  State<WaterDropButton> createState() => _WaterDropButtonState();
}

class _WaterDropButtonState extends State<WaterDropButton> {
  // متغير لمعرفة ما إذا كان المستخدم يضغط على الزر الآن أم لا
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // تغيير الحالة عند الضغط والإفلات
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      
      // AnimatedContainer يعطي حركة نعومة عند تغير الظلال
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // التدرج اللوني لسطح القطرة
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF333333), Color(0xFF252525)],
          ),
          // التحكم في الظلال بناءً على حالة الضغط
          boxShadow: isPressed
              ? [] // عند الضغط تختفي الظلال الخارجية ليبدو الزر غائراً
              : [
                  // الظل السفلي الداكن (يعطي عمق)
                  const BoxShadow(color: Color(0xFF151515), offset: Offset(8, 8), blurRadius: 16),
                  // الظل العلوي الفاتح (يعطي لمعة البروز)
                  const BoxShadow(color: Color(0xFF3B3B3B), offset: Offset(-8, -8), blurRadius: 16),
                ],
        ),
        // الأيقونة داخل القطرة
        child: const Icon(Icons.home, color: Colors.cyanAccent, size: 30),
      ),
    );
  }
}

