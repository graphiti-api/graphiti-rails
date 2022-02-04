# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.4.0] - 2022-02-03
- `rescue_registry` has been updated to 0.4.0 for Ruby 3.1 support.

## [0.3.0] - 2021-05-11
### Changed
- `rescue_registry` has been updated to 0.3.0. This causes some changes to error payloads.
  [CHANGELOG](https://github.com/wagenet/rescue_registry/blob/master/CHANGELOG.md#030---2021-05-11)

## [0.2.4] - 2020-08-10
### Changed
- The `rails` dependency has been replaced with `railties`. - #60

## [0.2.3] - 2019-10-31
### Added
- Add option to use rawid in generated tests

## [0.2.2] - 2019-10-26
### Fixed
- Let user disable the logger

## [0.2.1] - 2019-06-13
### Added
- Include `__raw_errors__` in detailed error payloads for use by Vandal and Request Responses

### Fixed
- Do not depend on ActiveRecord for route generators

## [0.2.0] - 2019-05-27

Initial release
