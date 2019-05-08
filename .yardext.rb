require 'kramdown'
require 'yard'

# Make new Kramdown class with Github Formatted Markdown on
class KramdownGFM < Kramdown::Document
  def initialize(text, opts={})
    super(text, opts.merge(input: 'GFM', hard_wrap: false))
  end
end

# Register new KramdownGFM
YARD::Templates::Helpers::MarkupHelper::MARKUP_PROVIDERS[:markdown] <<
  { lib: :"kramdown-parser-gfm", :const => "KramdownGFM" }

# Register custom templates
YARD::Templates::Engine.register_template_path File.expand_path("yard/templates", __dir__)

