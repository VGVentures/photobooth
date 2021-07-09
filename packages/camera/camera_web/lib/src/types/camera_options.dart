import 'package:flutter/foundation.dart';

/// Options used to create a camera with the given
/// [audio] and [video] constraints.
///
/// These options represent web `MediaStreamConstraints`
/// and can be used to request the browser for media streams
/// with tracks the requested types of media.
///
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamConstraints
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

enum CameraType {
  /// The camera is facing away from the user, viewing their environment.
  /// This includes the back camera on a smartphone.
  environment,

  /// The video source is facing toward the user.
  /// This includes the front camera on a smartphone.
  user
}

/// Specifies a constraint of a property value.
enum Constraint {
  /// Used to specify a value that the property must have
  /// to be considered acceptable.
  exact,

  /// Used to specify a value the property would ideally have,
  /// but which can be considered optional.
  ideal
}

/// Indicates the direction in which the desired camera should be pointing.
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

/// Indicates whether the audio track is requested.
class AudioConstraints {
  const AudioConstraints({this.enabled = false});

  final bool enabled;

  Object toJson() => enabled;
}

/// Indicates whether the video track is requested.
/// Includes optional constraints that the video track must have.
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

/// The size of the requested video track used in
/// [VideoConstraints.width] and [VideoConstraints.height].
///
/// The obtained camera will have a size between [minimum] and [maximum]
/// with ideally a size of [ideal]. The size is determined by
/// the capabilities of the hardware and the other specified constraints.
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
