//
//  Response.swift
//  RequestManager
//

import Foundation

@objc public class Response: NSObject {

	var resultResponse: URLResponse?
	public var response: URLResponse? {
		return self.resultResponse
	}

	override init() {
		self.resultResponse = nil
		super.init()
	}

	public init(response: URLResponse) {
		self.resultResponse = response
		super.init()
	}

}
