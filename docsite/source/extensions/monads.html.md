---
title: Monads
layout: gem-single
name: legacy_dry-validation
---

This extension add a new method (`#to_monad`) to validation result.

```ruby
LegacyDry::Validation.load_extensions(:monads)

schema = LegacyDry::Validation.Schema { required(:name).filled(:str?, size?: 2..4) }
schema.call(name: 'Jane').to_monad # => LegacyDry::Monads::Success({ name: 'Jane' })
schema.call(name: '').to_monad     # => LegacyDry::Monads::Failure(name: ['name must be filled', 'name length must be within 2 - 4'])
```

This can be useful when used with `dry-monads` and the [`do` notation](/gems/dry-monads/1.0/do-notation).
