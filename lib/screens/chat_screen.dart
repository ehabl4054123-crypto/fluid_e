import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      appBar: AppBar(
        title: const Text('المراسلة', style: TextStyle(color: Color(0xFF00A8E8), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A192F),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // منطقة عرض الرسائل
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ChatBubble(text: 'أهلاً بك في تطبيق fluid_e!', isMe: false),
                ChatBubble(text: 'شكراً جداً، التطبيق شكله رائع!', isMe: true),
                ChatBubble(text: 'الخطوة القادمة هي ربط السيرفرات.', isMe: false),
              ],
            ),
          ),
          // حقل كتابة الرسالة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: const EdgeInsets.only(bottom: 100), // عشان شريط المياه ميغطيش عليها
            decoration: BoxDecoration(
              color: const Color(0xFF112240),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Color(0xFF00A8E8)),
                  onPressed: () {
                    // سيتم برمجتها لاحقاً لإرسال الرسالة للسيرفر
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// كلاس لتصميم فقاعة الشات
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF00A8E8) : const Color(0xFF112240),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 0 : 20),
            bottomRight: Radius.circular(isMe ? 20 : 0),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
