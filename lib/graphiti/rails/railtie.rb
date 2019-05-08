# frozen_string_literal: true

module Graphiti
  module Rails
    # This Railtie registers Graphiti error classes with ActionDispatch. It also exposes
    # `config.graphiti.handled_exception_formats` which defaults to `[:jsonapi]`.
    # @see Graphiti::Rails.handled_exception_formats
    class Railtie < ::Rails::Railtie
      GRAPHITI_ERROR_CODES = {
        # There are many other Graphiti Errors but we are assuming they'll be rolled up into InvalidRequest or are 5xx errors
        "Graphiti::Errors::InvalidRequest" => :bad_request,
        "Graphiti::Errors::RecordNotFound" => :not_found,
        "Graphiti::Errors::RemoteWrite" => :bad_request

        # TODO: We may want to include this if it ends up not being easily rolled up into InvalidRequest
        # https://github.com/wagenet/graphiti-rails/issues/16
        # "Graphiti::Errors::SingularSideload" => :bad_request,
      }

      config.graphiti = ActiveSupport::OrderedOptions.new

      config.graphiti.handled_exception_formats = [:jsonapi]

      config.action_dispatch.rescue_responses.merge!(GRAPHITI_ERROR_CODES)

      initializer "graphiti-rails.action_controller" do |app|
        Graphiti::Rails.handled_exception_formats = app.config.graphiti.handled_exception_formats
      end
    end
  end
end
