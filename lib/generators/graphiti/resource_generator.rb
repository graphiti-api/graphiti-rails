require_relative "generator_mixin"

module Graphiti
  class ResourceGenerator < ::Rails::Generators::NamedBase
    NAMESPACE_ROUTE_REGEX = /ApplicationResource.*^\s*[^\n#]*\sas:\s'api'\sdo/m

    include GeneratorMixin

    source_root File.expand_path("../templates", __FILE__)

    argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

    class_option :'omit-comments',
      type: :boolean,
      default: false,
      aliases: ["--omit-comments", "-c"],
      desc: "Generate without documentation comments"

    class_option :'rawid',
      type: :boolean,
      default: false,
      aliases: ["--rawid", "-r"],
      desc: "Generate tests using rawid"

    class_option :actions,
      type: :array,
      default: nil,
      aliases: ["--actions", "-a"],
      desc: 'Array of controller actions to support, e.g. "index show destroy"'

    class_option :'attributes-from',
      banner: "Model",
      type: :string,
      aliases: ["--model", "-m"],
      desc: "Specify to use attributes from a particular model"

    class_option :'namespace-controllers',
      type: :boolean,
      default: false,
      aliases: ["--namespace"],
      desc: "Generate controllers in a namespace specified in .graphiticfg.yml"

    desc "This generator creates a resource file at app/resources, as well as corresponding controller/specs/route/etc"
    def generate_all
      generate_model
      generate_controller
      generate_application_resource unless application_resource_defined?
      generate_route
      generate_resource
      generate_resource_specs
      generate_api_specs
    end

    private

    class ModelAction
      attr_reader :class_name
      def initialize(class_name)
        @class_name = class_name
      end

      def invoke!
        unless class_name.safe_constantize
          raise "You must define a #{class_name} model before generating the corresponding resource."
        end
      end

      def revoke!
        # Do nothing on destroy
      end
    end

    def generate_model
      action(ModelAction.new(class_name))
    end

    def omit_comments?
      @options["omit-comments"]
    end

    def generate_namespace_controllers?
      @options["namespace-controllers"]
    end

    def attributes_class
      return @attributes_class if @attributes_class

      case @options["attributes-from"]
      # thor will set the value to the key if no value is specified
      when "attributes-from"
        klass = class_name
      when :kind_of?, String
        klass = @options["attributes-from"].classify
      else
        # return nil if attributes-from isn't set or has an invalid value
        return
      end
      begin
        @attributes_class = klass.safe_constantize
      rescue NameError
        raise NameError, "attributes-from #{klass.inspect} does not exist."
      end
    end

    ##
    # Generates a list of OpenStruct(:name, :type) objects that map to
    # the +attributes_class+ columns.
    ##
    def default_attributes
      unless attributes_class.is_a?(Class) && attributes_class <= ApplicationRecord
        raise "Unable to set #{self} default_attributes from #{attributes_class}. #{attributes_class} must be a kind of ApplicationRecord"
      end
      if attributes_class.table_exists?
        return attributes_class.columns.map do |c|
          OpenStruct.new({name: c.name.to_sym, type: c.type})
        end
      else
        raise "#{attributes_class} table must exist. Please run migrations."
      end
    end

    def resource_attributes
      # set a temporary variable because overriding attributes causes
      # weird behavior when the generator is run. It will override
      # everytime regardless of the conditional.
      if !attributes_class.nil?
        default_attributes
      else
        attributes
      end
    end

    def responders?
      defined?(::Responders)
    end

    def generate_controller
      namespace_path = generate_namespace_controllers? ? api_namespace : class_path
      to = File.join("app/controllers", namespace_path, "#{file_name.pluralize}_controller.rb")
      template("controller.rb.erb", to)
    end

    def generate_application_resource
      to = File.join("app/resources", class_path, "application_resource.rb")
      template("application_resource.rb.erb", to)
      require "#{::Rails.root}/#{to}"
    end

    def application_resource_defined?
      "ApplicationResource".safe_constantize.present?
    end

    def namespace_resource_routes_exist?
      File.read('config/routes.rb').scan(NAMESPACE_ROUTE_REGEX).any?
    end

    def add_namespace_resource_routes
      inject_into_file "config/routes.rb", after: /ApplicationResource.*$\n/ do
        indent("scope module: '#{api_namespace[1..-1]}', as: 'api' do\nend\n", 4)
      end
    end

    def generate_route
      if generate_namespace_controllers?
        add_namespace_resource_routes unless namespace_resource_routes_exist?
        resource_routes_regex = NAMESPACE_ROUTE_REGEX
        indent = 6
      else
        resource_routes_regex = /ApplicationResource.*$\n/
        indent = 4
      end

      code = "\nresources :#{file_name.pluralize}"
      code << %(, only: [#{actions.map { |a| ":#{a}" }.join(", ")}]) if actions.length < 5
      code << "\n"
      inject_into_file "config/routes.rb", after: resource_routes_regex  do
        indent(code, indent)
      end
    end

    def generate_resource_specs
      opts = {}
      opts[:actions] = @options[:actions] if @options[:actions]
      opts[:rawid] = @options[:rawid] if @options[:rawid]
      invoke "graphiti:resource_test", [resource_klass], opts
    end

    def generate_api_specs
      opts = {}
      opts[:actions] = @options[:actions] if @options[:actions]
      opts[:rawid] = @options[:rawid] if @options[:rawid]
      invoke "graphiti:api_test", [resource_klass], opts
    end

    def generate_resource
      to = File.join("app/resources", class_path, "#{file_name}_resource.rb")
      template("resource.rb.erb", to)
      require "#{::Rails.root}/#{to}" if create?
    end

    def create?
      behavior == :invoke
    end

    def controller_klass
      generate_namespace_controllers? ?
        "#{api_namespace[1..-1].camelize}::#{model_klass.name.pluralize}Controller" :
        "#{model_klass.name.pluralize}Controller"
    end

    def model_klass
      class_name.safe_constantize
    end

    def resource_klass
      "#{model_klass}Resource"
    end

    def type
      model_klass.name.underscore.pluralize
    end
  end
end
