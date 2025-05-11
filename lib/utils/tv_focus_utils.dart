import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TVFocusScope extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;

  const TVFocusScope({
    Key? key,
    required this.child,
    required this.focusNode,
  }) : super(key: key);

  @override
  _TVFocusScopeState createState() => _TVFocusScopeState();
}

class _TVFocusScopeState extends State<TVFocusScope> {
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      child: RawKeyboardListener(
        focusNode: widget.focusNode,
        onKey: _handleKeyEvent,
        child: widget.child,
      ),
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      
      if (key == LogicalKeyboardKey.select) {
        _handleSelect();
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        _handleArrowKey(TraversalDirection.left);
      } else if (key == LogicalKeyboardKey.arrowRight) {
        _handleArrowKey(TraversalDirection.right);
      } else if (key == LogicalKeyboardKey.arrowUp) {
        _handleArrowKey(TraversalDirection.up);
      } else if (key == LogicalKeyboardKey.arrowDown) {
        _handleArrowKey(TraversalDirection.down);
      } else if (key == LogicalKeyboardKey.escape ||
               key == LogicalKeyboardKey.goBack) {
        Navigator.of(context).maybePop();
      }
    }
  }

  void _handleSelect() {
    final primaryContext = primaryFocus?.context;
    if (primaryContext != null) {
      // Handle selection
    }
  }

  void _handleArrowKey(TraversalDirection direction) {
    final result = Focus.of(context).focusInDirection(direction);
    // Handle navigation result if needed
  }
}
