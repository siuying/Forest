//
//  RangeMap.swift
//  Forest
//
//  Created by Francis on 23/5/2020.
//  Copyright © 2020 Regexident. All rights reserved.
//

import Foundation

public protocol RangeMapType: CustomStringConvertible, Sequence {
    associatedtype Key: Comparable
    associatedtype Value

    mutating func put(_ key: Range<Key>, value: Value)

    func get(_ key: Key) -> Value?

    mutating func remove(_ key: Range<Key>)
}

public struct TreeRangeMap<Key: Comparable, Value>: RangeMapType, CustomStringConvertible {
    var entriesByLowerBound: RBTreeMap<Key, RangeMapEntry<Key, Value>>

    public init() {
        entriesByLowerBound = RBTreeMap()
    }

    public mutating func put(_ range: Range<Key>, value: Value) {
        if range.isEmpty {
            return
        }

        remove(range)
        entriesByLowerBound.update(RangeMapEntry(range: range, value: value), forKey: range.lowerBound)
    }

    public mutating func remove(_ rangeToRemove: Range<Key>) {
        if rangeToRemove.isEmpty {
            return
        }

        if let mapEntryBelowToTruncate = entriesByLowerBound.lowerEntry(rangeToRemove.lowerBound) {
            let rangeMapEntry = mapEntryBelowToTruncate.value
            // ([
            if rangeMapEntry.upperBound > rangeToRemove.lowerBound {
                // ([)
                if rangeMapEntry.upperBound > rangeToRemove.upperBound {
                    // ([]), so insert the range ]) back into map
                    putRangeMapEntry(rangeToRemove.upperBound, rangeMapEntry.upperBound, value: mapEntryBelowToTruncate.value.value)
                }

                // overwrite mapEntryBelowToTruncate with a truncated range
                putRangeMapEntry(rangeMapEntry.lowerBound, rangeToRemove.lowerBound, value: mapEntryBelowToTruncate.value.value)
            }
        }

        if let mapEntryAboveToTruncate = entriesByLowerBound.lowerEntry(rangeToRemove.upperBound) {
            let rangeMapEntry = mapEntryAboveToTruncate.value
            // (]
            if rangeMapEntry.upperBound > rangeToRemove.upperBound {
                // (]). since we dealt with truncating below already, we know [(])
                putRangeMapEntry(rangeToRemove.upperBound,
                                 rangeMapEntry.upperBound,
                                 value: mapEntryAboveToTruncate.value.value)
            }
        }

        // clear submap rangeToRemove
        entriesByLowerBound.filter {
            $0.value.contains(rangeToRemove)
        }.forEach {
            _ = entriesByLowerBound.removeInPlace($0.value.lowerBound)
        }
    }

    mutating func putRangeMapEntry(_ lowerBound: Key, _ upperBound: Key, value: Value) {
        entriesByLowerBound.update(RangeMapEntry(lowerBound: lowerBound, upperBound: upperBound, value: value), forKey: lowerBound)
    }

    public func get(_ key: Key) -> Value? {
        return getEntry(key)?.value
    }

    public func getEntry(_ key: Key) -> RangeMapEntry<Key, Value>? {
        let entry = entriesByLowerBound.floorEntry(key)
        if let entry = entry, entry.value.contains(key) {
            return entry.value
        } else {
            return nil
        }
    }

    public var description: String {
        return entriesByLowerBound.description
    }
}

extension TreeRangeMap: Sequence {
    public func makeIterator() -> AnyIterator<RangeMapEntry<Key, Value>> {
        let treeIterator = entriesByLowerBound.makeIterator()
        return AnyIterator {
            guard let next = treeIterator.next() else { return nil }
            return next.value
        }
    }
}

extension TreeRangeMap: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element

    init<S: Sequence>(_ sources: S) where S.Element == Element {
        self.init()
        for item in sources {
            put(item.range, value: item.value)
        }
    }

    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension TreeRangeMap {
    public func toArray() -> [RangeMapEntry<Key, Value>] {
        return Array(self)
    }
}
