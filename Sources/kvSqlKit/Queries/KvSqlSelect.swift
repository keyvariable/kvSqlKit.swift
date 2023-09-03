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
//  KvSqlSelect.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//

import kvKit



// MARK: - The Fabrics

extension KvSQL {

    public typealias Select = KvSqlSelect



    /// - Returns: A SELECT query builder.
    public static func select(_ fields: KvSqlRvalueList?, from table: KvSqlTable? = nil) -> Select {
        KvSqlSelectStatement(fields, from: table)
    }



    /// - Returns: A SELECT query builder.
    public static func select(_ fields: [KvSqlRvalue], from table: KvSqlTable? = nil) -> Select {
        if fields.isEmpty {
            KvDebug.pause("Warning: list of fields in SELECT query have to be non-empty")
        }

        return KvSqlSelectStatement(KvSqlSimpleRvalueList(fields), from: table)
    }



    /// - Returns: A SELECT query builder.
    public static func select(_ fields: KvSqlRvalue..., from table: KvSqlTable? = nil) -> Select {
        if fields.isEmpty {
            KvDebug.pause("Warning: list of fields in SELECT query have to be non-empty")
        }

        return KvSqlSelectStatement(KvSqlSimpleRvalueList(fields), from: table)
    }

}



// MARK: - KvSqlSelect

/// - Note: Use `KvSQL.select()`fabric methods to instantiate *KvSqlSelect*.
public protocol KvSqlSelect : KvSqlQuery, KvSqlWhere, KvSqlOrderBy, KvSqlLimit, KvSqlOffset { }



// MARK: - KvSqlSelectStatement

class KvSqlSelectStatement : KvSqlSelect, KvSqlWhereClause, KvSqlOrderByClause, KvSqlLimitClause, KvSqlOffsetClause {

    var fields: KvSqlRvalueList?

    var fromClause: KvSqlTable?

    var `where`: KvSqlBoolRvalue?

    var orderBy: [KvSqlOrderByExpressionProtocol]?

    var limit: KvSqlRvalue?
    var offset: KvSqlRvalue?



    init(_ fields: KvSqlRvalueList?, from table: KvSqlTable?) {
        self.fields = fields
        self.fromClause = table
    }

}



// MARK: : KvSqlQuery

extension KvSqlSelectStatement {

    func write(to dest: inout String) {
        dest += "SELECT"

        if let fields = fields {
            dest += " "
            KvSqlQueryKit.write(into: &dest, fields)
        }

        if let fromClause = fromClause {
            dest += " FROM "
            KvSqlQueryKit.write(into: &dest, fromClause)
        }

        writeWhere(to: &dest)
        writeOrderBy(to: &dest)
        writeLimit(to: &dest)
        writeOffset(to: &dest)
    }

}
