// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:slog_basic/slog_basic.dart';
import 'package:slog_basic/src/printers.dart';
// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';

void main() {
  group('Basic Interceptors', () {
    test('Print Interceptor can be instantiated', () {
      expect(PrintInterceptor(), isNotNull);
    });
  });
  group('Basic Printers', () {
    test('Json Printer can be instantiated', () {
      expect(JsonPrinter(), isNotNull);
    });
  });
}
