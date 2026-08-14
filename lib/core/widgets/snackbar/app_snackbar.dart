import 'package:flutter/material.dart';

enum SnackType {
  success,
  error,
  warning,
  natural,
}

class AppSnackbar {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context,
    String message,
    SnackType type, {
    bool showIcon = true,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;

      case SnackType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;

      case SnackType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;

      case SnackType.natural:
        backgroundColor = Colors.grey;
        icon = Icons.circle;
        break;
    }

    // Remove previous snackbar if one is already visible.
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return _AppSnackbarOverlay(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          showIcon: showIcon,
          onDismiss: () {
            if (entry.mounted) {
              entry.remove();
            }

            if (_currentEntry == entry) {
              _currentEntry = null;
            }
          },
        );
      },
    );

    _currentEntry = entry;

    overlay.insert(entry);

    // Automatically remove after 3 seconds.
    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) {
        entry.remove();
      }

      if (_currentEntry == entry) {
        _currentEntry = null;
      }
    });
  }
}

class _AppSnackbarOverlay extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final bool showIcon;
  final VoidCallback onDismiss;

  const _AppSnackbarOverlay({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.showIcon,
    required this.onDismiss,
  });

  @override
  State<_AppSnackbarOverlay> createState() =>
      _AppSnackbarOverlayState();
}

class _AppSnackbarOverlayState
    extends State<_AppSnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,

      // Put it above the bottom sheet.
      bottom: 30,

      child: SafeArea(
        child: FadeTransition(
          opacity: _animation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.backgroundColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (widget.showIcon) ...[
                      Icon(
                        widget.icon,
                        color: widget.backgroundColor,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: widget.backgroundColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}