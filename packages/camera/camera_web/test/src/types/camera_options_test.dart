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
          facingMode: FacingModeConstraint(
            constraint: Constraint.exact,
            type: CameraType.user,
          ),
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
    test(
        'serializes correctly '
        'when constraint and type are given', () {
      expect(
        FacingModeConstraint(
          constraint: Constraint.ideal,
          type: CameraType.environment,
        ).toJson(),
        equals({'ideal': 'environment'}),
      );
    });

    test(
        'serializes correctly '
        'when only type is given', () {
      expect(
        FacingModeConstraint(
          type: CameraType.user,
        ).toJson(),
        equals('user'),
      );
    });

    test(
        'serializes to null '
        'when no property is given', () {
      expect(
        FacingModeConstraint().toJson(),
        equals(null),
      );
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
    test(
        'serializes correctly '
        'when enabled is false', () async {
      expect(
        VideoConstraints(
          enabled: false,
          facingMode: FacingModeConstraint(constraint: Constraint.exact),
          width: VideoSizeConstraint(ideal: 100, maximum: 100),
          height: VideoSizeConstraint(ideal: 50, maximum: 50),
          deviceId: 'deviceId',
        ).toJson(),
        equals(false),
      );
    });

    test(
        'serializes correctly '
        'when enabled is true', () async {
      final videoConstraints = VideoConstraints(
        facingMode: FacingModeConstraint(
          constraint: Constraint.exact,
          type: CameraType.user,
        ),
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

    group('VideoSizeConstraint', () {
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
