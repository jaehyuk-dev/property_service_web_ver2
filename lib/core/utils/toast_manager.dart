import 'package:flutter/material.dart';

class ToastManager {
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  final List<OverlayEntry> _overlayEntries = [];
  OverlayState? _overlayState;

  void showToast(BuildContext context, String message) {
    _overlayState ??= Overlay.of(context);

    // OverlayEntry를 나중에 참조할 수 있도록 생성자 내부에서 초기화
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        int index = _overlayEntries.indexOf(overlayEntry);
        return Positioned(
          bottom: 50.0 + index * 70.0, // 우측 하단부터 위로 쌓이도록 위치 지정
          right: 20.0,
          child: Material(
            color: Colors.transparent,
            child: _ToastWidget(
              message: message,
              onClose: () {
                _removeToast(overlayEntry);
              },
            ),
          ),
        );
      },
    );

    _overlayEntries.add(overlayEntry);
    _overlayState?.insert(overlayEntry);

    // 3초 후 자동 제거
    Future.delayed(Duration(seconds: 3), () {
      _removeToast(overlayEntry);
    });
  }

  void _removeToast(OverlayEntry overlayEntry) {
    if (_overlayEntries.contains(overlayEntry)) {
      overlayEntry.remove();
      _overlayEntries.remove(overlayEntry);

      // 남은 메시지의 위치 재조정
      for (var entry in _overlayEntries) {
        entry.markNeedsBuild();
      }
    }
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 최소 크기로 축소
        children: [
          Flexible( // Flexible을 사용하여 Row 내에서 크기 계산 가능하도록 처리
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 16.0),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
