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
//  KvSqlInsert.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 21.04.2020.
//



// MARK: - The Fabrics

extension KvSQL {

    public typealias Insert = KvSqlInsert



    // MARK: Multiple Rows

    /// - Returns: An INSERT query builder.
    public static func insert<Rows>(into table: KvSqlTable, _ columns: [KvSqlColumnProtocol]? = nil, values: Rows) -> KvSqlInsert
        where Rows : Sequence, Rows.Element : Sequence, Rows.Element.Element == KvSqlRvalue
    {
        KvSqlInsertStatement(into: table, columns, values: values)
    }



    /// - Returns: An INSERT query builder.
    public static func insert<Rows>(into table: KvSqlTable, _ columns: KvSqlColumnProtocol..., values: Rows) -> KvSqlInsert
        where Rows : Sequence, Rows.Element : Sequence, Rows.Element.Element == KvSqlRvalue
    {
        KvSqlInsertStatement(into: table, columns, values: values)
    }



    // MARK: Single Row

    /// - Returns: An INSERT query builder.
    public static func insert<Row>(into table: KvSqlTable, _ columns: [KvSqlColumnProtocol]? = nil, values row: Row) -> KvSqlInsert
        where Row : Sequence, Row.Element == KvSqlRvalue
    {
        KvSqlInsertStatement(into: table, columns, values: CollectionOfOne(row))
    }



    /// - Returns: An INSERT query builder.
    public static func insert<Row>(into table: KvSqlTable, _ columns: KvSqlColumnProtocol..., values row: Row) -> KvSqlInsert
        where Row : Sequence, Row.Element == KvSqlRvalue
    {
        KvSqlInsertStatement(into: table, columns, values: CollectionOfOne(row))
    }



    // MARK: Multiple Rows with Optionals

    /// - Returns: An INSERT query builder.
    public static func insert<Rows, Row>(into table: KvSqlTable, _ columns: [KvSqlColumnProtocol]? = nil, values: Rows) -> KvSqlInsert
        where Rows : Sequence, Rows.Element == Row, Row : Sequence, Row.Element == KvSqlRvalue?
    {
        KvSqlInsertStatement(into: table, columns, values: values.lazy.map { row in row.lazy.map { $0 ?? KvSQL.null } })
    }



    /// - Returns: An INSERT query builder.
    public static func insert<Rows, Row>(into table: KvSqlTable, _ columns: KvSqlColumnProtocol..., values: Rows) -> KvSqlInsert
        where Rows : Sequence, Rows.Element == Row, Row : Sequence, Row.Element == KvSqlRvalue?
    {
        KvSqlInsertStatement(into: table, columns, values: values.lazy.map { row in row.lazy.map { $0 ?? KvSQL.null } })
    }



    // MARK: Single Row with Optionals

    /// - Returns: An INSERT query builder.
    public static func insert<Row>(into table: KvSqlTable, _ columns: [KvSqlColumnProtocol]? = nil, values row: Row) -> KvSqlInsert
        where Row : Sequence, Row.Element == KvSqlRvalue?
    {
        KvSqlInsertStatement(into: table, columns, values: CollectionOfOne(row.lazy.map { $0 ?? KvSQL.null }))
    }



    /// - Returns: An INSERT query builder.
    public static func insert<Row>(into table: KvSqlTable, _ columns: KvSqlColumnProtocol..., values row: Row) -> KvSqlInsert
        where Row : Sequence, Row.Element == KvSqlRvalue?
    {
        KvSqlInsertStatement(into: table, columns, values: CollectionOfOne(row.lazy.map { $0 ?? KvSQL.null }))
    }

}



// MARK: - KvSqlInsert

/// - Note: Use `KvSQL.insert()` fabric methods to instantiate *KvSqlInsert*.
///
/// - Note: *KvSqlInsert* is generic to provide ability to use lazy collections, *CollectionOfOne* etc.
public protocol KvSqlInsert : KvSqlQuery, KvSqlReturning { }



// MARK: - KvSqlInsertStatement

class KvSqlInsertStatement<Rows> : KvSqlInsert, KvSqlReturningClause
    where Rows : Sequence, Rows.Element : Sequence, Rows.Element.Element == KvSqlRvalue
{

    var table: KvSqlTable
    var columns: [KvSqlColumnProtocol]?

    var values: Rows

    var returning: KvSqlRvalueList?



    init(into table: KvSqlTable, _ columns: [KvSqlColumnProtocol]?, values: Rows) {
        self.table = table
        self.columns = columns
        self.values = values
    }

}



// MARK: : KvSqlQuery

extension KvSqlInsertStatement {

    func write(to dest: inout String) {
        dest += "INSERT INTO "
        table.write(to: &dest)

        if let columns = columns, !columns.isEmpty {
            dest += " ("
            KvSqlQueryKit.reduce(into: &dest, columns, separator: ",", accumulator: { (dest, column) in column.writeLastPathComponent(to: &dest) })
            dest += ")"
        }

        dest += " VALUES "
        KvSqlQueryKit.reduce(into: &dest, values, separator: ",") { (dest, row) in
            dest += "("
            KvSqlQueryKit.reduce(into: &dest, row, separator: ",") { (dest, value) in value.write(to: &dest) }
            dest += ")"
        }

        writeReturning(to: &dest)
    }

}
