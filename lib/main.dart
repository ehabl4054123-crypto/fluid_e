import 'package:flutter/material.dart';
import 'water_drop_button.dart';

void main() {
  runApp(const FluidEApp());
}

class FluidEApp extends StatelessWidget {
  const FluidEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fluid_e',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF1E1E1E)),
      home: const Scaffold(
        body: Center(
          child: Text('fluid_e Animated UI', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        // استدعاء شريط التنقل الجديد التفاعلي
        bottomNavigationBar: FluidNavBar(),
        // السماح للشاشة بالتمدد خلف الشريط الشفاف
        extendBody: true, 
      ),
    );
  }
}

class FluidNavBar extends StatefulWidget {
  const FluidNavBar({super.key});

  @override
  State<FluidNavBar> createState() => _FluidNavBarState();
}

class _FluidNavBarState extends State<FluidNavBar> {
  // متغير لحفظ مكان الزرار (من 0.0 إلى 1.0)
  double buttonPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const buttonWidth = 70.0;
    
    // حساب المكان الفعلي للزرار على الشاشة
    double absoluteX = (screenWidth * buttonPosition) - (buttonWidth / 2);

    return SizedBox(
      height: 120, // ارتفاع كافي لحركة الانحناء
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. الشريط السفلي المرسوم رياضياً
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: CustomPaint(
              size: Size(screenWidth, 80), // ارتفاع الشريط
              painter: FluidPainter(buttonPosition),
            ),
          ),
          // 2. زر قطرة الماء القابل للسحب
          Positioned(
            bottom: 25, // رفع الزرار ليستقر داخل المنحنى
            left: absoluteX,
            child: GestureDetector(
              // تحديث مكان الزرار عند سحبه يميناً ويساراً
              onPanUpdate: (details) {
                setState(() {
                  buttonPosition += details.delta.dx / screenWidth;
                  // منع الزرار من الخروج برا الشاشة
                  buttonPosition = buttonPosition.clamp(0.1, 0.9);
                });
              },
              child: const WaterDropButton(),
            ),
          ),
        ],
      ),
    );
  }
}

// كود الرياضيات الخاص بالمنحنى المائي (Fluid Curve)
class FluidPainter extends CustomPainter {
  final double position; // موقع الانحناء
  FluidPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // أبعاد المنحنى
    const double curveWidth = 140;
    const double curveDepth = 55;
    
    final double centerX = size.width * position;
    final double startX = centerX - (curveWidth / 2);
    final double endX = centerX + (curveWidth / 2);

    path.moveTo(0, 0); 
    path.lineTo(startX - 20, 0); // الخط المستقيم قبل المنحنى
    
    // رسم المنحنى النازل (الجزء الأيسر من التجويف)
    path.cubicTo(
      startX, 0, 
      centerX - 30, curveDepth, 
      centerX, curveDepth, 
    );
    
    // رسم المنحنى الطالع (الجزء الأيمن من التجويف)
    path.cubicTo(
      centerX + 30, curveDepth,
      endX, 0,
      endX + 20, 0,
    );

    path.lineTo(size.width, 0); // الخط المستقيم بعد المنحنى
    path.lineTo(size.width, size.height); // النزول لآخر الشاشة
    path.lineTo(0, size.height); // الرجوع لأول الشاشة
    path.close(); // إغلاق الشكل

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FluidPainter oldDelegate) {
    // إعادة الرسم فقط إذا تغير مكان الزرار
    return oldDelegate.position != position;
  }
}
