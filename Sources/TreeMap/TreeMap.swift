//
//  TreeMap.swift
//  Forest
//
//  Created by Francis on 23/5/2020.
//  Copyright © 2020 Regexident. All rights reserved.
//

import Foundation

public protocol TreeMapType: CustomStringConvertible, Sequence where Tree.Element == TreeMapEntry<Key, Value> {
    associatedtype Tree: BinarySearchTreeType & MutableBinarySearchTreeType
    associatedtype Key: Comparable
    associatedtype Value

    mutating func update(_ value: Value, forKey key: Key)

    func get(_ key: Key) -> Value?

    mutating func removeInPlace(_ key: Key) -> TreeMapEntry<Key, Value>?

    func floorEntry(_ key: Key) -> TreeMapEntry<Key, Value>?

    func floorKey(_ key: Key) -> Key?

    func lowerEntry(_ key: Key) -> TreeMapEntry<Key, Value>?

    func lowerKey(_ key: Key) -> Key?

    var description: String { get }
}

public struct TreeMap<Tree: BinarySearchTreeType & MutableBinarySearchTreeType, Key: Comparable, Value>: TreeMapType where Tree.Element == TreeMapEntry<Key, Value> {
    private var tree: Tree

    public init() {
        tree = Tree()
    }

    public mutating func update(_ value: Value, forKey key: Key) {
        if let entry = tree.get(key) {
            entry.value = value
        } else {
            _ = tree.insertInPlace(TreeMapEntry(key: key, value: value))
        }
    }

    public func get(_ key: Key) -> Value? {
        guard let node = tree.get(key) else {
            return nil
        }
        return node.value
    }

    public mutating func removeInPlace(_ key: Key) -> TreeMapEntry<Key, Value>? {
        guard let node = tree.get(key) else {
            return nil
        }
        return tree.removeInPlace(node)
    }

    public func floorEntry(_ key: Key) -> TreeMapEntry<Key, Value>? {
        return tree.floor(key)
    }

    public func floorKey(_ key: Key) -> Key? {
        return tree.floor(key)?.key
    }

    public func lowerEntry(_ key: Key) -> TreeMapEntry<Key, Value>? {
        return tree.lower(key)
    }

    public func lowerKey(_ key: Key) -> Key? {
        return tree.lower(key)?.key
    }

    public func makeIterator() -> AnyIterator<TreeMapEntry<Key, Value>> {
        return tree.makeIterator()
    }

    public var description: String {
        return tree.description
    }
}

public typealias AVLTreeMap<Key: Comparable, Value> = TreeMap<AVLTree<TreeMapEntry<Key, Value>>, Key, Value>
public typealias RBTreeMap<Key: Comparable, Value> = TreeMap<RBTree<TreeMapEntry<Key, Value>>, Key, Value>
