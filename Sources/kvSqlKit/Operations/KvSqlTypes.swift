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
//  KvSqlTypes.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 11.06.2020.
//

import Foundation



// MARK: - KvSqlPoint

public protocol KvSqlPoint : KvSqlRvalue {

    var x: Double { get }
    var y: Double { get }

}



// MARK: : KvSqlRvalue

extension KvSqlPoint {

    public func write(to dest: inout String) {
        dest += "(\(x),\(y))"
    }

}



#if canImport(simd)

import simd



// MARK: SIMD2<Double> : KvSqlPoint

extension SIMD2 : KvSqlPoint where Scalar == Double { }



// MARK: SIMD2<Double> Explicit conformances

extension SIMD2 : KvSqlTokenSource where Scalar == Double { }

extension SIMD2 : KvSqlRvalue where Scalar == Double { }

extension SIMD2 : KvSqlOrderByExpressionProtocol where Scalar == Double { }

#endif // canImport(simd)



// MARK: KvSQL.Point

extension KvSQL {

    struct Point : KvSqlPoint {

        var x: Double
        var y: Double

    }

}
