# SLog Core

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

This is the core package, but it does contain a base logger which you don't need to use, create your own that's the
point of having the core package.

## Features

- Base Logger
- Printers
- Interceptors
- Channels
- Logger [isolate](https://dart.dev/guides/language/concurrency)

## Installation

### Added it directly

Add `slog_core` to your `pubspec.yaml`:

```yaml
dependencies:
  slog_core:
```

Install it:

```sh
dart pub get
```

```sh
flutter pub get
```

### Install from terminal

```sh
dart pub add slog_core
```

```sh
flutter pub add slog_core
```

## Basic Logger

The basic logger is globally available and uses the singleton pattern. You can create your on instance non-singleton
instance just call the constructor for `Logger`.

```dart
import 'package:slog_core/logger.dart';

main() {
  //You can initialize the Basic Logger if you want,
  //but by default it is already initialized with no options.
  //It is recommended to init the logger with at least one printer as there is no printer by default.
  Logger.init();
  //or
  Logger.init(
    options: SLogOptions(
      printers: [
        SomePrinter(), //not a real printer, see slog_basic for per-made printers
      ],
    ),
  );

  Logger.I.log('Hello world');
  //or
  Logger.instance.log('Hello world');
}
```

## Some notes

### Errors

If the logger, printers or interceptors throw an error the SLogger will try to not bubble them up to the main thread.

Like if a `jsonEncode` or `jsonDecode` throw an error inside a printer, the logger will catch the error and print a
message to dart log.

### Loggers

Because this package was built with customization in mind. You can add your own `Levels`, create a new logger by
extending the `SLogger`, it is recommended that you create your own interceptors and printers as we can't guess your use
case.

## Motivation

Yes I know there are a lot of logger out there I'm not saying mine is better, I'm saying that it has functionality I
want in a logger, like having multiple printers and allow for interceptors like what [dio](https://pub.dev/packages/dio)
or [chopper](https://pub.dev/packages/chopper) has. Why should it be exclusive to HTTP clients?

## TODO

- ✓ Interceptors: see [slog_basic][slog_basic_repo]
- ✓ Printers: see [slog_basic][slog_basic_repo]
- Filters
- UI package for flutter
- Local server package

[slog_basic_repo]: https://github.com/SeanfvdM/slog/tree/main/packages/slog_basic

[dart_install_link]: https://dart.dev/get-dart

[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg

[license_link]: https://opensource.org/licenses/MIT

[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only

[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only

[mason_link]: https://github.com/felangel/mason

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg

[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage

[very_good_ventures_link]: https://verygood.ventures

[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only

[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only

[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
