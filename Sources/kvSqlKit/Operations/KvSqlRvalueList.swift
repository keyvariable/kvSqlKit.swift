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
//  KvSqlRvalueList.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



// MARK: - KvSqlRvalueList

public protocol KvSqlRvalueList : KvSqlTokenSource { }



// MARK: - KvSqlSimpleRvalueList

struct KvSqlSimpleRvalueList : KvSqlRvalueList {

    init<S>(_ rvalues: S) where S : Sequence, S.Element == KvSqlRvalue {
        self.rvalues = .init(rvalues.lazy.map { $0 })
    }



    init(_ rvalues: KvSqlRvalue...) {
        self.rvalues = .init(rvalues)
    }



    /// - Note: Underlying type is *KvSqlTokenSource* for performance reasons.
    private let rvalues: AnySequence<KvSqlTokenSource>



    // MARK: : KvSqlTokenSource

    func write(to dest: inout String) {
        KvSqlQueryKit.write(into: &dest, rvalues, separator: ",")
    }

}



// MARK: - KvSqlPrefixedRvalueList

struct KvSqlPrefixedRvalueList : KvSqlRvalueList {

    init<S>(prefix: String, _ rvalues: S) where S : Sequence, S.Element == KvSqlTokenSource {
        self.prefix = prefix
        self.rvalues = .init(rvalues)
    }



    init(prefix: String, _ rvalues: KvSqlTokenSource...) {
        self.prefix = prefix
        self.rvalues = .init(rvalues)
    }



    private let prefix: String

    /// - Note: Underlying type is *KvSqlTokenSource* for performance reasons.
    private let rvalues: AnySequence<KvSqlTokenSource>



    // MARK: : KvSqlTokenSource

    func write(to dest: inout String) {
        KvSqlQueryKit.write(into: &dest, rvalues, prefix: prefix, separator: ",")
    }

}
