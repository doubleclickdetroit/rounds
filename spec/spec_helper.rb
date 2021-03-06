require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:facebook, {  'provider'    => 'facebook', 
                                         'uid'         => '1234', 
                                         'info'        => { 'name' => 'Foo Bar' }
                                       })


  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.extend ControllerMacros, :type => :controller
    config.extend ModelMacros, :type => :model
    # config.include Devise::TestHelpers, :type => :controller
    # config.extend ModelMacros # , :type => :controller

    config.before(:each) { PrivatePub.stub(:publish_to) }
  end

  # RSpec.configure do |config|
  #   unless defined?(SPEC_ROOT)
  #     SPEC_ROOT = File.join(File.dirname(__FILE__))
  #   end
  #   config.include Mailman::SpecHelpers
  #   config.before do
  #     Mailman.config.logger = Logger.new(File.join(SPEC_ROOT, 'mailman-log.log'))
  #   end
  #   config.after do
  #     FileUtils.rm File.join(SPEC_ROOT, 'mailman-log.log') rescue nil
  #   end
  # end
end

Spork.each_run do
  # This code will be run each time you run your specs.

  FactoryGirl.reload
end
