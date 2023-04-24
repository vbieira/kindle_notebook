# KindleNotebook

Fetch your Kindle Highlights along with their context using the Selenium Webdriver

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
$ bundle add kindle_notebook
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
$ gem install kindle_notebook
```

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
book.to_csv_file # => "Docker: A Project-Based Approach to Learning - Cannon, Jason.csv"
```

## Examples

Book:
```rb
#<KindleNotebook::Book:0x00007f0847c4e388
  @asin="B09FJ3411G",
  @author="Cannon, Jason",
  @highlights=[#<KindleNotebook::Highlight:0x00007f46959d61f0 @book_asin="B09FJ3411G", ...],
  @highlights_count=13,
  @title="Docker: A Project-Based Approach to Learning">
```

<!-- TODO: create highligh class -->
Highlight:
```rb
#<KindleNotebook::Highlight:0x00007f46959d61f0
  @book_asin="B09FJ3411G",
  @context="If you get stuck, the logging component of systemd, called journald, can also help.",
  @page="120",
  @raw_context="used, for example. If you get stuck, the logging component of systemd, called journald, can also help. This journald command displays the last 20 entries in the",
  @raw_text="journald,",
  @text="journald">
```

Book CSV:
```csv
text,page,context,book_asin,raw_text,raw_context
journald,120,,B09FJ3411G,"journald,",
swarm,225,"Docker Swarm In this chapter, you're going to learn how to create and use a Docker",B09FJ3411G,swarm.,"Docker Swarm In this chapter, you're going to learn how to create and use a Docker"
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
