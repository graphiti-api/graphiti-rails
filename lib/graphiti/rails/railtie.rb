# frozen_string_literal: true

module Graphiti
  module Rails
    class Railtie < ::Rails::Railtie
      config.graphiti = ActiveSupport::OrderedOptions.new

      config.graphiti.handled_exception_formats = [:jsonapi]

      initializer "graphiti-rails.action_controller" do |app|
        Graphiti::Rails.handled_exception_formats = app.config.graphiti.handled_exception_formats
      end
    end
  end
end
