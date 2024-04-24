import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'voice_recording_attachment_builder.dart';

/// {@template AudioListPlayer}
/// Display many audios and displays a list of AudioPlayerMessage.
/// {@endtemplate}
class AudioListPlayer extends StatefulWidget {
  /// {@macro AudioListPlayer}
  const AudioListPlayer({
    super.key,
    required this.attachments,
    this.attachmentBorderRadiusGeometry,
    this.constraints,
  });

  /// List of audio attachments.
  final List<Attachment> attachments;

  /// The border radius of each audio.
  final BorderRadiusGeometry? attachmentBorderRadiusGeometry;

  /// Constraints of audio attachments
  final BoxConstraints? constraints;

  @override
  State<AudioListPlayer> createState() => _AudioListPlayerState();
}

class _AudioListPlayerState extends State<AudioListPlayer> {
  final _player = AudioPlayer();
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  Duration _resolveDuration(Attachment attachment) {
    final duration = attachment.extraData['duration'] as double?;
    if (duration == null) {
      return Duration.zero;
    }

    return Duration(milliseconds: duration.round() * 1000);
  }

  List<double> _resolveWaveform(Attachment attachment) {
    final waveform =
        attachment.extraData['waveform_data'] as List<dynamic>? ?? <dynamic>[];
    return waveform
        .map((e) => double.tryParse(e.toString()))
        .whereNotNull()
        .toList();
  }

  Widget _createAudioPlayer(int index, Attachment attachment) {
    final url = attachment.assetUrl;
    Widget playerMessage;

    final theme = Theme.of(context).extension<VoiceAttachmentThemeExtension>();

    if (url == null) {
      playerMessage =
          theme.audioLoadingIndicator ?? const AudioLoadingMessage();
    } else {
      final duration = _resolveDuration(attachment);
      final waveform = _resolveWaveform(attachment);

      playerMessage = AudioPlayerMessage(
        player: _player,
        duration: duration,
        waveBars: waveform,
        index: index,
      );
    }

    final colorTheme = StreamChatTheme.of(context).colorTheme;

    return Container(
      margin: const EdgeInsets.all(2),
      constraints: widget.constraints,
      decoration: BoxDecoration(
        color: colorTheme.barsBg,
        border: Border.all(
          color: colorTheme.borders,
        ),
        borderRadius:
            widget.attachmentBorderRadiusGeometry ?? BorderRadius.circular(10),
      ),
      child: playerMessage,
    );
  }

  void _playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await _player.stop();
      await _player.seek(Duration.zero, index: 0);
    }
  }

  @override
  void initState() {
    super.initState();

    _playerStateChangedSubscription =
        _player.playerStateStream.listen(_playerStateListener);
  }

  @override
  void dispose() {
    super.dispose();

    _playerStateChangedSubscription.cancel();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playList = widget.attachments
        .where((attachment) => attachment.assetUrl != null)
        .map((attachment) => AudioSource.uri(Uri.parse(attachment.assetUrl!)))
        .toList();

    final audioSource = ConcatenatingAudioSource(children: playList);

    _player
      ..setShuffleModeEnabled(false)
      ..setLoopMode(LoopMode.off)
      ..setAudioSource(audioSource, preload: false);

    return Column(
      children: widget.attachments.mapIndexed(_createAudioPlayer).toList(),
    );
  }
}
