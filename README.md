# Meta Field

Ruby On Rails serialization gem that supports `ActiveModel::Dirty` interface to track changes.

## Usage

1. Have a `meta` column in the database table

```ruby
class AddMetaToRecords < ActiveRecord::Migration
  def change
    add_column :records, :meta, :text, limit: 1.megabyte - 1
  end
end
```


2. Declare which fields are serialized in `meta` column

```ruby
class Record < ActiveRecord::Base
  has_meta_fields :field1, :field2

end
```

3. Use `field1` setter and getter as it is a regular record attribute.

```ruby
record = Record.new field1: 'value1'
record.field1 # => 'value1'
record.field1 = 'value2' # => 'value2'
record.save # saved to `meta` column as { 'field1' => 'value2' }
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'meta_field', git: 'https://github.com/garshyn/meta_field'
```

And then execute:
```bash
$ bundle
```

## Running the tests

Checkout the repo the then run

```ruby
rspec
```

## Built With

* ActiveRecord

## Contributing

Contributions are welcome

## Versioning

We use [SemVer](http://semver.org/) for versioning.

## Authors

* **Andrew Garshyn** - [garshyn](https://github.com/garshyn)

<!-- See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project. -->

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
