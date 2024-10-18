---
title: Reusing Schemas
layout: gem-single
name: legacy_dry-validation
---

You can easily reuse existing schemas using nested-schema syntax:

``` ruby
AddressSchema = LegacyDry::Validation.Schema do
  required(:street).filled
  required(:city).filled
  required(:zipcode).filled
end

UserSchema = LegacyDry::Validation.Schema do
  required(:email).filled
  required(:name).filled
  required(:address).schema(AddressSchema)
end

UserSchema.(
  email: 'jane@doe',
  name: 'Jane',
  address: { street: nil, city: 'NYC', zipcode: '123' }
).messages

# {:address=>{:street=>["must be filled"]}}
```
