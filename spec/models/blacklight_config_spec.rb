require 'rails_helper'

RSpec.describe BlacklightConfig do
  subject { BlacklightConfig.new(resource, default_config) }
  let(:resource) { GenericAsset }
  let(:default_config) { CatalogController.blacklight_config }

  describe "#default_configuration" do
    it "should not error" do
      expect{subject.default_configuration}.not_to raise_error
    end
    it "should be the CatalogController's config" do
      expect(subject.default_configuration).to eq default_config
    end
  end

  describe "#set=" do
    let(:set) { instance_double(GenericSet, :id => "myset") }
    it "should set a show route" do
      subject.set = set

      expect(subject.configuration.show.route).to eq({:controller => "sets", :set_id => "myset"})
    end
  end


  describe "#configuration" do
    subject { BlacklightConfig.new(resource, default_config).configuration }
    describe "#index.title_field" do
      it "should be title" do
        expect(subject.index.title_field).to eq Solrizer.solr_name('title', :symbol)
      end
    end
    describe "#search_fields" do
      it "should have all the search fields" do
        expect(subject.search_fields.keys).to eq [
          "all_fields",
          "title",
          "description",
          "creator",
          "lcsubject",
          "date",
          "institution"
        ]
      end
    end
    describe "#default_solr_params" do
      it "should be right" do
        expect(subject.default_solr_params).to eq ({
          :qt => 'search',
          :rows => 10,
          :hl => true,
          :"hl.fl" => "full_text_tsimv",
          :"hl.useFastVectorHighlighter" => true
        })
      end
    end
    describe "#index.display_type_field" do
      it "should be has_model" do
        expect(subject.index.display_type_field).to eq Solrizer.solr_name('has_model', :symbol)
      end
    end
    it "should be a Blacklight::Configuration" do
      expect(subject).to be_instance_of Blacklight::Configuration
    end
    it "should have a show field config for each field" do
      keys = subject.show_fields.values.map(&:key)
      labels = subject.show_fields.values.map(&:label)
      expect(keys).to include "title_ssim"
      expect(labels).to include "Title"
      expect(keys).to include "alternative_ssim"
      expect(labels).to include "Alternative"
      expect(keys).to include *GenericAsset.properties.keys.map{|x| "#{x}_ssim"}
    end

    it "should have a tool config for edit" do
      expect(subject.show.document_actions[:edit_record].partial).to eq "edit_action"
    end
    
    it "should only have download, bookmark and edit as document actions" do
      expect(subject.show.document_actions.keys).to contain_exactly :download, :bookmark, :edit_record
    end

    it "should have an edit action for index" do
      expect(subject.index.document_actions[:edit_record].partial).to eq "edit_action"
    end
  end

end
