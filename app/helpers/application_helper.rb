module ApplicationHelper

  def assign_if ( the_value )
    return the_value if the_value.to_s.length > 0
  end

end
