//
//  BinarySearchTreeType.swift
//  Forest
//
//  Created by Vincent Esche on 7/26/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

public enum BinaryTreeStepType {
    case root
    case leftBranch
    case rightBranch
}

public protocol BinarySearchTreeType : BinaryTreeType, ExpressibleByArrayLiteral where Element: Comparable {
    

	init<S: Sequence>(sortedSequence: S) where S.Iterator.Element == Element
}

extension BinarySearchTreeType {
	public init<S: Sequence>(sequence: S) where S.Iterator.Element == Element {
		self.init(sortedSequence: sequence.sorted())
	}
	
	public init(arrayLiteral elements: Element...) {
		self.init(sequence: elements)
	}
	
    public mutating func clearInPlace() {
		self = self.clear()
	}
	
    public func get(_ element: Element) -> Element? {
		return analysis(branch: { l, e, r in
			if element < e {
				return l.get(element)
			} else if element > e {
				return r.get(element)
			} else {
				return e
			}
		}, leaf: {
			nil
		})
	}
	
    public func contains(_ element: Element) -> Bool {
		return self.get(element) != nil
	}

    public func lower(_ element: Element) -> Element? {
        return analysis(branch: { l, e, r in
            if element > e {
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

    public func floor(_ element: Element) -> Element? {
        return analysis(branch: { l, e, r in
            if element > e {
                if let next = r.floor(element) {
                    return next
                } else {
                    return e
                }
            } else if element == e {
                return e
            } else {
                return l.floor(element)
            }
        }, leaf: {
            nil
        })
    }
}
