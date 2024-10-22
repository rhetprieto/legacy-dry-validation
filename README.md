# legacy-dry-validation [![Join the chat at https://gitter.im/dry-rb/chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dry-rb/chat)

## Description

This fork of dry-validation is based of v0.13 but works under a different namespace `LegacyDry` to avoid conflicts with the original gem. It doesn't depend on any other dry-rb gems, except for dry-configurable v0.13+, which is a very small dependency.

This will allow you to use both the latest version of dry-validation and this legacy version in the same project. Then you can migrate your codebase to the latest version of dry-validation at your own pace. 

## Instructions

Add this line to your application's Gemfile:

```ruby
gem 'legacy-dry-validation', git: 'rhetprieto/legacy-dry-validation', branch: "0-13-legacy-locked"
```
## Links

* [Documentation](http://dry-rb.org/gems/dry-validation)
* [Guidelines for contributing](CONTRIBUTING.md)

## License

See `LICENSE` file.
