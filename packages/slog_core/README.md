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

## Motivation

Yes I know there are a lot of logger out there I'm not saying mine is better, I'm saying that it has functionality I
want in a logger, like having multiple printers and allow for interceptors like what [dio](https://pub.dev/packages/dio)
or [chopper](https://pub.dev/packages/chopper) has why should it be exclusive to HTTP clients?

## TODO

- [x] Interceptors: see [slog_basic][slog_basic_repo]
- [x] Printers: see [slog_basic][slog_basic_repo]
- [ ] Filters
- [ ] UI package for flutter
- [ ] Local server

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
