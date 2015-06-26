require 'rails_helper'

RSpec.describe "catalog/_download_action.html.erb" do
  let(:document) { instance_double(SolrDocument, :id => "1")}
  before do
    allow(view).to receive(:can?).with(:edit, document).and_return(permission_result)
    render :partial => "catalog/download_action.html.erb", :locals => {:document => document }
  end
  context "when they can download the document" do
    let(:permission_result) { true }
    it "should have the download link" do
      expect(rendered).to have_link("Download")
    end
  end
end
