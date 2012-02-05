About
=====

`mail_inbox` is an email catcher for visual testing. It might be also used for acceptance tests with capybara. Acts like a mail client for mail deliveries from your app.

Inspired by / borrowing / simillar / yet different from:

- `mail_view`
- `inbox`
- `cache_mailer`

Usage
=====

Rails 2.x
---------

```
gem install mail_inbox
```

in `config/environments/development.rb`:

```ruby
# MailInbox preview app
require 'mail_inbox/rails2'
config.middleware.use MailInbox::Mapper, '/mail_inbox'

# Action mailer using MailInbox
config.action_mailer.perform_deliveries  = true
config.action_mailer.delivery_method     = :mail_inbox
```

Rails 3.x
---------

Add mail_inbox to Gemfile and enable mail_inbox

```ruby
# Gemfile
gem 'mail_inbox'

# MailInbox preview app
# config/routes.rb
mount MailInbox::Application.new, :at => "/mail_inbox"

# Action mailer using MailInbox
config.action_mailer.perform_deliveries  = true
config.action_mailer.delivery_method     = :mail_inbox
```

Sinatra
-------

TBD
