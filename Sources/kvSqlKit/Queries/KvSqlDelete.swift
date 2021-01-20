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
//  KvSqlDelete.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 10.05.2020.
//



// MARK: - The Fabrics

extension KvSQL {

    public typealias Delete = KvSqlDelete



    /// - Returns: A DELETE query builder.
    public static func delete(from table: KvSqlTable) -> KvSqlDelete {
        KvSqlDeleteStatement(from: table)
    }

}



// MARK: - KvSqlDelete

/// DELETE query builder.
///
/// - Note: Use `KvSQL.delete()` fabric methods to instantiate *KvSqlDelete*.
public protocol KvSqlDelete : KvSqlQuery, KvSqlWhere, KvSqlReturning { }



// MARK: - KvSqlDeleteStatement

class KvSqlDeleteStatement : KvSqlDelete, KvSqlWhereClause, KvSqlReturningClause {

    var table: KvSqlTable

    var `where`: KvSqlBoolRvalue?

    var returning: KvSqlRvalueList?



    init(from table: KvSqlTable) {
        self.table = table
    }

}



// MARK: : KvSqlQuery

extension KvSqlDeleteStatement {

    func write(to dest: inout String) {
        dest += "DELETE FROM "
        table.write(to: &dest)

        writeWhere(to: &dest)
        writeReturning(to: &dest)
    }

}
