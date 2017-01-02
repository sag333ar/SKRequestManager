//
//  ResponseError.swift
//  SKRequestManager
//

import Foundation

@objc public class ResponseError: Response {

	internal var resultError: Error
	public var error: Error {
		return self.resultError
	}

	override init() {
		self.resultError = NSError(domain: "Default Error", code: 500, userInfo: ["Default error occured": NSLocalizedDescriptionKey])
		super.init()
	}

	internal init(error: Error, response: URLResponse?) {
		self.resultError = error
		if let res = response {
			super.init(response: res)
		} else {
			super.init()
		}
	}

}
