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
//  KvSqlReturning.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 09.05.2020.
//

import kvKit



/// Provides methods for builders of queries having *RETURNING* clause.
public protocol KvSqlReturning : AnyObject {

    /// Appends *RETURNING* clause to the receiver.
    @discardableResult
    func returning(_ fields: KvSqlRvalueList) -> Self

    /// Appends *RETURNING* clause to the receiver.
    @discardableResult
    func returning(_ fields: [KvSqlRvalue]) -> Self

    /// Appends *RETURNING* clause to the receiver.
    @discardableResult
    func returning(_ fields: KvSqlRvalue...) -> Self

}



// MARK: - KvSqlReturningClause

protocol KvSqlReturningClause : KvSqlReturning {

    var returning: KvSqlRvalueList? { get set }

}



// MARK: Builder Methods

extension KvSqlReturningClause {

    @discardableResult
    func returning(_ fields: KvSqlRvalueList) -> Self {
        returning = fields

        return self
    }



    @discardableResult
    func returning(_ fields: [KvSqlRvalue]) -> Self {
        guard !fields.isEmpty else { return KvDebug.pause(code: self, "Warning: list of fields in RETURNING clause is empty. Clause was ignored") }

        returning = KvSqlSimpleRvalueList(fields)

        return self
    }



    @discardableResult
    func returning(_ fields: KvSqlRvalue...) -> Self {
        guard !fields.isEmpty else { return KvDebug.pause(code: self, "Warning: list of fields in RETURNING clause is empty. Clause was ignored") }

        returning = KvSqlSimpleRvalueList(fields)

        return self
    }

}



// MARK: Writting

extension KvSqlReturningClause {

    func writeReturning(to dest: inout String) {
        guard let returning = returning else { return }

        dest += " RETURNING "
        KvSqlQueryKit.write(into: &dest, returning)
    }

}
