# Graphiti::Rails

Graphiti::Rails is a more robust Rails integration for Graphiti.

## Usage
TODO

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'graphiti-rails'
```

### Additional Setup
We also recommend that you set `config.debug_exception_response_format = :api` in your `config/application.rb`.
This will cause the [`ActionDispatch::DebugExceptions`][debug-exceptions]
middleware to generate debug information in the requested content-type instead of as HTML only. In turn, this allows
graphti-rails to generate more specific error messages for JSON API requests.

## Features

### Exception Handling
By default, Rails does a few things to handle exceptions. We integrate into this handling to ensure behavior
as close to the Rails defaults while still adding important conventions and additional information provide by
Graphiti.

#### `rescue_from`

At the highest level, is [`rescue_from`][rescue-from] which allows you to handle an error at the controller level.
This bypasses all default error handling in Rails, leaving it up to the developer to account for all scenarios.
In the future, we would like to provide some APIs for default handling in these cases.

#### `ActionDispatch::DebugExceptions`

Next is [`ActionDispatch::DebugExceptions`][debug-exceptions]. This middleware logs exceptions and renders debugging
information for local requests. We hook in here to log more information available from some Graphiti exceptions.

#### `ActionDispatch::ShowExceptions`

Last is [`ActionDispatch::ShowExceptions`][show-exceptions]. This middleware rescues any exception returned by the
application and calls an exceptions app that will wrap it in a format for the end user. We wrap the exceptions app
to ensure that JSON API errors are always rendered in the standard format.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


[debug-exceptions]: https://api.rubyonrails.org/classes/ActionDispatch/DebugExceptions.html
[rescue-from]: (https://api.rubyonrails.org/classes/ActiveSupport/Rescuable/ClassMethods.html#method-i-rescue_from)
[show-exceptions]: https://api.rubyonrails.org/classes/ActionDispatch/ShowExceptions.html
