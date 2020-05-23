//
//  RangeMapEntry.swift
//  Forest
//
//  Created by Francis on 23/5/2020.
//  Copyright © 2020 Regexident. All rights reserved.
//

import Foundation

public final class RangeMapEntry<Key: Comparable, Value>: CustomStringConvertible {
    public let range: Range<Key>
    public let value: Value

    public init(lowerBound: Key, upperBound: Key, value: Value) {
        self.range = lowerBound..<upperBound
        self.value = value
    }

    public init(range: Range<Key>, value: Value) {
        self.range = range
        self.value = value
    }

    public func contains(_ key: Key) -> Bool {
        return range.contains(key)
    }

    public func contains(_ another: Range<Key>) -> Bool {
        return (another.lowerBound >= range.lowerBound && another.lowerBound < range.upperBound) ||
            (another.upperBound <= range.upperBound && another.upperBound > range.lowerBound) ||
            (another.lowerBound >= range.lowerBound && another.upperBound < range.upperBound) ||
            (range.lowerBound >= another.lowerBound && range.upperBound < another.upperBound)
    }

    public var upperBound: ClosedRange<Key>.Bound {
        return range.upperBound
    }

    public var lowerBound: ClosedRange<Key>.Bound {
        return range.lowerBound
    }

    public var description: String {
        return "\(range):\(value)"
    }
}
