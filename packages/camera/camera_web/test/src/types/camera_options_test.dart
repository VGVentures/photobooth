// ignore_for_file: prefer_const_constructors

@TestOn('chrome')

import 'package:camera_web/src/types/camera_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CameraOptions', () {
    test('serializes correctly', () async {
      final cameraOptions = CameraOptions(
        audio: AudioConstraints(enabled: true),
        video: VideoConstraints(
          facingMode: FacingModeConstraint.exact(CameraType.user),
        ),
      );

      expect(
        cameraOptions.toJson(),
        equals({
          'audio': cameraOptions.audio.toJson(),
          'video': cameraOptions.video.toJson(),
        }),
      );
    });
  });

  group('FacingModeConstraint', () {
    group('ideal', () {
      test(
          'serializes correctly '
          'for environment camera type', () {
        expect(
          FacingModeConstraint(
            CameraType.environment,
          ).toJson(),
          equals({'ideal': 'environment'}),
        );
      });

      test(
          'serializes correctly '
          'for user camera type', () {
        expect(
          FacingModeConstraint(
            CameraType.user,
          ).toJson(),
          equals({'ideal': 'user'}),
        );
      });
    });

    group('exact', () {
      test(
          'serializes correctly '
          'for environment camera type', () {
        expect(
          FacingModeConstraint.exact(
            CameraType.environment,
          ).toJson(),
          equals({'exact': 'environment'}),
        );
      });

      test(
          'serializes correctly '
          'for user camera type', () {
        expect(
          FacingModeConstraint.exact(
            CameraType.user,
          ).toJson(),
          equals({'exact': 'user'}),
        );
      });
    });
  });

  group('AudioConstraints', () {
    test('serializes correctly', () {
      expect(
        AudioConstraints(enabled: true).toJson(),
        equals(true),
      );
    });
  });

  group('VideoConstraints', () {
    test('serializes correctly', () async {
      final videoConstraints = VideoConstraints(
        facingMode: FacingModeConstraint.exact(CameraType.user),
        width: VideoSizeConstraint(ideal: 100, maximum: 100),
        height: VideoSizeConstraint(ideal: 50, maximum: 50),
        deviceId: 'deviceId',
      );

      expect(
        videoConstraints.toJson(),
        equals({
          'facingMode': videoConstraints.facingMode!.toJson(),
          'width': videoConstraints.width!.toJson(),
          'height': videoConstraints.height!.toJson(),
          'deviceId': 'deviceId',
        }),
      );
    });

    group('VideoSizeConstraint ', () {
      test('serializes correctly', () {
        expect(
          VideoSizeConstraint(
            ideal: 400,
            minimum: 200,
            maximum: 400,
          ).toJson(),
          equals({
            'ideal': 400,
            'min': 200,
            'max': 400,
          }),
        );
      });
    });
  });
}
