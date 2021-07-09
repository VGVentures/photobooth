import 'package:flutter/foundation.dart';

class CameraOptions {
  const CameraOptions({
    AudioConstraints? audio,
    VideoConstraints? video,
  })  : audio = audio ?? const AudioConstraints(),
        video = video ?? const VideoConstraints();

  final AudioConstraints audio;
  final VideoConstraints video;

  Future<Map<String, dynamic>> toJson() async {
    final videoConstraints = await video.toJson();
    return {
      'audio': audio.toJson(),
      'video': videoConstraints,
    };
  }
}

enum CameraType { rear, user }
enum Constraint { exact, ideal }

class FacingMode {
  const FacingMode({this.constraint, this.type});
  final Constraint? constraint;
  final CameraType? type;

  Object? toJson() {
    if (constraint == null) {
      return type != null ? describeEnum(type!) : null;
    }
    return {
      describeEnum(constraint!): describeEnum(type!),
    };
  }
}

class AudioConstraints {
  const AudioConstraints({this.enabled = false});
  final bool enabled;

  Object toJson() => enabled;
}

class VideoConstraints {
  const VideoConstraints({
    this.enabled = true,
    this.facingMode,
    this.width,
    this.height,
    this.deviceId,
  });

  final bool enabled;
  final FacingMode? facingMode;
  final VideoSize? width;
  final VideoSize? height;
  final String? deviceId;

  Future<Object> toJson() async {
    if (!enabled) return false;
    final json = <String, dynamic>{};

    if (width != null) json['width'] = width!.toJson();
    if (height != null) json['height'] = height!.toJson();
    if (facingMode != null) json['facingMode'] = facingMode!.toJson();
    if (deviceId != null) json['deviceId'] = deviceId!;

    return json;
  }
}

class VideoSize {
  const VideoSize({this.minimum, this.ideal, this.maximum});
  final int? minimum;
  final int? ideal;
  final int? maximum;

  Object toJson() {
    final json = <String, dynamic>{};

    if (ideal != null) json['ideal'] = ideal;
    if (minimum != null) json['min'] = minimum;
    if (maximum != null) json['max'] = maximum;
    return json;
  }
}
