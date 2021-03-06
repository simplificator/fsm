# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = %q{fsm}
  s.version = "0.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["simplificator"]
  s.date = %q{2009-06-30}
  s.email = %q{info@simplificator.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION.yml",
    "lib/fsm.rb",
    "lib/fsm/builder.rb",
    "lib/fsm/errors.rb",
    "lib/fsm/executable.rb",
    "lib/fsm/machine.rb",
    "lib/fsm/options.rb",
    "lib/fsm/state.rb",
    "lib/fsm/state_attribute_interceptor.rb",
    "lib/fsm/transition.rb",
    "test/ar_test.rb",
    "test/executable_test.rb",
    "test/invoice_sample_test.rb",
    "test/options_test.rb",
    "test/state_test.rb",
    "test/test_helper.rb",
    "test/test_helper_ar.rb",
    "test/transition_test.rb",
    "test/water_sample_test.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/simplificator/fsm}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{A simple finite state machine (FSM) gem.}
  s.test_files = [
    "test/ar_test.rb",
    "test/executable_test.rb",
    "test/invoice_sample_test.rb",
    "test/options_test.rb",
    "test/state_test.rb",
    "test/test_helper.rb",
    "test/test_helper_ar.rb",
    "test/transition_test.rb",
    "test/water_sample_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
