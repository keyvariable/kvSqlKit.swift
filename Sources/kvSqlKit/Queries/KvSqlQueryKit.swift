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
//  KvSqlQueryKit.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 20.04.2020.
//



class KvSqlQueryKit {

    static func sql(with body: (inout String) -> Void) -> String {
        var sql = ""

        body(&sql)

        return sql
    }



    static func write(into dest: inout String, _ source: KvSqlTokenSource) {
        source.write(to: &dest)
    }



    static func write(into dest: inout String, _ source: KvSqlTokenSource, prefix: String, postfix: String) {
        dest += prefix
        source.write(to: &dest)
        dest += postfix
    }



    static func write(into dest: inout String, _ source: KvSqlTokenSource, prefix: String) {
        dest += prefix
        source.write(to: &dest)
    }



    static func write(into dest: inout String, _ source: KvSqlTokenSource, postfix: String) {
        source.write(to: &dest)
        dest += postfix
    }



    static func write<S>(into dest: inout String, _ sources: S, separator: String) where S : Sequence, S.Element == KvSqlTokenSource {
        reduce(into: &dest, sources, separator: separator, accumulator: { $1.write(to: &$0) })
    }



    static func write<S>(into dest: inout String, _ sources: S, prefix: String, postfix: String, separator: String) where S : Sequence, S.Element == KvSqlTokenSource {
        reduce(into: &dest, sources, separator: separator, accumulator: { write(into: &$0, $1, prefix: prefix, postfix: postfix) })
    }



    static func write<S>(into dest: inout String, _ sources: S, prefix: String, separator: String) where S : Sequence, S.Element == KvSqlTokenSource {
        reduce(into: &dest, sources, separator: separator, accumulator: { write(into: &$0, $1, prefix: prefix) })
    }



    static func write<S>(into dest: inout String, _ sources: S, postfix: String, separator: String) where S : Sequence, S.Element == KvSqlTokenSource {
        reduce(into: &dest, sources, separator: separator, accumulator: { write(into: &$0, $1, postfix: postfix) })
    }



    static func write(into dest: inout String, _ sources: KvSqlTokenSource..., separator: String) {
        write(into: &dest, sources, separator: separator)
    }



    static func write(into dest: inout String, _ sources: KvSqlTokenSource..., prefix: String, postfix: String, separator: String) {
        write(into: &dest, sources, prefix: prefix, postfix: postfix, separator: separator)
    }



    static func write(into dest: inout String, _ sources: KvSqlTokenSource..., prefix: String, separator: String) {
        write(into: &dest, sources, prefix: prefix, separator: separator)
    }



    static func write(into dest: inout String, _ sources: KvSqlTokenSource..., postfix: String, separator: String) {
        write(into: &dest, sources, postfix: postfix, separator: separator)
    }



    static func reduce<S>(into dest: inout String, _ elements: S, separator: String, accumulator: (inout String, S.Element) -> Void) where S : Sequence {
        var iterator = elements.makeIterator()

        do {
            guard let first = iterator.next() else { return }

            accumulator(&dest, first)
        };

        while let other = iterator.next() {
            dest += separator
            accumulator(&dest, other)
        }
    }

}
