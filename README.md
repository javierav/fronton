# Fronton

A command-line tool for build frontend apps in Ruby.

It uses [Sprockets](https://github.com/rails/sprockets) and
[Tilt](https://github.com/rtomayko/tilt) to creates an environment for assets
compiling similar to
[Rails Assets Pipeline](http://guides.rubyonrails.org/asset_pipeline.html). It
support all engines supported by *Sprockets* and *Tilt* like *Javascript*,
*Sass*, *CoffeeScript*, *Haml*, *Slim*, etc.


## Status

[![Gem Version](https://badge.fury.io/rb/fronton.svg)](https://badge.fury.io/rb/fronton)

> **This project is still experimental, use with caution!**


## Installation

```
$ gem install fronton --pre
```


## Getting Started

### Available commands

* **fronton new**: generate a new blank app with a default skeleton.
* **fronton server**: start a development server for html & assets.
* **fronton compile**: compile html & assets files for distribution.
* **fronton clean**: remove old compiled html & assets files.
* **fronton clobber**: remove all compiled html & assets files.
* **fronton info**: show information about the environment.
* **fronton help**: show commands help.

### Config file

Configuration options are readed from a `fronton.yml` file located in project
top folder.

```yaml
assets:
  - application.js
  - application.css
  - "*.png"
assets_paths:
  - assets/javascripts
  - assets/stylesheets
  - assets/fonts
  - assets/images
  - vendor/javascripts
  - vendor/stylesheets
  - vendor/fonts
  - vendor/images
assets_url: https://assets.example.com
compressors:
  css: scss
  js: uglifier
dependencies:
  - rails-assets-jquery: 3.1.0
  - slim: 3.0.7
output: public
pages:
  - index.slim: /
pages_paths:
  - pages
```

| Attribute    | Type   | Description                                                |
| ------------ | ------ | ---------------------------------------------------------- |
| assets       | Array  | List of assets to compile (only js and css files)          |
| assets_paths | Array  | List of directories where Sprockets find files for require |
| assets_url   | String | URL for assets in production                               |
| compressors  | Hash   | Hash with selected compressors by type                     |
| dependencies | Array  | List of gems to install and require                        |
| output       | String | Path to a directory where compiled assets will be written  |
| pages        | Array  | List of pages to compile                                   |
| pages_paths  | Array  | List of directories where Fronton find html files          |

### Gem sources

In order to allow **Fronton** to install project gem dependencies automatically,
if you use gems from others sources than `https://rubygems.org` like
`https://rails-assets.org`, you must add these sources to rubygems configuration
file.

```
$ gem sources --add https://rails-assets.org
```

### Proposed folders hierarchy

```
.
├── assets
│   ├── fonts
│   ├── images
│   ├── javascripts
│   └── stylesheets
├── fronton.yml
├── locales
│   └── es
│       └── index.yml
├── pages
├── public
└── vendor
    ├── fonts
    ├── images
    ├── javascripts
    └── stylesheets
```

## Testing

Tests are written using *Minitest*.

```
$ bundle exec rake
```


## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)


## Versioning

**fronton** uses [Semantic Versioning 2.0.0](http://semver.org)


## License

Copyright © 2016 Javier Aranda. Released under [MIT](LICENSE.md) license.
