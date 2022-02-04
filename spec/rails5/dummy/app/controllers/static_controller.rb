class StaticController < ApplicationController
  def not_found
    raise ActiveRecord::RecordNotFound
  end

  def graphiti_not_found
    raise Graphiti::Errors::RecordNotFound
  end

  def fatal
    raise StandardError
  end
end
