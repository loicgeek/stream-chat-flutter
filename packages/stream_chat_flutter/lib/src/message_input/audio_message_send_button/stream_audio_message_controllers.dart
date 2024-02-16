import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget that displays the audio recording controls.
class StreamAudioMessageControllers extends StatefulWidget {
  /// Creates a new StreamAudioMessageControllers
  const StreamAudioMessageControllers({super.key});

  @override
  State<StreamAudioMessageControllers> createState() =>
      _StreamAudioMessageControllersState();
}

class _StreamAudioMessageControllersState
    extends State<StreamAudioMessageControllers> with TickerProviderStateMixin {
  Color? iconColor;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    

    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (mounted) {
          setState(() {
            iconColor =
                audioRecordingMessageTheme.recordingIndicatorColorActive;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _recordingController = context.watch<StreamRecordingController>();

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeIn,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          StreamSvgIcon.iconMic(
            color: iconColor,
            size: 24,
          ),
          if (_recordingController.isRecording) ...[
            const SizedBox(width: 8),
            const _Timer(),
          ] else
            const SizedBox(width: 58),
          const Expanded(
            child: _CancelRecordingPanel(
              key: ValueKey('cancelRecordingPanel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Timer extends StatelessWidget {
  const _Timer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);
    final recordingController = context.watch<StreamRecordingController>();

    var duration = '0:00';
    if (recordingController.isRecording) {
      final recordingDuration = recordingController.duration;
      duration =
          '${recordingDuration.inMinutes}:${recordingDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    }

    return SizedBox(
      width: 50,
      child: Text(
        duration,
        style: TextStyle(
          fontSize: 16,
          color: audioRecordingMessageTheme.recordingIndicatorColorIdle,
        ),
      ),
    );
  }
}

class _CancelRecordingPanel extends StatefulWidget {
  const _CancelRecordingPanel({super.key});

  @override
  State<_CancelRecordingPanel> createState() => _CancelRecordingPanelState();
}

class _CancelRecordingPanelState extends State<_CancelRecordingPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioRecordingMessageTheme = AudioRecordingMessageTheme.of(context);

    final state = GestureStateProvider.maybeOf(context);
    final offset = state?.offset;
    final width = MediaQuery.of(context).size.width / 3;
    final opacity = offset != null ? 1 - (offset.dx.abs() / width) : 1.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: offset != null ? Offset(offset.dx, 0) : Offset.zero,
          child: Opacity(
            opacity: max(min(opacity, 1), 0),
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Slide to cancel',
            style: TextStyle(
              fontSize: 16,
              color: audioRecordingMessageTheme.cancelTextColor,
            ),
          ),
          StreamSvgIcon.left(
            size: 24,
            color: audioRecordingMessageTheme.cancelTextColor,
          ),
        ],
      ),
    );
  }
}
