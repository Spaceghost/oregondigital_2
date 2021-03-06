# Determines a file path for an identifier (object pid, for instance), using a "bucket" directory
# structure of a configurable depth.
class OregonDigital::FileDistributor
  attr_accessor :base_path, :identifier, :depth, :extension

  # Sets up object with a default depth of 2 and a local base path
  def initialize(identifier)
    @identifier = identifier.to_s
    @depth = 2
    @base_path = Rails.root.join("media")
    @extension = ''
  end

  def base_path=(val)
    @base_path = Pathname.new(val)
  end

  # Sanitizes @identifier (converts all non-alphanumerics to hyphens) to return
  # a filesystem-safe identifier
  def identifier
    return @identifier.gsub(/\W/, '-')
  end

  # Sanitizes @identifier (converts all non-alphanumerics to hyphens) and returns a "safe" filename
  def filename
    return identifier + extension
  end

  # Reverses the identifier and creates a zero-padded "bucket"-style directory structure
  def bucket_path
    reversed = (identifier.rjust(@depth, "0")).reverse.split(//)
    (["%s"] * @depth).join("/") % reversed
  end

  # Creates a path @depth subdirectories deep to represent a "bucket"-style directory structure,
  # prefixing with base_path.  Zero-pads the identifier if it's too short.
  def path
    base_path.join(bucket_path, filename)
  end
end
