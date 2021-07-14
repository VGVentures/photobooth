// ignore_for_file: prefer_const_constructors

@TestOn('chrome')

import 'dart:html';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera_web/src/camera.dart';
import 'package:camera_web/src/types/camera_error_codes.dart';
import 'package:camera_web/src/types/camera_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

void main() {
  group('Camera', () {
    late Window window;
    late Navigator navigator;
    late MediaStream mediaStream;
    late MediaDevices mediaDevices;

    setUp(() {
      window = MockWindow();
      navigator = MockNavigator();
      mediaDevices = MockMediaDevices();

      final videoElement = VideoElement()
        ..src =
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
        ..preload = 'true'
        ..width = 10
        ..height = 10;

      mediaStream = videoElement.captureStream();

      when(() => window.navigator).thenReturn(navigator);
      when(() => navigator.mediaDevices).thenReturn(mediaDevices);
      when(
        () => mediaDevices.getUserMedia(any()),
      ).thenAnswer((_) async => mediaStream);
    });

    group('initialize', () {
      test(
          'creates a video element '
          'with correct properties', () async {
        const audioConstraints = AudioConstraints(enabled: true);

        final camera = Camera(
          textureId: 1,
          options: CameraOptions(
            audio: audioConstraints,
          ),
          window: window,
        );

        await camera.initialize();

        expect(camera.videoElement, isNotNull);
        expect(camera.videoElement.autoplay, isFalse);
        expect(camera.videoElement.muted, !audioConstraints.enabled);
        expect(camera.videoElement.srcObject, mediaStream);
        expect(camera.videoElement.attributes.keys, contains('playsinline'));

        expect(camera.videoElement.style.transformOrigin, isEmpty);
        expect(camera.videoElement.style.pointerEvents, equals('none'));
        expect(camera.videoElement.style.width, equals('100%'));
        expect(camera.videoElement.style.height, equals('100%'));
        expect(camera.videoElement.style.objectFit, equals('cover'));
        expect(camera.videoElement.style.transform, equals('scaleX(-1)'));
      });

      test(
          'creates a wrapping div element '
          'with correct properties', () async {
        final camera = Camera(
          textureId: 1,
          window: window,
        );

        await camera.initialize();

        expect(camera.divElement, isNotNull);
        expect(camera.divElement.style.objectFit, equals('cover'));
        expect(camera.divElement.children, contains(camera.videoElement));
      });

      test('calls getUserMedia with provided options', () async {
        const options = CameraOptions(
          video: VideoConstraints(enabled: false),
        );

        final optionsJson = await options.toJson();

        final camera = Camera(
          textureId: 1,
          options: options,
          window: window,
        );

        await camera.initialize();

        verify(() => mediaDevices.getUserMedia(optionsJson)).called(1);
      });

      group('throws CameraException', () {
        test(
            'containing notSupported error '
            'when there are no media devices', () {
          when(() => navigator.mediaDevices).thenReturn(null);

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.notSupported,
              ),
            ),
          );
        });

        test(
            'containing notFound error '
            'when getUserMedia throws DomException '
            'with NotFoundError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('NotFoundError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.notFound,
              ),
            ),
          );
        });

        test(
            'containing notFound error '
            'when getUserMedia throws DomException '
            'with DevicesNotFoundError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('DevicesNotFoundError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.notFound,
              ),
            ),
          );
        });

        test(
            'containing notReadable error '
            'when getUserMedia throws DomException '
            'with NotReadableError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('NotReadableError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.notReadable,
              ),
            ),
          );
        });

        test(
            'containing notReadable error '
            'when getUserMedia throws DomException '
            'with TrackStartError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('TrackStartError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.notReadable,
              ),
            ),
          );
        });

        test(
            'containing overconstrained error '
            'when getUserMedia throws DomException '
            'with OverconstrainedError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('OverconstrainedError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.overconstrained,
              ),
            ),
          );
        });

        test(
            'containing overconstrained error '
            'when getUserMedia throws DomException '
            'with ConstraintNotSatisfiedError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('ConstraintNotSatisfiedError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.overconstrained,
              ),
            ),
          );
        });

        test(
            'containing permissionDenied error '
            'when getUserMedia throws DomException '
            'with NotAllowedError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('NotAllowedError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.permissionDenied,
              ),
            ),
          );
        });

        test(
            'containing permissionDenied error '
            'when getUserMedia throws DomException '
            'with PermissionDeniedError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('PermissionDeniedError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.permissionDenied,
              ),
            ),
          );
        });

        test(
            'containing type error '
            'when getUserMedia throws DomException '
            'with TypeError', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('TypeError'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.type,
              ),
            ),
          );
        });

        test(
            'containing unknown error '
            'when getUserMedia throws DomException '
            'with an unknown error', () {
          when(() => mediaDevices.getUserMedia(any()))
              .thenThrow(FakeDomException('Unknown'));

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.unknown,
              ),
            ),
          );
        });

        test(
            'containing unknown error '
            'when getUserMedia throws an unknown exception', () {
          when(() => mediaDevices.getUserMedia(any())).thenThrow(Exception());

          final camera = Camera(
            textureId: 1,
            window: window,
          );

          expect(
            camera.initialize,
            throwsA(
              isA<CameraException>().having(
                (e) => e.code,
                'code',
                CameraErrorCodes.unknown,
              ),
            ),
          );
        });
      });
    });

    group('play', () {
      test('starts playing the video element', () async {
        var startedPlaying = false;

        final camera = Camera(
          textureId: 1,
          window: window,
        );

        await camera.initialize();

        camera.videoElement.onPlay.listen((event) => startedPlaying = true);

        await camera.play();

        expect(startedPlaying, isTrue);
      });

      test(
          'assigns media stream to the video element\'s source '
          'if it does not exist', () async {
        final camera = Camera(
          textureId: 1,
          window: window,
        );

        await camera.initialize();

        /// Remove the video element's source
        /// by stopping the camera.
        // ignore: cascade_invocations
        camera.stop();

        await camera.play();

        expect(camera.videoElement.srcObject, mediaStream);
      });
    });

    group('stop', () {
      test('resets the video element\'s source', () async {
        final camera = Camera(
          textureId: 1,
          window: window,
        );

        await camera.initialize();
        await camera.play();

        camera.stop();

        expect(camera.videoElement.srcObject, isNull);
      });
    });

    group('takePicture', () {
      test('returns a captured picture', () async {
        final camera = Camera(
          textureId: 1,
          window: window,
        );

        await camera.initialize();
        await camera.play();

        final pictureFile = await camera.takePicture();

        expect(pictureFile, isNotNull);
      });
    });

    group('dispose', () {
      test('resets the video element\'s source', () async {
        final camera = Camera(
          textureId: 1,
          window: window,
        );

        await camera.initialize();

        camera.dispose();

        expect(camera.videoElement.srcObject, isNull);
      });
    });
  });
}
