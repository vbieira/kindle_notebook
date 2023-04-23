# KindleNotebook

Fetch your Kindle Highlights along with their context using the Selenium Webdriver

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

Create a `.env` file and add your Amazon credentials to it:
```sh
cp -n .env_sample .env
```

To get the highlights from a book:
```rb
books = KindleNotebook::Client.books
book = books.first.fetch_highlights
book.highlights
```

To write to a CSV file:
```rb
KindleNotebook.to_csv(highlights) # => "output.csv"
# TODO: example
# TODO: book.to_csv (save csv file with name of the book and highlights count?)
```

## Examples

Book:
```rb
#<KindleNotebook::Book:0x00007f0847c4e388
  @asin="B09FJ3411G",
  @author="Cannon, Jason",
  @highlights=[],
  @highlights_count=13,
  @title="Docker: A Project-Based Approach to Learning">
```

<!-- TODO: create highligh class -->
Highlight:
```rb
#<struct KindleNotebook::Highlights::Highlight
  text="journald",
  page="120",
  context="If you get stuck, the logging component of systemd, called journald, can also help.">
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vbieira/kindle_notebook. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/vbieira/kindle_notebook/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the KindleNotebook project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kindle_notebook/blob/master/CODE_OF_CONDUCT.md).
