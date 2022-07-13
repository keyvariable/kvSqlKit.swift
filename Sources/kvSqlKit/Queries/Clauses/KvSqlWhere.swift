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
//  KvSqlWhere.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 09.05.2020.
//



/// Provides methods for builders of queries having *WHERE* clause.
public protocol KvSqlWhere : AnyObject {

    /// Appends *WHERE* clause to the receiver.
    @discardableResult
    func `where`(_ statement: KvSqlBoolRvalue) -> Self

}



// MARK: - KvSqlWhereClause

protocol KvSqlWhereClause : KvSqlWhere {

    var `where`: KvSqlBoolRvalue? { get set }

}



// MARK: Builder Methods

extension KvSqlWhereClause {

    @discardableResult
    func `where`(_ statement: KvSqlBoolRvalue) -> Self {
        `where` = statement

        return self
    }

}



// MARK: Writting

extension KvSqlWhereClause {

    func writeWhere(to dest: inout String) {
        guard let `where` = `where` else { return }

        dest += " WHERE "
        KvSqlQueryKit.write(into: &dest, `where`)
    }

}
