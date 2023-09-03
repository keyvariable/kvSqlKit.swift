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
//  KvSqlLiterals.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



// MARK: - NULL

public struct KvSqlNull : KvSqlLogicalRvalue {

    public static let shared = KvSqlNull()



    // MARK: : KvSqlTokenSource

    public func write(to dest: inout String) { dest += "NULL" }

}



// MARK: KvSQL Integration

extension KvSQL {

    public static let null: KvSqlRvalue! = KvSqlNull.shared

}



// MARK: - DEFAULT

extension KvSQL {

    public static let `default`: KvSqlRvalue! = KvSqlRawRvalue("DEFAULT")

}



// MARK: - Boolean Literal

extension Bool : KvSqlBoolRvalue {

    public func write(to dest: inout String) { dest += self ? "TRUE" : "FALSE" }

}



// MARK: - Integer Literals

extension Int : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension Int8 : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension Int16 : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension Int32 : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension Int64 : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



// MARK: - Unsigned Integer Literals

extension UInt : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension UInt8 : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension UInt16 : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension UInt32 : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension UInt64 : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



// MARK: - Floating Point Literals

extension Float : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



extension Double : KvSqlRvalue {

    public func write(to dest: inout String) { dest += String(self) }

}



// MARK: - String Literal

extension String : KvSqlRvalue {

    public func write(to dest: inout String) { KvSqlWriteStringLiteral(to: &dest, self) }

}



extension Substring : KvSqlRvalue {

    public func write(to dest: inout String) { KvSqlWriteStringLiteral(to: &dest, self) }

}



fileprivate func KvSqlWriteStringLiteral<S>(to dest: inout String, _ string: S) where S : StringProtocol {
    dest += "'"
    defer { dest += "'" }

    var substring = string[string.startIndex...]

    while let singleQuoteIndex = substring.firstIndex(of: "'") {
        dest += substring[...singleQuoteIndex]
        dest += "'"

        substring = substring[substring.index(after:singleQuoteIndex)...]
    }

    if !substring.isEmpty {
        dest += substring
    }
}
