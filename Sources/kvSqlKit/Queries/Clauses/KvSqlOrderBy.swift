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
//  KvSqlOrderBy.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 11.05.2020.
//

import kvKit



/// Provides methods for builders of queries having *ORDER BY* clause.
public protocol KvSqlOrderBy : AnyObject {

    /// Appends *ORDER BY* clause to the receiver.
    @discardableResult
    func orderBy(_ expresstions: KvSqlOrderByExpressionProtocol...) -> Self

}



// MARK: - KvSqlOrderByClause

protocol KvSqlOrderByClause : KvSqlOrderBy {

    var orderBy: [KvSqlOrderByExpressionProtocol]? { get set }

}



// MARK: Builder Methods

extension KvSqlOrderByClause {

    @discardableResult
    func orderBy(_ expresstions: KvSqlOrderByExpressionProtocol...) -> Self {
        guard !expresstions.isEmpty else { return KvDebug.pause(code: self, "Warning: list of expressions in ORDER BY clause is empty. Clause was ignored") }

        orderBy = expresstions

        return self
    }

}



// MARK: Writting

extension KvSqlOrderByClause {

    func writeOrderBy(to dest: inout String) {
        guard let orderBy = orderBy else { return }

        dest += " ORDER BY "

        KvSqlQueryKit.write(into: &dest, orderBy, separator: ",")
    }

}



// MARK: - KvSqlOrderByExpressionProtocol

public protocol KvSqlOrderByExpressionProtocol : KvSqlTokenSource { }



public extension KvSqlRvalue {

    /// Specifies ascending order options for the receiver.
    func asc(_ nullLocation: KvSqlOrderByExpression.NullLocation? = nil) -> KvSqlOrderByExpressionProtocol {
        KvSqlOrderByExpression(expression: self, order: .asc, nullLocation: nullLocation)
    }



    /// Specifies descending order options for the receiver.
    func desc(_ nullLocation: KvSqlOrderByExpression.NullLocation? = nil) -> KvSqlOrderByExpressionProtocol {
        KvSqlOrderByExpression(expression: self, order: .desc, nullLocation: nullLocation)
    }



    /// Specifies custom order options for the receiver.
    func using(_ operator: String, _ nullLocation: KvSqlOrderByExpression.NullLocation? = nil) -> KvSqlOrderByExpressionProtocol {
        KvSqlOrderByExpression(expression: self, order: .using(`operator`), nullLocation: nullLocation)
    }

}



// MARK: - KvSqlOrderByExpression

public struct KvSqlOrderByExpression : KvSqlOrderByExpressionProtocol {

    var expression: KvSqlRvalue
    var order: Order?
    var nullLocation: NullLocation?



    // MARK: : KvSqlTokenSource

    public func write(to dest: inout String) {
        expression.write(to: &dest)

        switch order {
        case .asc:
            dest += " ASC"
        case .desc:
            dest += " DESC"
        case .using(let `operator`):
            dest += " USING \(`operator`)"
        case nil:
            break
        }

        switch nullLocation {
        case .nullsFirst:
            dest += " NULLS FIRST"
        case .nullsLast:
            dest += " NULLS LAST"
        case nil:
            break
        }
    }



    // MARK: Order

    public enum Order { case asc, desc, using(_ `operator`: String) }



    // MARK: NullLocation

    public enum NullLocation { case nullsFirst, nullsLast }

}
