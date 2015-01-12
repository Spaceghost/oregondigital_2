require 'bogus/rspec'
Bogus.configure do |c|
  c.fake_ar_attributes = true
  c.search_modules = [OregonDigital]
end
Bogus.fakes do
  fake(:injector, :class => proc{OregonDigital::Injector}) do
    thumbnail_path Rails.root.join("media", "1", "0", "1.jpg").to_s
  end
end
RSpec.configure do |c|
  c.before do
    stub(OregonDigital).inject { fake(:injector) }
  end
end
