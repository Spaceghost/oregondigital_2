class BlacklightConfig
  class ShowActions
    pattr_initialize :configuration

    def run
      add_edit_button
      add_download_button
      remove_defaults
    end

    private

    def add_download_button
      configuration.show.document_actions[:download] = download_action
    end

    def download_action
      Blacklight::Configuration::ToolConfig.new(:partial => "download_action")
    end

    def add_edit_button
      configuration.show.document_actions[:edit_record] = edit_action
      configuration.index.document_actions[:edit_record] = edit_action
    end

    def edit_action
      Blacklight::Configuration::ToolConfig.new(:partial => "edit_action")
    end

    def remove_defaults
      default_actions.each do |action|
        configuration.show.document_actions.delete(action)
      end
    end

    def default_actions
      [:refworks, :endnote, :email, :sms, :citation, :librarian_view]
    end
  end
end
