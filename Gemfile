# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "~> 3.2"

# Specify your gem's dependencies in graphlit.gemspec
gemspec

gem "graphql-client", github: "rmosolgo/graphql-client", ref: "27ef61f"
gem "jwt", "~> 2.7.1"

group :development do
  gem "dotenv", ">= 2"
  gem "pry", ">= 0.14"
  gem "rake", "~> 13.0"
  gem "rspec", "~> 3.0"
  gem "rubocop", "~> 1.21"
  gem "solargraph-rails", "~> 1.1"
  gem "sorbet"
  gem "tapioca", require: false
end
