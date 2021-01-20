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
//  KvSqlCreateTable.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



// MARK: - The Fabrics

extension KvSQL {

    public typealias CreateTable = KvSqlCreateTable



    /// - Returns: A CREATE TABLE query builder.
    public static func create<Table>(table: Table) -> CreateTable where Table : KvSqlTable {
        KvSqlCreateTableStatement(table)
    }

}



// MARK: - KvSqlCreateTable

/// - Note: Use `KvSQL.create(table:)` fabric method to instantiate *KvSqlCreateTable*.
public protocol KvSqlCreateTable : KvSqlQuery { }



// MARK: - KvSqlCreateTableStatement

class KvSqlCreateTableStatement<Table> : KvSqlCreateTable where Table : KvSqlTable {

    var table: Table



    init(_ table: Table) {
        self.table = table
    }

}



// MARK: : KvSqlQuery

extension KvSqlCreateTableStatement {

    func write(to dest: inout String) {

        func WriteColumnDeclaration<Table>(into dest: inout String, _ column: KvSqlColumn<Table>)
            where Table : KvSqlTable
        {
            column.writeLastPathComponent(to: &dest)

            dest += " "
            column.type.write(to: &dest)

            if let `default` = column.default {
                dest += " DEFAULT"

                switch `default` {
                case .explicit(let rvalue):
                    dest += " "
                    rvalue.write(to: &dest)

                case .implicit:
                    break
                }
            }

            if !column.constraints.isEmpty {
                dest += " "
                KvSqlQueryKit.write(into: &dest, column.constraints, separator: " ")
            }
        }


        dest += "CREATE TABLE "
        table.write(to: &dest)

        dest += "("
        KvSqlQueryKit.reduce(into: &dest, table.columns(), separator: ",", accumulator: WriteColumnDeclaration(into:_:))
        dest += ")"

    }

}
