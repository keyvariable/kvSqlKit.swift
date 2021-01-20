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
//  KvSqlColumn.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



// MARK: - KvSqlColumnProtocol

public protocol KvSqlColumnProtocol : KvSqlRvalue {

    var id: String { get }

    var type: KvSqlColumnDataType { get }

    var `default`: KvSqlColumnDefault? { get }

    var constraints: [KvSqlColumnConstraint] { get }



    func writeLastPathComponent(to dest: inout String)

}



// MARK: - KvSqlColumnDefault

public enum KvSqlColumnDefault {
    case implicit, explicit(KvSqlRvalue)
}



// MARK: - KvSqlColumnConstraint

public enum KvSqlColumnConstraint : KvSqlTokenSource, Hashable {

    case notNull
    case primaryKey
    case unique


    // MARK: : KvSqlTokenSource

    public func write(to dest: inout String) {
        switch self {
        case .notNull:
            dest += "NOT NULL"
        case .primaryKey:
            dest += "PRIMARY KEY"
        case .unique:
            dest += "UNIQUE"
        }
    }

}



// MARK: - KvSqlColumnDataType

public enum KvSqlColumnDataType : KvSqlTokenSource, Hashable {

    case bigint
    case bigserial
    case boolean
    case char(UInt)
    case date
    case decimal(UInt?, UInt?)
    case double
    case integer
    case numeric(UInt?, UInt?)
    case point
    case real
    case serial
    case smallint
    case smallserial
    case text
    case time
    case timestamp
    case timestampWithTimeZone
    case timeWithTimeZone
    case varchar(UInt)



    // MARK: : KvSqlTokenSource

    public func write(to dest: inout String) {
        switch self {
        case .bigint:
            dest += "bigint"

        case .bigserial:
            dest += "bigserial"

        case .boolean:
            dest += "boolean"

        case .char(let n):
            dest += "char(\(n))"

        case .date:
            dest += "date"

        case .decimal(.some(let precision), .some(let scale)):
            dest += "decimal(\(precision),\(scale))"
        case .decimal(.some(let precision), .none):
            dest += "decimal(\(precision))"
        case .decimal(.none, _):
            dest += "decimal"

        case .double:
            dest += "double precision"

        case .integer:
            dest += "integer"

        case .numeric(.some(let precision), .some(let scale)):
            dest += "numeric(\(precision),\(scale))"
        case .numeric(.some(let precision), .none):
            dest += "numeric(\(precision))"
        case .numeric(.none, _):
            dest += "numeric"

        case .point:
            dest += "point"

        case .real:
            dest += "real"

        case .serial:
            dest += "serial"

        case .smallint:
            dest += "smallint"

        case .smallserial:
            dest += "smallserial"

        case .text:
            dest += "text"

        case .time:
            dest += "time"

        case .timestamp:
            dest += "timestamp"

        case .timestampWithTimeZone:
            dest += "timestamp with time zone"
            
        case .timeWithTimeZone:
            dest += "time with time zone"

        case .varchar(let n):
            dest += "varchar(\(n))"
        }
    }

}



// MARK: - KvSqlColumn

public struct KvSqlColumn<Table> : KvSqlColumnProtocol
    where Table : KvSqlTable
{
    public typealias Table = Table

    public typealias DataType = KvSqlColumnDataType
    public typealias Default = KvSqlColumnDefault
    public typealias Constraint = KvSqlColumnConstraint



    public let id: String

    public let type: DataType

    public let `default`: Default?

    public let constraints: [Constraint]



    public init(_ id: String, of type: DataType, default: Default?, constraints: [Constraint]) {
        self.init(id, type, `default` ?? .explicit(KvSQL.null), constraints)
    }



    public init(_ id: String, of type: DataType, default: Default?, constraints: Constraint...) {
        self.init(id, type, `default` ?? .explicit(KvSQL.null), constraints)
    }



    public init(_ id: String, of type: DataType, default: KvSqlRvalue, constraints: [Constraint]) {
        self.init(id, type, .explicit(`default`), constraints)
    }



    public init(_ id: String, of type: DataType, default: KvSqlRvalue, constraints: Constraint...) {
        self.init(id, type, .explicit(`default`), constraints)
    }



    public init(_ id: String, of type: DataType, constraints: [Constraint]) {
        self.init(id, type, nil, constraints)
    }



    public init(_ id: String, of type: DataType, constraints: Constraint...) {
        self.init(id, type, nil, constraints)
    }



    private init(_ id: String, _ type: DataType, _ default: Default?, _ constraints: [Constraint]) {
        self.id = id
        self.type = type
        self.default = `default`
        self.constraints = constraints
    }

}



// MARK: : KvSqlColumnProtocol

extension KvSqlColumn {

    public func writeLastPathComponent(to dest: inout String) { dest += "\"\(id)\"" }

}



// MARK: : KvSqlRvalue

extension KvSqlColumn : KvSqlRvalue {

    public func write(to dest: inout String) { dest += "\"\(Table.id)\".\"\(id)\"" }

}



// MARK: : Equatable

extension KvSqlColumn : Equatable {

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.type == rhs.type
    }

}



// MARK: : Hashable

extension KvSqlColumn : Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
    }

}



// MARK: - KvSQL Integration

extension KvSQL {

    public typealias Column = KvSqlColumn

}
