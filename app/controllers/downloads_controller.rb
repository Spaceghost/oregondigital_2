# Implements core Hydra download behaviors, allowing for arbitrary datastream downloading.  For
# more complex permissions or content download options, many methods in
# Hydra::Controller::DownloadBehavior can be overridden.
class DownloadsController < ApplicationController
  include Hydra::Controller::DownloadBehavior

  def prepare_file_headers
    send_file_headers! content_options
    file.mime_type = "image/jpeg"
    response.headers['Content-Type'] = file.mime_type
    self.content_type = file.mime_type
  end

end
