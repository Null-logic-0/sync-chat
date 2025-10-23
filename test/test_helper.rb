ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def log_in_as(user)
      post sessions_path, params: { user: { email: user.email, password: "password1234" } }
      follow_redirect! if response.redirect?
    end
  end
end
