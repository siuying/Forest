//
//  RangeMapTests.swift
//  Forest
//
//  Created by Francis on 23/5/2020.
//  Copyright © 2020 Regexident. All rights reserved.
//

import Foundation
import Quick
import Nimble

import Forest

class TreeRangeMapTests: QuickSpec {
    typealias RangeMap = TreeRangeMap<Int, String>

    override func spec() {
        describe_put()
    }

    func describe_put() {
        describe("put") {
            context("Add non-overlapping range") {
                var treemap = RangeMap()
                treemap.put(3..<6, value: "1")
                treemap.put(8..<9, value: "2")
                treemap.put(11..<13, value: "3")
                treemap.put(13..<17, value: "4")

                it("should return their value") {
                    expect(treemap.get(1)).to(beNil())
                    expect(treemap.get(3)).to(equal("1"))
                    expect(treemap.get(4)).to(equal("1"))

                    expect(treemap.get(7)).to(beNil())
                    expect(treemap.get(8)).to(equal("2"))
                    expect(treemap.get(9)).to(beNil())
                    expect(treemap.get(10)).to(beNil())

                    expect(treemap.get(11)).to(equal("3"))
                    expect(treemap.get(13)).to(equal("4"))
                    expect(treemap.get(18)).to(beNil())
                }
            }
        }

        describe("put inside another range") {
            context("Add non-overlapping range") {
                var treemap = RangeMap()
                expect(treemap.get(4)).to(beNil())

                treemap.put(3..<20, value: "1")
                treemap.put(7..<11, value: "2")
                treemap.put(4..<8, value: "3")
                treemap.put(9..<10, value: "4")

                it("should return their value") {
                    expect(treemap.map { $0.range}).to(equal([3..<4, 4..<8, 8..<9, 9..<10, 10..<11, 11..<20]))
                    expect(treemap.map { $0.value}).to(equal(["1", "3", "2", "4", "2", "1"]))
                }
            }
        }

        describe("put should merge range") {
            context("Merge ranges") {
                var map = RangeMap()

                map.put(3..<20, value: "1")
                map.put(7..<11, value: "2")
                map.put(4..<8, value: "3")
                map.put(9..<10, value: "4")
                map.put(4..<19, value: "5")

                it("should return their value") {
                    expect(map.map { $0.range}).to(equal([3..<4, 4..<19, 19..<20]))
                    expect(map.map { $0.value}).to(equal(["1", "5", "1"]))
                }
            }
        }
    }
}
