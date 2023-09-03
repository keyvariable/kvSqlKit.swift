//===----------------------------------------------------------------------===//
//
//  Copyright (c) 2021 Svyatoslav Popov (info@keyvar.com).
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
//
//  KvSqlTable.swift
//  KvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



/// An SQL table protocol.
///
/// Tables should be described with a type conforming to *KvSqlTable* protocol and have instance properties of *Column* type.
///
/// ### Implementation Details
/// There are minimum of instance properies to minimize conflicts with column identifiers.
public protocol KvSqlTable : KvSqlTokenSource {

    /// A type of the table's columns.
    typealias Column = KvSqlColumn<Self>



    static var id: String { get }

}



// MARK: Auxiliaries

extension KvSqlTable {

    /// - Returns: Value of `Self.id`.
    public func tableIdentifier() -> String { Self.id }


    /// - Returns: All instance properties of *Column* type.
    public func columns() -> AnySequence<Column> {
        .init(Mirror(reflecting: self).children.lazy.compactMap { $0.value as? KvSqlColumn })
    }

}



// MARK: : KvSqlTokenSource

extension KvSqlTable {

    public func write(to dest: inout String) { dest += "\"\(Self.id)\"" }

}



// MARK: - .* Operator

postfix operator .*



public postfix func .*(table: KvSqlTable) -> KvSqlRvalue {
    KvSqlRawToken("\(table.sql).*")
}



// MARK: - KvSQL Integration

extension KvSQL {

    public typealias Table = KvSqlTable

}
