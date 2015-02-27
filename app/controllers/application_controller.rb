class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def xsendfile(path, options)
    # headers["Content-Transfer-Encoding"] = "binary"
    # headers["Content-Type"] = options[:type] || "application/force-download"
    # headers["Content-Disposition"] = "attachment; file=\"#{File.basename path}\""

    headers["X-Sendfile"] = path

    render nothing: true
  end

end
