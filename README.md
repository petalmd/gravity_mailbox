# GravityMailbox

Development tools that aim to make it simple to visualize mail sent by your Rails app directly through your Rails app.
It works in development and also in a staging environment by using the `Rails.cache` to store the mails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gravity_mailbox'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gravity_mailbox

## Usage

* Config ActionMailer to use the RailsCacheDeliveryMethod.

```ruby
config.action_mailer.delivery_method = :gravity_mailbox_rails_cache
config.action_mailer.perform_deliveries = true
```

* Send mails
* Go to http://localhost:3000/mails to see the mails.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petalmd/gravity_mailbox.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
