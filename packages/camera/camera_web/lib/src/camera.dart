import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/src/types/camera_error_codes.dart';
import 'package:camera_web/src/types/camera_options.dart';

String _getViewType(int cameraId) => 'plugins.flutter.io/camera_$cameraId';

/// A camera initialized from the media devices in the current [window].
/// The obtained camera is constrained by the [options] which are used
/// when querying the media input in [_getMediaStream].
///
/// The camera stream is displayed in the [videoElement] wrapped in the
/// [divElement] to avoid overriding the custom styles applied to
/// the video element in [_applyDefaultVideoStyles].
/// See https://github.com/flutter/flutter/issues/79519.
///
/// The camera can be played/stopped by calling [play]/[stop]
/// or may capture a picture by [takePicture].
///
/// The [textureId] is used to register a camera view factory with the id
/// returned by [_getViewType].
class Camera {
  Camera({
    required this.textureId,
    this.options = const CameraOptions(),
    html.Window? window,
  }) : window = window ?? html.window;

  late html.VideoElement videoElement;
  late html.DivElement divElement;
  final CameraOptions options;
  final int textureId;
  final html.Window window;

  Future<void> initialize() async {
    final isSupported = window.navigator.mediaDevices?.getUserMedia != null;
    if (!isSupported) {
      throw CameraException(
        CameraErrorCodes.notSupported,
        'The camera is not supported on this device.',
      );
    }

    videoElement = html.VideoElement();
    _applyDefaultVideoStyles(videoElement);

    divElement = html.DivElement()
      ..style.setProperty('object-fit', 'cover')
      ..append(videoElement);

    // ignore: avoid_dynamic_calls
    ui.platformViewRegistry.registerViewFactory(
      _getViewType(textureId),
      (_) => divElement,
    );

    final stream = await _getMediaStream();
    videoElement
      ..autoplay = false
      ..muted = !options.audio.enabled
      ..srcObject = stream
      ..setAttribute('playsinline', '');
  }

  Future<html.MediaStream> _getMediaStream() async {
    try {
      final constraints = await options.toJson();
      return await window.navigator.mediaDevices!.getUserMedia(constraints);
    } on html.DomException catch (e) {
      switch (e.name) {
        case 'NotFoundError':
        case 'DevicesNotFoundError':
          throw CameraException(
            CameraErrorCodes.notFound,
            'No camera found for the given camera options.',
          );
        case 'NotReadableError':
        case 'TrackStartError':
          throw CameraException(
            CameraErrorCodes.notReadable,
            'The camera is not readable due to a hardware error '
            'that prevented access to the device.',
          );
        case 'OverconstrainedError':
        case 'ConstraintNotSatisfiedError':
          throw CameraException(
            CameraErrorCodes.overconstrained,
            'Provided camera options are impossible to satisfy.',
          );
        case 'NotAllowedError':
        case 'PermissionDeniedError':
          throw CameraException(
            CameraErrorCodes.permissionDenied,
            'The camera cannot be used or the permission '
            'to access the camera is not granted.',
          );
        case 'TypeError':
          throw CameraException(
            CameraErrorCodes.type,
            'Provided camera options are incorrect.',
          );
        default:
          throw CameraException(
            CameraErrorCodes.unknown,
            'An unknown error occured when initializing the camera.',
          );
      }
    } catch (_) {
      throw CameraException(
        CameraErrorCodes.unknown,
        'An unknown error occured when initializing the camera.',
      );
    }
  }

  Future<void> play() async {
    if (videoElement.srcObject == null) {
      final stream = await _getMediaStream();
      videoElement.srcObject = stream;
    }
    await videoElement.play();
  }

  void stop() {
    final tracks = videoElement.srcObject?.getVideoTracks();
    if (tracks != null) {
      for (final track in tracks) {
        track.stop();
      }
    }
    videoElement.srcObject = null;
  }

  Future<XFile> takePicture() async {
    final videoWidth = videoElement.videoWidth;
    final videoHeight = videoElement.videoHeight;
    final canvas = html.CanvasElement(width: videoWidth, height: videoHeight);
    canvas.context2D
      ..translate(videoWidth, 0)
      ..scale(-1, 1)
      ..drawImageScaled(videoElement, 0, 0, videoWidth, videoHeight);
    final blob = await canvas.toBlob();
    return XFile(html.Url.createObjectUrl(blob));
  }

  void dispose() {
    stop();
    videoElement
      ..srcObject = null
      ..load();
  }

  void _applyDefaultVideoStyles(html.VideoElement element) {
    element.style
      ..transformOrigin = 'center'
      ..pointerEvents = 'none'
      ..width = '100%'
      ..height = '100%'
      ..objectFit = 'cover'
      ..transform = 'scaleX(-1)';
  }
}
