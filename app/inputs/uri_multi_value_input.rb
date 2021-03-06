class UriMultiValueInput < MultiValueInput
  protected

  def build_field(value, index)
    options = build_field_options(value, index)
    OregonDigital::URIEnabledStringField.new(@builder, attribute_name, options).field
  end
end
