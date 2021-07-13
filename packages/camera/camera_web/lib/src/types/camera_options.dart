/// Options used to create a camera with the given
/// [audio] and [video] media constraints.
///
/// These options represent web `MediaStreamConstraints`
/// and can be used to request the browser for media streams
/// with the requested types of media.
///
/// https://developer.mozilla.org/en-US/docs/Web/API/MediaStreamConstraints
class CameraOptions {
  /// Creates a new instance of [CameraOptions]
  /// with the given [audio] and [video] constraints.
  const CameraOptions({
    AudioConstraints? audio,
    VideoConstraints? video,
  })  : audio = audio ?? const AudioConstraints(),
        video = video ?? const VideoConstraints();

  final AudioConstraints audio;
  final VideoConstraints video;

  Map<String, dynamic> toJson() {
    return {
      'audio': audio.toJson(),
      'video': video.toJson(),
    };
  }
}

/// The camera type used in [FacingModeConstraint].
///
/// Specifies whether the requested camera should be facing away
/// or toward the user.
class CameraType {
  const CameraType._(this._type);

  final String _type;

  @override
  String toString() => _type;

  /// The camera is facing away from the user, viewing their environment.
  /// This includes the back camera on a smartphone.
  static const CameraType environment = CameraType._('environment');

  /// The camera is facing toward the user.
  /// This includes the front camera on a smartphone.
  static const CameraType user = CameraType._('user');
}

/// Indicates the direction in which the desired camera should be pointing.
class FacingModeConstraint {
  /// Creates a new instance of [FacingModeConstraint]
  /// with the given [ideal] and [exact] constraints.
  const FacingModeConstraint._({this.ideal, this.exact});

  /// Creates a new instance of [FacingModeConstraint]
  /// with [ideal] constraint set to [type].
  ///
  /// If this constraint is used, then the camera would ideally have
  /// the desired facing [type] but it may be considered optional.
  factory FacingModeConstraint(CameraType type) =>
      FacingModeConstraint._(ideal: type);

  /// Creates a new instance of [FacingModeConstraint]
  /// with [exact] constraint set to [type].
  ///
  /// If this constraint is used, then the camera must have
  /// the desired facing [type] to be considered acceptable.
  factory FacingModeConstraint.exact(CameraType type) =>
      FacingModeConstraint._(exact: type);

  final CameraType? ideal;
  final CameraType? exact;

  Object? toJson() {
    return {
      if (ideal != null) 'ideal': ideal.toString(),
      if (exact != null) 'exact': exact.toString(),
    };
  }
}

/// Indicates whether the audio track is requested.
///
/// By default, the audio track is not requested.
class AudioConstraints {
  /// Creates a new instance of [AudioConstraints]
  /// with the given [enabled] constraint
  /// indicating whether the audio track is requested.
  const AudioConstraints({this.enabled = false});

  final bool enabled;

  Object toJson() => enabled;
}

/// Defines constraints that the video track must have
/// to be considered acceptable.
class VideoConstraints {
  /// Creates a new instance of [VideoConstraints]
  /// with the given constraints.
  const VideoConstraints({
    this.facingMode,
    this.width,
    this.height,
    this.deviceId,
  });

  final FacingModeConstraint? facingMode;
  final VideoSizeConstraint? width;
  final VideoSizeConstraint? height;
  final String? deviceId;

  Object toJson() {
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
class VideoSizeConstraint {
  /// Creates a new instance of [VideoSizeConstraint] with the given
  /// [minimum], [ideal] and [maximum] constraints.
  const VideoSizeConstraint({this.minimum, this.ideal, this.maximum});

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
