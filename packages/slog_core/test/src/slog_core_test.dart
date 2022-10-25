// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:mocktail/mocktail.dart';
import 'package:slog_core/logger.dart';
// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';

class MockInterceptor extends Mock implements SLogInterceptor {}

void main() {
  group('Core', () {
    test('can be instantiated', () {
      expect(Logger.init(), isNotNull);
    });
    test('can be called', () {
      expect(Logger.I, isNotNull);
    });
    test('can create separate instance', () {
      expect(
        Logger(
              options: SLogOptions(
                interceptors: [
                  MockInterceptor(),
                ],
              ),
            ).hashCode !=
            Logger.I.hashCode,
        true,
      );
    });
  });
}
