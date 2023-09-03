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
//  KvSqlKitTests.swift
//  kvSqlKit
//
//  Created by Svyatoslav Popov on 12.05.2020.
//


import XCTest

@testable import kvSqlKit



final class KvSqlKitTests : XCTestCase {

    // MARK: - testCreateTable()

    func testCreateTable() {
        XCTAssertEqual(
            KvSQL.create(table: items).sql,
            "CREATE TABLE \"items\"(\"sku\" serial DEFAULT NOT NULL PRIMARY KEY,\"count\" integer NOT NULL,\"label\" varchar(128) NOT NULL,\"comment\" text)"
        )
    }



    // MARK: - testDelete()

    func testDelete() {
        // Simple test.
        XCTAssertEqual(
            KvSQL.delete(from: items).sql,
            "DELETE FROM \"items\""
        )

        // Complex test.
        XCTAssertEqual(
            KvSQL.delete(from: items).where(items.count == 0).returning(items.sku).sql,
            "DELETE FROM \"items\" WHERE \"items\".\"count\"=0 RETURNING \"items\".\"sku\""
        )
    }



    // MARK: - testInsert()

    func testInsert() {
        let optionalString: (some: String?, none: String?) = ("some", nil)

        // Single row insertion.
        XCTAssertEqual(
            KvSQL.insert(into: items, values: [ KvSQL.default, 50, "Apple iPhone", KvSQL.null ]).sql,
            "INSERT INTO \"items\" VALUES (DEFAULT,50,'Apple iPhone',NULL)"
        )

        // Batch row insertion.
        XCTAssertEqual(
            KvSQL.insert(into: items, items.count, items.label,
                         values: [ [ 35, "Apple iPad Air" ],
                                   [ 15, "Apple iPad Pro" ] ]).sql,
            "INSERT INTO \"items\" (\"\(items.count.id)\",\"\(items.label.id)\") VALUES (35,'Apple iPad Air'),(15,'Apple iPad Pro')"
        )

        // Optionals
        XCTAssertEqual(
            KvSQL.insert(into: items, values: [ KvSQL.default, 50, "Apple MacBook Pro 16", optionalString.none ]).sql,
            "INSERT INTO \"items\" VALUES (DEFAULT,50,'Apple MacBook Pro 16',NULL)"
        )

        // RETURNING.
        XCTAssertEqual(
            KvSQL.insert(into: items, values: [ KvSQL.default, 50, "Apple iPhone", KvSQL.null ]).returning(items.*).sql,
            "INSERT INTO \"items\" VALUES (DEFAULT,50,'Apple iPhone',NULL) RETURNING \"items\".*"
        )
        XCTAssertEqual(
            KvSQL.insert(into: items, values: [ KvSQL.default, 50, "Apple iPhone", KvSQL.null ]).returning(items.sku, items.label).sql,
            "INSERT INTO \"items\" VALUES (DEFAULT,50,'Apple iPhone',NULL) RETURNING \"items\".\"sku\",\"items\".\"label\""
        )
    }



    // MARK: - testSelect()

