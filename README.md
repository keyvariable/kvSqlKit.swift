# kvSqlKit.swift

A lightweight cross-platform SQL query framework on Swift.


## Examples

#### Hello world:

```swift
import kvSqlKit

// SELECT 'Hello world'
let query = KvSQL.select("Hello world").sql
```

#### Simple SELECT

```swift
import kvSqlKit

struct Items : KvSqlTable {
    static var id = "items"

    let sku = Column("sku", of: .serial, default: .implicit, constraints: [ .notNull, .primaryKey ])
    let count = Column("count", of: .integer, constraints: [ .notNull ])
}

// SELECT "items".* FROM "items" ORDER BY "items"."count" DESC
let query = KvSQL.select(items.*, from: items).orderBy(items.count.desc()).sql
```

#### More Examples

See [Tests](./Tests/kvSqlKitTests) for more examples.


## Supported Platforms

This package is cross-platform.
Package is built and the unit-tests are passed on macOS, Linux (Ubuntu 22.04) and Windows (10 x64).


## Getting Started

#### Package Dependencies:
```swift
.package(url: "https://github.com/keyvariable/kvSqlKit.swift.git", from: "0.3.1")
```
#### Target Dependencies:
```swift
.product(name: "kvSqlKit", package: "kvSqlKit.swift")
```
#### Import:
```swift
import kvSqlKit
```


## Authors

- Svyatoslav Popov ([@sdpopov-keyvariable](https://github.com/sdpopov-keyvariable), [info@keyvar.com](mailto:info@keyvar.com)).
