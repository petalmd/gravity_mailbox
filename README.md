[![Gem Version](https://badge.fury.io/rb/gravity_mailbox.svg)](https://badge.fury.io/rb/gravity_mailbox)
[![Ruby](https://github.com/petalmd/gravity_mailbox/actions/workflows/main.yml/badge.svg)](https://github.com/petalmd/gravity_mailbox/actions/workflows/main.yml)

<p align="center">
  <img src="https://user-images.githubusercontent.com/7858787/213794938-f55aef73-ce49-45b5-a388-d16f2435de15.png" />
</p>

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
# config/environments/(development|staging).rb
config.action_mailer.delivery_method = :gravity_mailbox_rails_cache
config.action_mailer.perform_deliveries = true
```

* Mount the Engine

```ruby
# config/routes.rb
mount GravityMailbox::Engine => "/gravity_mailbox"
```

* Send mails
* Go to http://localhost:3000/gravity_mailbox to see the mails.

**Note**

You can use routing constraints to restrict access to GravityMailbox. More details and example in the [Rails Guides](https://guides.rubyonrails.org/routing.html#advanced-constraints). 


## Screenshots

<p align="center">
    <img width="520" alt="image" src="https://user-images.githubusercontent.com/7858787/213796119-a22ac9da-3943-4cd0-95e6-2fb724de999a.png">
</p>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Standalone app

Use `bundle exec rackup` to test locally the gem. Go to [http://localhost:9292](http://localhost:9292)
Use the button to send a test mail and to see those mail into GravityMailbox.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/petalmd/gravity_mailbox.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
