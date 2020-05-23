//
//  TreeMapTests.swift
//  Forest
//
//  Created by Francis on 23/5/2020.
//  Copyright © 2020 Regexident. All rights reserved.
//

import Quick
import Nimble

import Forest

class RBTreeMapTests: QuickSpec {

    override func spec() {
        self.describe_update()
        self.describe_delete()
        self.describe_floor()
        self.describe_lower()
        
    }

    func describe_update() {
        typealias TreeMap = RBTreeMap<Int, String>
        describe("update insert or update value") {
            context("(1, 3, 5)") {
                var treemap = TreeMap()
                treemap.update("three", forKey: 3)
                treemap.update("one", forKey: 1)
                treemap.update("four", forKey: 5)
                treemap.update("five", forKey: 5)

                it("add values") {
                    expect(treemap.get(1)).to(equal("one"))
                    expect(treemap.get(3)).to(equal("three"))
                }

                it("update values") {
                    expect(treemap.get(5)).to(equal("five"))
                }

                it("sort inserted value") {
                    expect(treemap.map { $0.value }).to(equal(["one", "three", "five"]))
                    expect(treemap.map { $0.key }).to(equal([1, 3, 5]))
                }
            }
        }
    }

    func describe_delete() {
        typealias TreeMap = RBTreeMap<Int, String>
        describe("delete value") {
            context("(1, 3, 5)") {
                var treemap = TreeMap()
                treemap.update("three", forKey: 3)
                treemap.update("one", forKey: 1)
                treemap.update("five", forKey: 5)
                _ = treemap.removeInPlace(5)

                it("removed values") {
                    expect(treemap.get(1)).to(equal("one"))
                    expect(treemap.get(3)).to(equal("three"))
                    expect(treemap.get(5)).to(beNil())
                }

                it("sort value") {
                    expect(treemap.map { $0.value }).to(equal(["one", "three"]))
                    expect(treemap.map { $0.key }).to(equal([1, 3]))
                }
            }
        }
    }

    func describe_floor() {
        typealias TreeMap = RBTreeMap<Int, String>
        describe("get floor value") {
            context("(1, 3, 4, 5, 6)") {
                var treemap = TreeMap()
                treemap.update("three", forKey: 3)
                treemap.update("one", forKey: 1)
                treemap.update("five", forKey: 5)
                treemap.update("six", forKey: 6)
                treemap.update("four", forKey: 4)

                it("should return floor entry") {
                    expect(treemap.floorEntry(0)?.key).to(beNil())
                    expect(treemap.floorEntry(1)?.key).to(equal(1))
                    expect(treemap.floorEntry(2)?.key).to(equal(1))
                    expect(treemap.floorEntry(3)?.key).to(equal(3))
                    expect(treemap.floorEntry(4)?.key).to(equal(4))
                    expect(treemap.floorEntry(5)?.key).to(equal(5))
                    expect(treemap.floorEntry(6)?.key).to(equal(6))
                    expect(treemap.floorEntry(7)?.key).to(equal(6))
                }

                it("should return floor value") {
                    expect(treemap.floorKey(0)).to(beNil())
                    expect(treemap.floorKey(1)).to(equal(1))
                    expect(treemap.floorKey(2)).to(equal(1))
                    expect(treemap.floorKey(3)).to(equal(3))
                    expect(treemap.floorKey(4)).to(equal(4))
                    expect(treemap.floorKey(5)).to(equal(5))
                    expect(treemap.floorKey(6)).to(equal(6))
                    expect(treemap.floorKey(7)).to(equal(6))
                }
            }
        }
    }

    func describe_lower() {
        typealias TreeMap = RBTreeMap<Int, String>
        describe("get lower value") {
            context("(1, 3, 4, 5, 6)") {
                var treemap = TreeMap()
                treemap.update("three", forKey: 3)
                treemap.update("one", forKey: 1)
                treemap.update("five", forKey: 5)
                treemap.update("six", forKey: 6)
                treemap.update("four", forKey: 4)

                it("should return floor entry") {
                    expect(treemap.lowerEntry(0)?.key).to(beNil())
                    expect(treemap.lowerEntry(1)?.key).to(beNil())
                    expect(treemap.lowerEntry(2)?.key).to(equal(1))
                    expect(treemap.lowerEntry(3)?.key).to(equal(1))
                    expect(treemap.lowerEntry(4)?.key).to(equal(3))
                    expect(treemap.lowerEntry(5)?.key).to(equal(4))
                    expect(treemap.lowerEntry(6)?.key).to(equal(5))
                    expect(treemap.lowerEntry(7)?.key).to(equal(6))
                }

                it("should return floor value") {
                    expect(treemap.lowerKey(0)).to(beNil())
                    expect(treemap.lowerKey(1)).to(beNil())
                    expect(treemap.lowerKey(2)).to(equal(1))
                    expect(treemap.lowerKey(3)).to(equal(1))
                    expect(treemap.lowerKey(4)).to(equal(3))
                    expect(treemap.lowerKey(5)).to(equal(4))
                    expect(treemap.lowerKey(6)).to(equal(5))
                    expect(treemap.lowerKey(7)).to(equal(6))
                }
            }
        }
    }

}
