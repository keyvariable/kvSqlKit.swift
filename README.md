# kvSqlKit-Swift

![Swift 5.2](https://img.shields.io/badge/swift-5.2-green.svg)
![Linux](https://img.shields.io/badge/os-linux-green.svg)
![macOS](https://img.shields.io/badge/os-macOS-green.svg)
![iOS](https://img.shields.io/badge/os-iOS-green.svg)

A lightweight SQL query generator for Swift projects.


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

See [Tests](https://github.com/keyvariable/kvSqlKit-Swift/tree/main/Tests/kvSqlKitTests) for more examples.


## Supported Platforms

This package is crossplatform.


## Getting Started

### Swift Tools 5.2+

#### Package Dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/keyvariable/kvSqlKit-Swift.git", from: "0.1.2"),
]
```

#### Target Dependencies:

```swift
dependencies: [
    .product(name: "kvSqlKit", package: "kvSqlKit-Swift"),
]
```

### Xcode

Documentation: [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).


## Authors

- Svyatoslav Popov ([@sdpopov-keyvariable](https://github.com/sdpopov-keyvariable), [info@keyvar.com](mailto:info@keyvar.com)).

