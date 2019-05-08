# frozen_string_literal: true

module Graphiti
  module Rails
    class Railtie < ::Rails::Railtie
      config.graphiti = ActiveSupport::OrderedOptions.new

      config.graphiti.handled_exception_formats = [:jsonapi]

      config.action_dispatch.rescue_responses.merge!(
        # Graphiti::Errors::AdapterNotImplemented,
        # Graphiti::Errors::SideloadConfig,
        # Graphiti::Errors::Remote,
        # Graphiti::Errors::AroundCallbackProc,
        # Graphiti::Errors::RemoteWrite,
        # Graphiti::Errors::UnsupportedOperator,
        # Graphiti::Errors::UnwritableRelationship,
        # Graphiti::Errors::SingularSideload,
        # Graphiti::Errors::UnsupportedSort,
        # Graphiti::Errors::ExtraAttributeNotFound,
        # Graphiti::Errors::InvalidFilterValue,
        # Graphiti::Errors::MissingEnumAllowList,
        # Graphiti::Errors::InvalidLink,
        # Graphiti::Errors::SingularFilter,
        # Graphiti::Errors::Unlinkable,
        # Graphiti::Errors::SideloadParamsError,
        # Graphiti::Errors::SideloadQueryBuildingError,
        # Graphiti::Errors::SideloadAssignError,
        # Graphiti::Errors::AttributeError,
        # Graphiti::Errors::InvalidJSONArray,
        # Graphiti::Errors::InvalidEndpoint,
        # Graphiti::Errors::InvalidType,
        # Graphiti::Errors::ResourceEndpointConflict,
        # Graphiti::Errors::PolymorphicResourceChildNotFound,
        # Graphiti::Errors::ValidationError,
        # Graphiti::Errors::ImplicitFilterTypeMissing,
        # Graphiti::Errors::ImplicitSortTypeMissing,
        # Graphiti::Errors::TypecastFailed,
        # Graphiti::Errors::ModelNotFound,
        # Graphiti::Errors::TypeNotFound,
        # Graphiti::Errors::PolymorphicSideloadTypeNotFound,
        # Graphiti::Errors::PolymorphicSideloadChildNotFound,
        # Graphiti::Errors::MissingSideloadFilter,
        # Graphiti::Errors::MissingDependentFilter,
        # Graphiti::Errors::ResourceNotFound
        # Graphiti::Errors::UnsupportedPagination,
        # Graphiti::Errors::UnsupportedPageSize,
        # Graphiti::Errors::InvalidInclude,
        # Graphiti::Errors::StatNotFound,
        "Graphiti::Errors::RecordNotFound" => :not_found
        # Graphiti::Errors::RequiredFilter
      )

      initializer "graphiti-rails.action_controller" do |app|
        Graphiti::Rails.handled_exception_formats = app.config.graphiti.handled_exception_formats
      end
    end
  end
end
