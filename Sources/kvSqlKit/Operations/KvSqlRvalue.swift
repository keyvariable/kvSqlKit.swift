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
//  KvSqlRvalue.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



/// - Note: Conformace to *KvSqlTokenSource* is commented to prevent the warning.
public protocol KvSqlRvalue : /*KvSqlTokenSource , */KvSqlOrderByExpressionProtocol { }



/// NULL, TRUE, FALSE
public protocol KvSqlLogicalRvalue : KvSqlRvalue { }



/// TRUE, FALSE
public protocol KvSqlBoolRvalue : KvSqlLogicalRvalue { }



// MARK: - KvSqlRawRvalue

struct KvSqlRawRvalue : KvSqlRvalue {

    init(_ string: String) {
        self.string = string
    }



    private let string: String



    // MARK: : KvSqlRvalue

    func write(to dest: inout String) {
        dest += string
    }

}



// MARK: - KvSqlParenthesizedRvalue

struct KvSqlParenthesizedRvalue : KvSqlRvalue {

    init(_ rvalue: KvSqlRvalue) {
        underlying = rvalue
    }



    init(_ list: KvSqlRvalueList) {
        underlying = list
    }



    private let underlying: KvSqlTokenSource



    // MARK: : KvSqlTokenSource

    func write(to dest: inout String) {
        dest += "("
        underlying.write(to: &dest)
        dest += ")"
    }

}



// MARK: - KvSqlPrefixedRvalue

struct KvSqlPrefixedRvalue : KvSqlRvalue {

    init(prefix: String, _ rvalue: KvSqlRvalue) {
        self.prefix = prefix
        self.underlying = rvalue
    }



    private let prefix: String
    private let underlying: KvSqlRvalue



    // MARK: : KvSqlTokenSource

    func write(to dest: inout String) {
        dest += prefix
        underlying.write(to: &dest)
    }

}
