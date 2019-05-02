# frozen_string_literal: true

module Graphiti
  module Rails
    class Railtie < ::Rails::Railtie
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
        Graphiti::Errors::RecordNotFound => 404
        # Graphiti::Errors::RequiredFilter
      )
    end
  end
end
