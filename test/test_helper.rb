ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # テスト環境をfixure => seedsに切り替え
  parallelize_setup do |worker|
    load "#{Rails.root}/db/seeds.rb"
  end

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...
end
