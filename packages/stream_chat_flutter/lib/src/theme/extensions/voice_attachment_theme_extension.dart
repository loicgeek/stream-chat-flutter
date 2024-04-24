import 'package:flutter/material.dart';

class PlayerWaveformTheme extends ThemeExtension<PlayerWaveformTheme> {
  /// Creates a new instance of the theme data
  PlayerWaveformTheme({
    this.waveColorPlayed,
    this.waveColorUnplayed,
  });

  /// Color of the waves that have been played.
  final Color? waveColorPlayed;

  /// Color of the waves that have not been played yet.
  final Color? waveColorUnplayed;

  @override
  PlayerWaveformTheme copyWith({
    Color? waveColorPlayed,
    Color? waveColorUnplayed,
    Color? sliderButtonColor,
    Color? sliderButtonBorderColor,
    BorderRadius? sliderButtonBorderRadius,
    AudioLoadingTheme? audioLoading,
  }) {
    return PlayerWaveformTheme(
      waveColorPlayed: waveColorPlayed ?? this.waveColorPlayed,
      waveColorUnplayed: waveColorUnplayed ?? this.waveColorUnplayed,
    );
  }

  @override
  ThemeExtension<PlayerWaveformTheme> lerp(
    covariant ThemeExtension<PlayerWaveformTheme>? other,
    double t,
  ) {
    if (other is! PlayerWaveformTheme) {
      return this;
    }
    return PlayerWaveformTheme(
      waveColorPlayed: Color.lerp(waveColorPlayed, other.waveColorPlayed, t),
      waveColorUnplayed:
          Color.lerp(waveColorUnplayed, other.waveColorUnplayed, t),
    );
  }
}

class AudioLoadingTheme extends ThemeExtension<AudioLoadingTheme> {
  const AudioLoadingTheme({
    this.size,
    this.strokeWidth,
    this.color,
  });

  final Size? size;
  final double? strokeWidth;
  final Color? color;

  @override
  AudioLoadingTheme copyWith({
    Size? size,
    double? strokeWidth,
    Color? color,
  }) {
    return AudioLoadingTheme(
      size: size ?? this.size,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
    );
  }

  @override
  AudioLoadingTheme lerp(AudioLoadingTheme other, double t) {
    return AudioLoadingTheme(
      size: Size.lerp(size, other.size, t),
      strokeWidth: lerpDouble(strokeWidth, other.strokeWidth, t),
      color: Color.lerp(color, other.color, t),
    );
  }
}

class SliderTheme extends ThemeExtension<SliderTheme> {
  const SliderTheme({
    this.sliderButtonColor,
    this.sliderButtonBorderColor,
    this.sliderButtonBorderRadius,
  });

  final Color? sliderButtonColor;
  final Color? sliderButtonBorderColor;
  final BorderRadius? sliderButtonBorderRadius;

  @override
  SliderTheme copyWith({
    Color? sliderButtonColor,
    Color? sliderButtonBorderColor,
    BorderRadius? sliderButtonBorderRadius,
  }) {
    return SliderTheme(
      sliderButtonColor: sliderButtonColor ?? this.sliderButtonColor,
      sliderButtonBorderColor:
          sliderButtonBorderColor ?? this.sliderButtonBorderColor,
      sliderButtonBorderRadius:
          sliderButtonBorderRadius ?? this.sliderButtonBorderRadius,
    );
  }

  @override
  SliderTheme lerp(SliderTheme other, double t) {
    return SliderTheme(
      sliderButtonColor: Color.lerp(sliderButtonColor, other.sliderButtonColor, t),
      sliderButtonBorderColor: Color.lerp(sliderButtonBorderColor, other.sliderButtonBorderColor, t),
      sliderButtonBorderRadius: BorderRadius.lerp(sliderButtonBorderRadius, other.sliderButtonBorderRadius, t),
    );
  }
}