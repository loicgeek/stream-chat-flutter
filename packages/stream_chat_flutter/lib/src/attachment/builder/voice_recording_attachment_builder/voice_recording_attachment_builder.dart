export 'audio_list_player.dart';
export 'audio_loading_message.dart';
export 'audio_player_compose_message.dart';
export 'audio_player_message.dart';
export 'audio_wave_slider.dart';

part of '../attachment_widget_builder.dart';


class VoiceRecordingAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) {
    final recordings = attachments[AttachmentType.voiceRecording];
    if (recordings != null && recordings.length == 1) return true;

    return false;
  }

  @override
  Widget build(BuildContext context, Message message,
      Map<String, List<Attachment>> attachments) {
    final recordings = attachments[AttachmentType.voiceRecording]!;

    return AudioListPlayer(
      attachments: recordings,
      attachmentBorderRadiusGeometry: BorderRadius.circular(16),
      constraints: const BoxConstraints.tightFor(width: 400),
    );
  }
}
