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
//
//  KvSqlUpdate.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 09.05.2020.
//



// MARK: - The Fabrics

extension KvSQL {

    public typealias Update = KvSqlUpdate



    /// - Returns: An UPDATE query builder.
    public static func update<Table, Assignments>(_ table: Table, set assignments: Assignments) -> Update
        where Table : KvSqlTable, Assignments : Sequence, Assignments.Element == (key: KvSqlColumn<Table>, value: KvSqlRvalue)
    {
        KvSqlUpdateStatement(table, set: assignments)
    }



    /// - Returns: An UPDATE query builder.
    public static func update<Table>(_ table: Table, set colomn: KvSqlColumn<Table>, to value: KvSqlRvalue) -> Update
        where Table : KvSqlTable
    {
        KvSqlUpdateStatement(table, set: CollectionOfOne((colomn, value)))
    }



    // MARK: Optionals

    /// - Returns: An UPDATE query builder.
    public static func update<Table, Assignments>(_ table: Table, set assignments: Assignments) -> Update
        where Table : KvSqlTable, Assignments : Sequence, Assignments.Element == (key: KvSqlColumn<Table>, value: KvSqlRvalue?)
    {
        KvSqlUpdateStatement(table, set: assignments.lazy.map { ($0.key, $0.value ?? KvSQL.null) })
    }



    /// - Returns: An UPDATE query builder.
    public static func update<Table>(_ table: Table, set colomn: KvSqlColumn<Table>, to value: KvSqlRvalue?) -> Update {
        KvSqlUpdateStatement(table, set: CollectionOfOne((colomn, value ?? KvSQL.null)))
    }

}



// MARK: - KvSqlUpdate

/// UPDATE query builder.
///
/// - Note: Use `KvSQL.update()`fabric methods to instantiate *KvSqlUpdate*.
///
/// - Note: *Key* and *value* labels in Assignments.Element for compatibility with the standard Swift types like *Dictionary* and *KeyValuePairs*.
public protocol KvSqlUpdate : KvSqlQuery, KvSqlWhere, KvSqlReturning { }



// MARK: - KvSqlUpdateStatement

class KvSqlUpdateStatement<Table, Assignments> : KvSqlUpdate, KvSqlWhereClause, KvSqlReturningClause
    where Table : KvSqlTable, Assignments : Sequence, Assignments.Element == (key: KvSqlColumn<Table>, value: KvSqlRvalue)
{
    
    var table: Table
    var assignments: Assignments

    var `where`: KvSqlBoolRvalue?

    var returning: KvSqlRvalueList?



    init(_ table: Table, set assignments: Assignments) {
        self.table = table
        self.assignments = assignments
    }

}



// MARK: : KvSqlQuery

extension KvSqlUpdateStatement {

    func write(to dest: inout String) {
        dest += "UPDATE "
        table.write(to: &dest)

        dest += " SET "
        KvSqlQueryKit.reduce(into: &dest, assignments, separator: ",") { (dest, assignment) in
            assignment.0.writeLastPathComponent(to: &dest)
            dest += "="
            assignment.1.write(to: &dest)
        }

        writeWhere(to: &dest)
        writeReturning(to: &dest)
    }

}
