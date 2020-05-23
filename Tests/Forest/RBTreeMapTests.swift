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
    }

    func describe_update() {
        typealias TreeMap = RBTreeMap<Int, String>
        describe("update insert or update value") {
            context("(1, 3, 5)") {
                var treemap = TreeMap()
                it("it sort inserted values") {
                    treemap.update("one", forKey: 1)
                    treemap.update("three", forKey: 3)
                    treemap.update("four", forKey: 5)
                    treemap.update("five", forKey: 5)
                    expect(treemap.map { $0.value }).to(equal(["one", "three", "five"]))
                    expect(treemap.map { $0.key }).to(equal([1, 3, 5]))
                }
            }
        }
    }
}
