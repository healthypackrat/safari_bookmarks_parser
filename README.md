# safari\_bookmarks\_parser

This gem provides a command to dump `~/Library/Safari/Bookmarks.plist` as JSON/YAML.

## Prerequisites

In "System Preferences" -> "Security & Privacy" -> "Privacy" -> "Full Disk Access", check "Terminal".

## Installation

```
$ gem install safari_bookmarks_parser
```

## Usage

### Dump

Dump `Bookmarks.plist`:

```
$ safari_bookmarks_parser dump
```

Dump `Bookmarks.plist` as list:

```
$ safari_bookmarks_parser dump --list
```

Dump `Bookmarks.plist` as YAML:

```
$ safari_bookmarks_parser dump -f yaml
```

Dump Reading List only:

```
$ safari_bookmarks_parser dump -r
```

Dump without Reading List:

```
$ safari_bookmarks_parser dump -R
```

Dump other `Bookmarks.plist`:

```
$ safari_bookmarks_parser dump /path/to/Bookmarks.plist
```

### Dups

Find duplicated bookmarks:

```
$ safari_bookmarks_parser dups
```

Find duplicated bookmarks excluding reading list:

```
$ safari_bookmarks_parser dups -R
```

## Development

  - Run `bin/rubocop` to check syntax
  - Run `bin/rspec` to test

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/healthypackrat/safari_bookmarks_parser>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
