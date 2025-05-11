import 'package:flutter/material.dart';

class FocusableCard extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final double scale;
  
  const FocusableCard({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.scale = 1.05,
  }) : super(key: key);

  @override
  _FocusableCardState createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: const EdgeInsets.all(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            transform: _isFocused
                ? Matrix4.identity()..scale(widget.scale)
                : Matrix4.identity(),
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
