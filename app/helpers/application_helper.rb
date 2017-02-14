module ApplicationHelper
  
  def flash_class(level)
    case level
      when "info" then "alert alert-dismissible alert-info"
      when "success" then "alert alert-dismissible alert-success"
      when "warning" then "alert alert-dismissible alert-warning"
      when "danger" then "alert alert-dismissible alert-danger"
    end
  end
  
end
