// Playground - noun: a place where people can play

import UIKit

class Queue {
	
	var queueArray = [String]()
	
	func enqueueToArray(stringToEnqueue: String) {
		self.queueArray.append(stringToEnqueue)
	}
	
	func dequeueFromArray() -> String? {
		if !self.queueArray.isEmpty {
			var stringToDequeue = self.queueArray.first
			self.queueArray.removeAtIndex(0)
			return stringToDequeue
		} else {
			return nil
		}
	}
	
	func peekTopOfQueue() -> String? {
		if !self.queueArray.isEmpty {
			var stringToPeek = self.queueArray.last
			return stringToPeek
		} else {
			return nil
		}
	}
	
	func peekBottomOfQueue() -> String? {
		if !self.queueArray.isEmpty {
			var stringToPeek = self.queueArray[0]
			return stringToPeek
		} else {
			return nil
		}
	}
	
}

var myQueue = Queue()

myQueue.enqueueToArray("Reid")
myQueue.enqueueToArray("Weber")

var lastItem = myQueue.peekTopOfQueue()
var firstItem = myQueue.peekBottomOfQueue()

var itemToRemove = myQueue.dequeueFromArray()