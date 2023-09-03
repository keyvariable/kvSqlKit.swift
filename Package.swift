// swift-tools-version:5.2
//
//===----------------------------------------------------------------------===//
//
//  Copyright (c) 2021 Svyatoslav Popov.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
//  specific language governing permissions and limitations under the License.
//
//  SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackageDescription


let targets: [Target] = [
    .target(name: "kvSqlKit",
            dependencies: [ .product(name: "kvKit", package: "kvKit.swift") ]),
    .testTarget(name: "kvSqlKitTests", dependencies: [ "kvSqlKit" ]),
]

let package = Package(
    name: "kvSqlKit.swift",
    platforms: [ .iOS(.v11), ],
    products: [
        .library(name: "kvSqlKit", targets: [ "kvSqlKit" ]),
    ],
    dependencies: [
        .package(url: "https://github.com/keyvariable/kvKit.swift.git", from: "4.2.0"),
    ],
    targets: targets
)
