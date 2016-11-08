//
//  main.swift
//  RootishArrayStack
//
//  Created by Benjamin Emdon on 2016-11-07.
//

import Darwin

public struct RootishArrayStack<T> {
	fileprivate var blocks = [Array<T?>]()
	fileprivate var internalCount = 0

	public init() { }

	var count: Int {
		return internalCount
	}

	var capacity: Int {
		return blocks.count * (blocks.count + 1) / 2
	}

	fileprivate static func toBlock(index: Int) -> Int {
		let block = Int(ceil((-3.0 + sqrt(9.0 + 8.0 * Double(index))) / 2))
		return block
	}

	fileprivate mutating func grow() {
		let newArray = [T?](repeating: nil, count: blocks.count + 1)
		blocks.append(newArray)
	}

	fileprivate mutating func shrink() {
		var numberOfBlocks = blocks.count
		while numberOfBlocks > 0 && (numberOfBlocks - 2) * (numberOfBlocks - 1) / 2 >= count {
			blocks.remove(at: blocks.count - 1)
			numberOfBlocks -= 1
		}
	}

	public subscript(index: Int) -> T {
		get {
			let block = RootishArrayStack.toBlock(index: index)
			let blockIndex = index - block * (block + 1) / 2
			return blocks[block][blockIndex]!
		}
		set(newValue) {
			let block = RootishArrayStack.toBlock(index: index)
			let blockIndex = index - block * (block + 1) / 2
			blocks[block][blockIndex] = newValue
		}
	}

	public mutating func insert(element: T, atIndex index: Int) {
		if capacity < count + 1 {
			grow()
		}
		internalCount += 1
		var i = count - 1
		while i > index {
			self[i] = self[i - 1]
			i -= 1
		}
		self[index] = element
	}

	public mutating func append(element: T) {
		insert(element: element, atIndex: count)
	}

	fileprivate mutating func makeNil(atIndex index: Int) {
		let block = RootishArrayStack.toBlock(index: index)
		let blockIndex = index - block * (block + 1) / 2
		blocks[block][blockIndex] = nil
	}

	public mutating func remove(atIndex index: Int) -> T {
		let element = self[index]
		for i in index..<count - 1 {
			self[i] = self[i + 1]
		}
		internalCount -= 1
		makeNil(atIndex: count)
		if capacity >= count {
			shrink()
		}
		return element
	}

	public var memoryDescription: String {
		var s = "{\n"
		for i in blocks {
			s += "\t["
			for j in i {
				s += "\(j), "
			}
			s += "]\n"
		}
		return s + "}"
	}
}

extension RootishArrayStack: CustomStringConvertible {
	public var description: String {
		var s = "["
		for index in 0..<count {
			s += "\(self[index])"
			if index + 1 != count {
				s += ", "
			}
		}
		return s + "]"
	}
}
