import 'dart:html';

import 'package:mocktail/mocktail.dart';

class MockWindow extends Mock implements Window {}

class MockNavigator extends Mock implements Navigator {}

class MockMediaDevices extends Mock implements MediaDevices {}

class FakeMediaStreamTrack extends Fake implements MediaStreamTrack {}

/// A fake [DomException] that returns the provided [errorName].
class FakeDomException extends Fake implements DomException {
  FakeDomException(this.errorName);

  final String errorName;

  @override
  String get name => errorName;
}