    func testSelect() {
        let label = "label"
        let optionalString: (some: String?, none: String?) = ("some", nil)

        // Value substitution.
        XCTAssertEqual(
            KvSQL.select(Float.pi, 1 - 2, 2 * 2 + 2, 2 * 3 == 6, true || false, label == "ABC").sql,
            "SELECT \(Float.pi),-1,6,TRUE,TRUE,FALSE"
        )

        // NULL Comparison.
        XCTAssertEqual(
            KvSQL.select(2 == KvSQL.null, "2" != KvSQL.null).sql,
            "SELECT 2 IS NULL,'2' IS NOT NULL"
        )

        // Escaping of Single Quotes.
        XCTAssertEqual(
            KvSQL.select("Dianne's MBPro 16''").sql,
            "SELECT 'Dianne''s MBPro 16'''''"
        )

        // ==, IS
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).where(items.label == label || items.label == optionalString.some || items.label == optionalString.none).sql,
            "SELECT \"items\".* FROM \"items\" WHERE \"items\".\"label\"='label' OR \"items\".\"label\"='some' OR \"items\".\"label\" IS NULL"
        )

        // !=, IS NOT
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).where(items.label != label || items.label != optionalString.some || items.label != optionalString.none).sql,
            "SELECT \"items\".* FROM \"items\" WHERE \"items\".\"label\"<>'label' OR \"items\".\"label\"<>'some' OR \"items\".\"label\" IS NOT NULL"
        )

        // Default Precedence.
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).where(items.label == "A" || items.label == "B" && items.label == "C").sql,
            "SELECT \"items\".* FROM \"items\" WHERE \"items\".\"label\"='A' OR \"items\".\"label\"='B' AND \"items\".\"label\"='C'"
        )
        // Explicit Precedence.
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).where((items.label == "A" || items.label == "B") && items.label == "C").sql,
            "SELECT \"items\".* FROM \"items\" WHERE (\"items\".\"label\"='A' OR \"items\".\"label\"='B') AND \"items\".\"label\"='C'"
        )

        // Default Associativity.
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).where(items.label == "A" || items.label == "B" || items.label == "C").sql,
            "SELECT \"items\".* FROM \"items\" WHERE \"items\".\"label\"='A' OR \"items\".\"label\"='B' OR \"items\".\"label\"='C'"
        )
        // Explicit Associativity.
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).where((items.label == "A" || items.label == "B") || items.label == "C").sql,
            "SELECT \"items\".* FROM \"items\" WHERE \"items\".\"label\"='A' OR \"items\".\"label\"='B' OR \"items\".\"label\"='C'"
        )
        // Explicit Associativity.
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).where(items.label == "A" || (items.label == "B" || items.label == "C")).sql,
            "SELECT \"items\".* FROM \"items\" WHERE \"items\".\"label\"='A' OR (\"items\".\"label\"='B' OR \"items\".\"label\"='C')"
        )

        // Dynalic Arguments
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).where(items.label == %1 && items.count >= %2).sql,
            "SELECT \"items\".* FROM \"items\" WHERE \"items\".\"label\"=$1 AND \"items\".\"count\">=$2"
        )

        // ORDER BY
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).orderBy(items.label).sql,
            "SELECT \"items\".* FROM \"items\" ORDER BY \"items\".\"label\""
        )
        // ORDER BY: ASC, DESC, NULLS {FIRST|LAST}
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).orderBy(items.count.desc(.nullsFirst), items.label.asc(.nullsLast)).sql,
            "SELECT \"items\".* FROM \"items\" ORDER BY \"items\".\"count\" DESC NULLS FIRST,\"items\".\"label\" ASC NULLS LAST"
        )
        // ORDER BY: USING
        XCTAssertEqual(
            KvSQL.select(items.*, from: items).orderBy(items.comment.using("<")).sql,
            "SELECT \"items\".* FROM \"items\" ORDER BY \"items\".\"comment\" USING <"
        )
    }



    // MARK: - testUpdate()

    func testUpdate() {
        // Basic test.
        XCTAssertEqual(
            KvSQL.update(items, set: items.comment, to: "—").sql,
            "UPDATE \"items\" SET \"comment\"='—'"
        )

        // Default.
        XCTAssertEqual(
            KvSQL.update(items, set: items.sku, to: KvSQL.default).sql,
            "UPDATE \"items\" SET \"sku\"=DEFAULT"
        )

        // NULL.
        XCTAssertEqual(
            KvSQL.update(items, set: items.comment, to: nil).sql,
            "UPDATE \"items\" SET \"comment\"=NULL"
        )

        // Where clause.
        XCTAssertEqual(
            KvSQL.update(items, set: items.count, to: 70).where(items.sku == 2).sql,
            "UPDATE \"items\" SET \"count\"=70 WHERE \"items\".\"sku\"=2"
        )

        // Multiple assignments, column to the right hand side, returning clause.
        _ = { assignments in
            let assignmentSQL = assignments.map({ assignment in
                var s = ""; assignment.key.writeLastPathComponent(to: &s); s += "="; (assignment.value ?? KvSQL.null).write(to: &s); return s
            }).joined(separator: ",")

            XCTAssertEqual(
                KvSQL.update(items, set: assignments).where(items.sku == 2).returning(items.sku, items.count).sql,
                "UPDATE \"items\" SET \(assignmentSQL) WHERE \"items\".\"sku\"=2 RETURNING \"items\".\"sku\",\"items\".\"count\""
            )
        }([ items.sku: KvSQL.default, items.count: items.count + 25, items.comment: "New shipment" ])
    }



    // MARK: - Auxiliaries

    private let items = Items()



    // MARK: - .Items

    /// A test table.
    private struct Items : KvSqlTable {

        static var id = "items"


        let sku = Column("sku", of: .serial, default: .implicit, constraints: [ .notNull, .primaryKey ])
        let count = Column("count", of: .integer, constraints: [ .notNull ])

        let label = Column("label", of: .varchar(128), constraints: [ .notNull ])

        let comment = Column("comment", of: .text)

    }

}
