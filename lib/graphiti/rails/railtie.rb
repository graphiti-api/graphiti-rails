# frozen_string_literal: true

module Graphiti
  module Rails
    class Railtie < ::Rails::Railtie
      config.graphiti = ActiveSupport::OrderedOptions.new

      config.graphiti.handled_exception_formats = [:jsonapi]

      config.action_dispatch.rescue_responses.merge!(
        # There are many other Graphiti Errors but we are assuming they'll be rolled up into InvalidRequest or are 5xx errors
        "Graphiti::Errors::InvalidRequest" => :bad_request,
        "Graphiti::Errors::RecordNotFound" => :not_found,

        # TODO: Settle on :forbidden vs :bad_request here
        # https://github.com/wagenet/graphiti-rails/issues/17
        "Graphiti::Errors::RemoteWrite" => :forbidden # Or maybe :bad_request

        # TODO: We may want to include this if it ends up not being easily rolled up into InvalidRequest
        # https://github.com/wagenet/graphiti-rails/issues/16
        # "Graphiti::Errors::SingularSideload" => :bad_request,
      )

      initializer "graphiti-rails.action_controller" do |app|
        Graphiti::Rails.handled_exception_formats = app.config.graphiti.handled_exception_formats
      end
    end
  end
end
