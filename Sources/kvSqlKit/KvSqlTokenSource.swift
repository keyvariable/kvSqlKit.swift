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
//  KvSqlTokenSource.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



// MARK: - KvSqlTokenSource

public protocol KvSqlTokenSource {

    func write(to dest: inout String)

}



// MARK: Auxliliaries

extension KvSqlTokenSource {

    public var sql: String {
        KvSqlQueryKit.sql(with: self.write(to:))
    }

}



// MARK: - KvSqlRawToken

struct KvSqlRawToken : KvSqlRvalue {

    init(_ token: String) {
        self.token = token
    }



    private let token: String



    // MARK: : KvSqlTokenSource

    func write(to dest: inout String) {
        dest += token
    }

}
