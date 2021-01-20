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
//  KvSqlOperator.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



// MARK: - KvSqlOperatorPrecedence

enum KvSqlOperatorPrecedence : UInt, Comparable {

    /// According to *PostgreSQL 12*.
    case or = 1, and, not, `is`, comparison, `in`, other, addition, multiplication, exponentiation, sign, `subscript`, typecast, separator, dot



    // MARK: : Comparable

    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }



    static func <=(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue <= rhs.rawValue
    }

}



// MARK: - KvSqlOperator

protocol KvSqlOperator : KvSqlRvalue {

    var precedence: KvSqlOperatorPrecedence { get }

}



// MARK: - Parentheses

fileprivate func KvSqlParenthesized(lhs: KvSqlRvalue, ifNeededFor precedence: KvSqlOperatorPrecedence) -> KvSqlRvalue {
    guard let operandPrecedence = (lhs as? KvSqlOperator)?.precedence else { return lhs }

    return operandPrecedence < precedence ? KvSqlParenthesizedRvalue(lhs) : lhs
}



fileprivate func KvSqlParenthesized(rhs: KvSqlRvalue, ifNeededFor precedence: KvSqlOperatorPrecedence) -> KvSqlRvalue {
    guard let operandPrecedence = (rhs as? KvSqlOperator)?.precedence else { return rhs }

    return operandPrecedence <= precedence ? KvSqlParenthesizedRvalue(rhs) : rhs
}



// MARK: - Typed Operators

protocol KvSqlLogicalOperator : KvSqlLogicalRvalue { }

protocol KvSqlBooleanOperator : KvSqlBoolRvalue { }



// MARK: - KvSqlPrefixOperator

struct KvSqlPrefixOperator : KvSqlOperator {

    init(_ op: String, _ rhs: KvSqlRvalue, precedence: KvSqlOperatorPrecedence) {
        self.op = op
        self.rhs = KvSqlParenthesized(rhs: rhs, ifNeededFor: precedence)
        self.precedence = precedence
    }



    private let op: String
    private let rhs: KvSqlRvalue

    let precedence: KvSqlOperatorPrecedence



    // MARK: KvSqlTokenSource

    func write(to dest: inout String) {
        dest += op
        rhs.write(to: &dest)
    }

}



// MARK: - KvSqlPostfixOperator

struct KvSqlPostfixOperator : KvSqlOperator {

    init(_ lhs: KvSqlRvalue, _ op: String, precedence: KvSqlOperatorPrecedence) {
        self.lhs = KvSqlParenthesized(lhs: lhs, ifNeededFor: precedence)
        self.op = op
        self.precedence = precedence
    }



    private let lhs: KvSqlRvalue
    private let op: String

    let precedence: KvSqlOperatorPrecedence



    // MARK: KvSqlTokenSource

    func write(to dest: inout String) {
        lhs.write(to: &dest)
        dest += op
    }

}



// MARK: - KvSqlInfixOperator

struct KvSqlInfixOperator : KvSqlOperator {

    init(_ lhs: KvSqlRvalue, _ op: String, _ rhs: KvSqlRvalue, precedence: KvSqlOperatorPrecedence) {
        self.lhs = KvSqlParenthesized(lhs: lhs, ifNeededFor: precedence)
        self.op = op
        self.rhs = KvSqlParenthesized(rhs: rhs, ifNeededFor: precedence)
        self.precedence = precedence
    }



    private let lhs: KvSqlRvalue
    private let op: String
    private let rhs: KvSqlRvalue

    let precedence: KvSqlOperatorPrecedence



    // MARK: KvSqlTokenSource

    func write(to dest: inout String) {
        lhs.write(to: &dest)
        dest += op
        rhs.write(to: &dest)
    }

}



extension KvSqlInfixOperator : KvSqlLogicalOperator, KvSqlBooleanOperator { }



// MARK: - Comparison Operators

public func ==(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(lhs, rhs is KvSqlLogicalRvalue ? " IS " : "=", rhs, precedence: .comparison)
}



@inlinable
public func ==(lhs: KvSqlRvalue, rhs: KvSqlRvalue?) -> KvSqlBoolRvalue {
    rhs != nil
        ? lhs == rhs!
        : lhs == KvSQL.null
}



public func !=(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(lhs, rhs is KvSqlLogicalRvalue ? " IS NOT " : "<>", rhs, precedence: .comparison)
}



@inlinable
public func !=(lhs: KvSqlRvalue, rhs: KvSqlRvalue?) -> KvSqlBoolRvalue {
    rhs != nil
        ? lhs != rhs!
        : lhs != KvSQL.null
}



public func <(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(lhs, "<", rhs, precedence: .comparison)
}



public func <=(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(lhs, "<=", rhs, precedence: .comparison)
}



public func >(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(lhs, ">", rhs, precedence: .comparison)
}



public func >=(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(lhs, ">=", rhs, precedence: .comparison)
}



// MARK: - Logical Operators

public func &&(lhs: KvSqlBoolRvalue, rhs: KvSqlBoolRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(lhs, " AND ", rhs, precedence: .and)
}



public func ||(lhs: KvSqlBoolRvalue, rhs: KvSqlBoolRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(lhs, " OR ", rhs, precedence: .or)
}



// TODO: Implement NOT



// MARK: - Mathematical Operators

public func +(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "+", rhs, precedence: .addition)
}



public func -(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "-", rhs, precedence: .addition)
}



public func *(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "*", rhs, precedence: .multiplication)
}



public func /(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "/", rhs, precedence: .multiplication)
}



public func %(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "%", rhs, precedence: .multiplication)
}



prefix operator |/

prefix public func |/(rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlPrefixOperator("|/", rhs, precedence: .other)
}



prefix operator ||/

prefix public func ||/(rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlPrefixOperator("||/", rhs, precedence: .other)
}



prefix operator !!

prefix public func !!(rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlPrefixOperator("!!", rhs, precedence: .other)
}



public func &(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "&", rhs, precedence: .other)
}



public func |(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "|", rhs, precedence: .other)
}



public func ^(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "#", rhs, precedence: .other)
}



prefix public func ~(rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlPrefixOperator("~", rhs, precedence: .other)
}



public func <<(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, "<<", rhs, precedence: .other)
}



public func >>(lhs: KvSqlRvalue, rhs: KvSqlRvalue) -> KvSqlRvalue {
    KvSqlInfixOperator(lhs, ">>", rhs, precedence: .other)
}



// MARK: - Array Operators

public func ~=<S>(lhs: S, rhs: KvSqlRvalue) -> KvSqlBoolRvalue where S : Sequence, S.Element == KvSqlRvalue {
    KvSqlInfixOperator(rhs, "IN", KvSqlParenthesizedRvalue(KvSqlSimpleRvalueList(lhs)), precedence: .in)
}



public func ~=(lhs: KvSqlArgumentRvalue, rhs: KvSqlRvalue) -> KvSqlBoolRvalue {
    KvSqlInfixOperator(rhs, "IN", lhs, precedence: .in)
}
