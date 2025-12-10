import 'package:flutter/material.dart';

/// Floating overlay button widget
/// Kullanıcının diğer uygulamalarüzerinde görebileceği buton
class FloatingControlButton extends StatelessWidget {
  final bool isScrolling;
  final bool isPaused;
  final VoidCallback onTap;
  final VoidCallback onStop;
  
  const FloatingControlButton({
    super.key,
    required this.isScrolling,
    required this.isPaused,
    required this.onTap,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              isScrolling 
                  ? (isPaused ? Colors.orange : Colors.green)
                  : Colors.purple,
              isScrolling
                  ? (isPaused ? Colors.deepOrange : Colors.lightGreen)
                  : Colors.pink,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: IconButton(
                icon: Icon(
                  isScrolling
                      ? (isPaused ? Icons.play_arrow : Icons.pause)
                      : Icons.touch_app,
                  size: 36,
                  color: Colors.white,
                ),
                onPressed: onTap,
              ),
            ),
            if (isScrolling)
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: onStop,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}