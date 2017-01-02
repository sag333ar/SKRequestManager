//
//  ResponseJSONDictionary.swift
//  SKRequestManager
//

import Foundation

@objc public class ResponseJSONDictionary: Response {

	internal var resultDictionary: [String: AnyObject]
	public var dictionary: [String: AnyObject] {
		return self.resultDictionary
	}

	override init() {
		self.resultDictionary = [: ]
		super.init()
	}

	init(dictionary: [String: AnyObject], response: URLResponse?) {
		self.resultDictionary = dictionary
		if let res = response {
			super.init(response: res)
		} else {
			super.init()
		}
	}

}
