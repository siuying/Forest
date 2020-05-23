//
//  TreeMapEntry.swift
//  Forest
//
//  Created by Francis on 23/5/2020.
//  Copyright © 2020 Regexident. All rights reserved.
//

import Foundation

public protocol TreeMapEntryType: Comparable {
    associatedtype Key: Comparable
    associatedtype Value

    var key: Key { get }
    var value: Value { get set }
}

public final class TreeMapEntry<Key: Comparable, Value>: TreeMapEntryType, CustomStringConvertible {
    public let key: Key
    public var value: Value

    public init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }

    public static func < (lhs: TreeMapEntry, rhs: TreeMapEntry) -> Bool {
        return lhs.key < rhs.key
    }

    public static func == (lhs: TreeMapEntry<Key, Value>, rhs: TreeMapEntry<Key, Value>) -> Bool {
        return lhs.key == rhs.key
    }

    public var description: String {
        return "\(key):\(value)"
    }
}

// MARK: TreeMapEntry Extension

extension BinarySearchTreeType where Element: TreeMapEntryType {
    public func get(_ element: Element.Key) -> Element? {
        return analysis(branch: { l, e, r in
            if element < e.key {
                return l.get(element)
            } else if element > e.key {
                return r.get(element)
            } else {
                return e
            }
        }, leaf: {
            nil
        })
    }

    public func contains(_ element: Element.Key) -> Bool {
        return self.get(element) != nil
    }

    public func lower(_ element: Element.Key) -> Element? {
        return analysis(branch: { l, e, r in
            if element > e.key {
                if let next = r.lower(element) {
                    return next
                } else {
                    return e
                }
            } else {
                return l.lower(element)
            }
        }, leaf: {
            nil
        })
    }

    public func floor(_ element: Element.Key) -> Element? {
        return analysis(branch: { l, e, r in
            if element > e.key {
                if let next = r.floor(element) {
                    return next
                } else {
                    return e
                }
            } else if element == e.key {
                return e
            } else {
                return l.floor(element)
            }
        }, leaf: {
            nil
        })
    }
}
