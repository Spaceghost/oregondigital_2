class GenericAsset < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include OregonDigital::Derivatives::Model
  apply_schema DecoratedODDataModel,
    ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:stored_searchable, :symbol])
    )
  contains "content", :class_name => 'FileContent'
  contains "workflow_metadata", :class_name => "Files::YmlFile"
  delegate :content_changed?,:blank?, :to => :content, :prefix => true
  delegate :streamable_content, :to => :content

  def injector
    @injector ||= OregonDigital.inject
  end

  # Override indexing service to allow for indexing AF::Base objects in
  # properties.
  def indexing_service
    @indexing_service ||= IndexingService.new(self)
  end

  private

  def assign_id
    injector.id_service.mint.reverse
  end

end
