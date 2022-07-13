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
//  KvSqlLimit.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 12.05.2020.
//



/// Provides methods for builders of queries having *LIMIT* clause.
public protocol KvSqlLimit : AnyObject {

    /// Appends *LIMIT* clause to the receiver.
    @discardableResult
    func limit(_ expression: KvSqlRvalue) -> Self

}



// MARK: - KvSqlLimitClause

protocol KvSqlLimitClause : KvSqlLimit {

    var limit: KvSqlRvalue? { get set }

}



// MARK: Builder Methods

extension KvSqlLimitClause {

    @discardableResult
    func limit(_ expression: KvSqlRvalue) -> Self {
        limit = expression

        return self
    }

}



// MARK: Writting

extension KvSqlLimitClause {

    func writeLimit(to dest: inout String) {
        guard let limit = limit else { return }

        dest += " LIMIT "
        limit.write(to: &dest)
    }

}
