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
//  KvSqlArguments.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 21.04.2020.
//

import Foundation



prefix operator %



/// An operator to declare dynamic querry arguemnts in printf style: %1, %2 etc.
public prefix func %(index: UInt) -> KvSqlArgumentRvalue {
    .init(index)
}



public struct KvSqlArgumentRvalue : KvSqlRvalue {

    let index: UInt



    init(_ index: UInt) {
        self.index = index
    }



    // MARK: : KvSqlTokenSource

    public func write(to dest: inout String) {
        dest += "$\(index)"
    }

}
