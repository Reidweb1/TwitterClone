// Playground - noun: a place where people can play

import UIKit

class Stack {
	
	var stackArray = [String]()
	
	func pushOntoStack(stringToPush: String) {
		self.stackArray.append(stringToPush)
	}
	
	func popOffOfStack() -> String? {
		if !self.stackArray.isEmpty {
			var stringToReturn = self.stackArray.last
			self.stackArray.removeLast()
			return stringToReturn!
		} else {
			return nil
		}
	}
	
	func peekTopOfStack() -> String? {
		if !self.stackArray.isEmpty {
			var stringToReturn = self.stackArray.last
			return stringToReturn
		} else {
				return nil
		}
	}
	
}


var myStack = Stack()

myStack.pushOntoStack("Reid")
myStack.pushOntoStack("Weber")

myStack.peekTopOfStack()

var lastItem = myStack.popOffOfStack()