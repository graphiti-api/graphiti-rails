graphiti-rails changelog

## [0.4.1](https://github.com/graphiti-api/graphiti-rails/compare/v0.4.0...v0.4.1) (2025-03-21)


### Bug Fixes

* `register_parameter_parser` overiding custom config ([#109](https://github.com/graphiti-api/graphiti-rails/issues/109)) ([a135bfa](https://github.com/graphiti-api/graphiti-rails/commit/a135bfa7729b921cf57563916567e272237b6b1f))
* Add basic column type conversion. ([#83](https://github.com/graphiti-api/graphiti-rails/issues/83)) ([e5bbc92](https://github.com/graphiti-api/graphiti-rails/commit/e5bbc92335376311f02af71d0db3ddc13bdd1ad9))
* Add condition to check RSpec availability in install generator ([#63](https://github.com/graphiti-api/graphiti-rails/issues/63)) ([13895d9](https://github.com/graphiti-api/graphiti-rails/commit/13895d98f8784f5552256840fd44caaa80c4717b))
* rspec double was leaking across tests ([#105](https://github.com/graphiti-api/graphiti-rails/issues/105)) ([b38faf2](https://github.com/graphiti-api/graphiti-rails/commit/b38faf2a02bd9e5e91e9014ca060092d7398b47d))
* Stringify path if Rails version > 7 ([#107](https://github.com/graphiti-api/graphiti-rails/issues/107)) ([47d356c](https://github.com/graphiti-api/graphiti-rails/commit/47d356c23c3d800e83236227a6684fc40af360af))

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
