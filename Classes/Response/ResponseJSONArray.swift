//
//  ResponseJSONArray.swift
//  SKRequestManager
//

import Foundation

@objc public class ResponseJSONArray: Response {

	internal var resultArray: [AnyObject]
	public var array: [AnyObject] {
		return self.resultArray
	}

	override init() {
		self.resultArray = []
		super.init()
	}

	init(array: [AnyObject], response: URLResponse?) {
		self.resultArray = array
		if let res = response {
			super.init(response: res)
		} else {
			super.init()
		}
	}

}
