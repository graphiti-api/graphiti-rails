# Graphiti::Rails

Graphiti::Rails provides robust Rails integration for Graphiti, following standard Rails conventions.

## Usage
Out of the box, Graphiti::Rails requires no configuration!

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'graphiti-rails'
```

### Additional Setup

#### Debug Exception Format

If you're already running Rails in [API-only mode](https://guides.rubyonrails.org/api_app.html#changing-an-existing-application), there's no additional setup. Otherwise, we recommend the following in `config/application.rb`:

```ruby
config.debug_exception_response_format = :api
```

This will cause the [`ActionDispatch::DebugExceptions`][debug-exceptions] middleware to generate debug information in the requested content-type instead of as HTML only. In turn, this allows graphti-rails to generate more specific error messages for JSON API requests.

#### Handled Exception Formats

Since Rails doesn't correctly format exceptions for JSON:API requests, graphiti-rails intercepts these requests for proper rendering. If you'd like to use the GraphitiError handlers for other response types as well, you can add them in `config/application.rb`:

```ruby
config.graphiti.handled_exception_formats += [:xml]
```

## Features

### Exception Handling
By default, Rails does a few things to handle exceptions. We integrate into this handling to ensure behavior as close to the Rails defaults while still adding important conventions and additional information provide by Graphiti.

#### `rescue_from`

At the highest level, is [`rescue_from`][rescue-from] which allows you to handle an error at the controller level. This bypasses all default error handling in Rails, leaving it up to the developer to account for all scenarios. In the future, we would like to provide some APIs for default handling in these cases.

#### `ActionDispatch::DebugExceptions`

Next is [`ActionDispatch::DebugExceptions`][debug-exceptions]. This middleware logs exceptions and renders debugging information for local requests. We hook in here to log information in a proper format for JSON:API.

#### `ActionDispatch::ShowExceptions`

Last is [`ActionDispatch::ShowExceptions`][show-exceptions]. This middleware rescues any exception returned by the application and calls an exceptions app that will wrap it in a format for the end user. We wrap the exceptions app to ensure that JSON:API errors are always rendered in the standard format.

### Context Wrapping
We wrap all requests in a Graphiti context pointing to the current controller instance. If you'd like to use a different context, overwrite the `graphiti_context` method in your controller.

For more information about Graphiti context, see the [Graphiti docs][context].

### Debugging
We also provide hooks for Graphiti's built-in debugger. For more information see the [Graphiti docs][debugger].

## Contributing
We'd love to have your help improving graphiti-rails. To chat with the team and other users, join the `#rails` channel on [Slack][slack].

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


[debug-exceptions]: https://api.rubyonrails.org/classes/ActionDispatch/DebugExceptions.html
[context]: https://www.graphiti.dev/guides/concepts/resources#context
[debugger]: https://www.graphiti.dev/guides/concepts/debugging#debugger
[rescue-from]: https://api.rubyonrails.org/classes/ActiveSupport/Rescuable/ClassMethods.html#method-i-rescue_from
[show-exceptions]: https://api.rubyonrails.org/classes/ActionDispatch/ShowExceptions.html
[slack]: https://join.slack.com/t/graphiti-api/shared_invite/enQtMjkyMTA3MDgxNTQzLWVkMDM3NTlmNTIwODY2YWFkMGNiNzUzZGMzOTY3YmNmZjBhYzIyZWZlZTk4YmI1YTI0Y2M0OTZmZGYwN2QxZjg
