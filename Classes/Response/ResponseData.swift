//
//  ResponseData.swift
//  SKRequestManager
//

import Foundation

@objc public class ResponseData: Response {

	internal var resultData: Data
	public var data: Data {
		return self.resultData
	}

	override init() {
		self.resultData = Data()
		super.init()
	}

	internal init(data: Data, response: URLResponse?) {
		self.resultData = data
		if let res = response {
			super.init(response: res)
		} else {
			super.init()
		}
	}

}
