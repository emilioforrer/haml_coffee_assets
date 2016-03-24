# coding: UTF-8

guard :jasmine do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$}) { 'spec/javascripts' }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{vendor/assets/javascripts/(.+?)\.(js\.coffee\.erb|js\.coffee|js|coffee)$}) { |m| "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
end

guard 'rspec', cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{ m[1] }_spec.rb" }
end
