//
//  BinaryTreeType.swift
//  Forest
//
//  Created by Vincent Esche on 2/12/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

public protocol BinaryTreeType : CustomStringConvertible, CustomDebugStringConvertible, Equatable, Sequence {
	associatedtype Element
	
	init()

	func analysis<U>(branch: (Self, Element, Self) -> U, leaf: () -> U) -> U
}

extension BinaryTreeType {
    public var element: Element? {
		return analysis(branch: { _, element, _ in
			element
		}, leaf: {
			nil
		})
	}
	
    public var left: Self? {
		return analysis(branch: { left, _, _ in
			return (left.isNil) ? nil : left
		}, leaf: {
			nil
		})
	}
	
    public var right: Self? {
		return analysis(branch: { _, _, right in
			return (right.isNil) ? nil : right
		}, leaf: {
			nil
		})
	}

    public func preorder(_ closure: (Element) -> ()) {
        self.analysis(branch: { (l, e, r) -> () in
            closure(e)
            l.preorder(closure)
            r.preorder(closure)
        }, leaf: {})
    }

    public func inorder(_ closure: (Element) -> ()) {
        self.analysis(branch: { (l, e, r) -> () in
            l.inorder(closure)
            closure(e)
            r.inorder(closure)
        }, leaf: {})
    }

    public func postorder(_ closure: (Element) -> ()) {
        self.analysis(branch: { (l, e, r) -> () in
            l.postorder(closure)
            r.postorder(closure)
            closure(e)
        }, leaf: {})
    }

    public var height: Int8 {
		return analysis(branch: { l, _, r in
			Swift.max(l.height, r.height) + 1
		}, leaf: {
			0
		})
	}
	
    public var subtreeHeights: (Int, Int) {
		return analysis(branch: { l, _, r in
			(Int(r.height), Int(l.height))
		}, leaf: {
			(0, 0)
		})
	}
	
    public var balance: Int {
		return analysis(branch: { l, _, r in
            Int(r.height - l.height)
		}, leaf: {
			0
		})
	}
	
    public var count: Int {
		return analysis(branch: { l, _, r in
			l.count + 1 + r.count
		}, leaf: {
			0
		})
	}

    public var isEmpty: Bool {
		return self.isNil
	}
	
    public var isNil: Bool {
		return analysis(branch: { _, _, _ in
			false
		}, leaf: {
			true
		})
	}
	
    func clear() -> Self {
		return Self()
	}

    public func makeIterator() -> AnyIterator<Element> {
		var stack: [Self] = [self]
        return AnyIterator { 
			var current = stack.removeLast()
			while true {
				if current.isNil {
					if stack.isEmpty {
						return nil
					} else {
						current = stack.removeLast()
						return current.analysis(branch: { _, e, r in
							stack.append(r)
							return e
						}, leaf: { nil })
					}
				} else {
					current.analysis(branch: { l, _, _ in
						stack.append(current)
						current = l
						return
					}, leaf: { return })
				}
			}
		}
	}
	
    public func traverseLeftwards(_ closure: (Self) -> ()) -> Self {
		closure(self)
		return analysis(branch: { l, _, _ in
			l.traverseLeftwards(closure)
		}, leaf: {
			self
		})
	}
	
    public func traverseRightwards(_ closure: (Self) -> ()) -> Self {
		closure(self)
		return analysis(branch: { _, _, r in
			r.traverseRightwards(closure)
		}, leaf: {
			self
		})
	}

    public func leftmostBranch() -> Self {
		var node = self
		let _ = traverseLeftwards {
			if !$0.isNil {
				node = $0
			}
		}
		return node
	}
	
    public func rightmostBranch() -> Self {
		var node = self
        let _ = traverseRightwards {
			if !$0.isNil {
				node = $0
			}
		}
		return node
	}

    public func recursiveDescription(_ closure: @escaping (Self) -> String?) -> String {
		return self.recursiveDescription("", flag: false, closure: closure)
	}
	
    fileprivate func recursiveDescription(_ string: String, flag: Bool, closure: @escaping (Self) -> String?) -> String {
		var recursiveDescription : ((Self, String, Bool) -> String)! = nil
		recursiveDescription = { node, prefix, isTail in
			var string = ""
			if let element = closure(node) {
				if let right = node.right, right.analysis(branch: { _, _, _ in true }, leaf: { closure(right) != nil }) {
					string += recursiveDescription(right, prefix + ((isTail) ? "│  " : "   "), false)
				}
				string += prefix + ((isTail) ? "└─ " : "┌─ ") + "\(element)\n"
				if let left = node.left, left.analysis(branch: { _, _, _ in true }, leaf: { closure(left) != nil }) {
					string += recursiveDescription(left, prefix + ((isTail) ? "   " : "│  "), true)
				}
			}
			return string
		}
		return recursiveDescription(self, "", false)
	}

    public var description: String {
		return self.recursiveDescription { return $0.analysis(branch: { _, e, _ in "\(e)" }, leaf: { nil }) }
	}

    public var debugDescription: String {
		return self.recursiveDescription { return $0.analysis(branch: { _, e, _ in "\(e)" }, leaf: { "nil" }) }
	}
}
