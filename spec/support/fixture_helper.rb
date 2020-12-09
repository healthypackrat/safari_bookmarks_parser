# frozen_string_literal: true

module FixtureHelper
  def fixture_path(path)
    File.join(__dir__, '../fixtures', path)
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
