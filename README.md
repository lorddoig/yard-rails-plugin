# yard-rails-plugin

This is a fork of the original [Yard::Rails::Plugin](https://github.com/ogeidix/yard-rails-plugin) by [Ogeidix](https://github.com/ogeidix).  This guy takes the credit.

Forked because I want a separate repo to hack on.  It may be better, it may be not.  It wasn't designed with public consumption in mind.

Adds a couple of convenient things for documenting rails:

* Routes
  * Adds a `routes` entry to your Yard file list which enumerates your routes, mounted engines etc
  * Adds route information to controller class and method documentation

* Controllers
  * Adds params taken by each method to their documentation

## Installation

In your gemfile

    gem 'yard-rails-plugin', '>= 0.1.0', github: 'lorddoig/yard-rails-plugin'

Or for older versions of bundler

    gem 'yard-rails-plugin', '>= 0.1.0', git: 'https://github.com/lorddoig/yard-rails-plugin.git'

Followed by a quick `bundle install`.

Put this line in your `.yardopts` file

    "{lib,app}/**/*.rb" --plugin rails-plugin - tmp/routes.html

Tested with Yard 0.8.3 and Ruby 2.0.0 - your mileage may vary.  Original gem was pretty broken on this set up.

## Usage

None!  The plugin will run when you run `yard doc`, `yard server` etc

**Note** that to get your routes it has to load Rails, so there's a longer than usual delay

## Contribution

Pull requests here or with the original author, [Ogeidix](https://github.com/ogeidix) at [Yard::Rails::Plugin](https://github.com/ogeidix/yard-rails-plugin)

## TODO

* A `@renders` tag for controllers
  * Showing HTTP status, content-type, template in docs
* Get logic out of the view files, DRY them up a bit too
