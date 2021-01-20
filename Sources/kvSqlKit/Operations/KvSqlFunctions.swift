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
//  KvSqlFunctions.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 26.05.2020.
//

import Foundation



extension KvSQL {

    public struct Fn { }

}



// MARK: Date and Time Functions

extension KvSQL.Fn {

    public static let currentDate: KvSqlRvalue = KvSqlRawRvalue("current_date")
    public static let currentTime: KvSqlRvalue = KvSqlRawRvalue("current_time")
    public static let currentTimestamp: KvSqlRvalue = KvSqlRawRvalue("current_timestamp")

    public static let now: KvSqlRvalue = KvSqlRawRvalue("now()")

}
