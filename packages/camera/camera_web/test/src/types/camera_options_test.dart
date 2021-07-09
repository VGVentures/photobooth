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
          facingMode: FacingMode(
            constraint: Constraint.exact,
            type: CameraType.user,
          ),
        ),
      );

      expect(
        await cameraOptions.toJson(),
        equals({
          'audio': cameraOptions.audio.toJson(),
          'video': await cameraOptions.video.toJson(),
        }),
      );
    });
  });

  group('FacingMode', () {
    test(
        'serializes correctly '
        'when constraint and type are given', () {
      expect(
        FacingMode(
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
        FacingMode(
          type: CameraType.user,
        ).toJson(),
        equals('user'),
      );
    });

    test(
        'serializes to null '
        'when no property is given', () {
      expect(
        FacingMode().toJson(),
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
        await VideoConstraints(
          enabled: false,
          facingMode: FacingMode(constraint: Constraint.exact),
          width: VideoSize(ideal: 100, maximum: 100),
          height: VideoSize(ideal: 50, maximum: 50),
          deviceId: 'deviceId',
        ).toJson(),
        equals(false),
      );
    });

    test(
        'serializes correctly '
        'when enabled is true', () async {
      final videoConstraints = VideoConstraints(
        facingMode: FacingMode(
          constraint: Constraint.exact,
          type: CameraType.user,
        ),
        width: VideoSize(ideal: 100, maximum: 100),
        height: VideoSize(ideal: 50, maximum: 50),
        deviceId: 'deviceId',
      );

      expect(
        await videoConstraints.toJson(),
        equals({
          'facingMode': videoConstraints.facingMode!.toJson(),
          'width': videoConstraints.width!.toJson(),
          'height': videoConstraints.height!.toJson(),
          'deviceId': 'deviceId',
        }),
      );
    });

    group('VideoSize', () {
      test('serializes correctly', () {
        expect(
          VideoSize(
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
