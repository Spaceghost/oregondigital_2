module OregonDigital::Derivatives
  class ImageDerivativeGenerator
    attr_accessor :asset, :file, :thumbnail_path, :medium_path

    def initialize(asset, file, thumbnail_path, medium_path)
      @asset = asset
      @file = file
      @thumbnail_path = thumbnail_path
      @medium_path = medium_path
    end

    def run
      create_thumbnail
      create_medium
    end

    def thumbnail_success(path)
      asset.has_thumbnail = true
      asset.thumbnail_path = path
    end

    def medium_success(path)
      asset.has_medium = true
      asset.medium_path = path
    end

    private

    def stream_content
      @stream_content ||= StringIO.new(file.content)
    end

    def create_thumbnail
      ThumbnailDerivativeRunner.new(stream_content, thumbnail_path, self).run
    end

    def create_medium
      MediumImageDerivativeRunner.new(stream_content, medium_path, self).run
    end

    def injector
      @injector ||= OregonDigital.inject
    end

  end
end
