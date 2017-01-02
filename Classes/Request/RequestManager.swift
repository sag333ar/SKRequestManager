//
//  RequestManager.swift
//

import UIKit

@objc open class RequestManager: NSObject {

	@discardableResult open class func invokeRequestForData(_ request: URLRequest,
	                                       handler: @escaping (Response) -> Void) -> URLSessionDataTask {
		let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
			if let r = error {
				handler(ResponseError(error: r, response: response))
			} else if let dataReceived = data {
				handler(ResponseData(data: dataReceived, response: response))
			} else {
				let erroR = NSError(domain: "RequestManager",
				                    code: 500,
				                    userInfo: ["Some error occured": NSLocalizedDescriptionKey])
				handler(ResponseError(error: erroR, response: response))
			}
		}
		task.resume()
		return task
	}

	open class func parseJSONData(_ data: Data, urlresponse: URLResponse?) -> Response {
		do {
			let obj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
			if let dictionary = obj as? [String: AnyObject] {
				return ResponseJSONDictionary(dictionary: dictionary, response: urlresponse)
			} else if let array = obj as? [AnyObject] {
				return ResponseJSONArray(array: array, response: urlresponse)
			} else {
				let erroR = NSError(domain: "RequestManager",
				                    code: 501,
				                    userInfo: ["Error occured in JSON Parsing": NSLocalizedDescriptionKey])
				return ResponseError(error: erroR, response: urlresponse)
			}
		} catch {
			let erroR = NSError(domain: "RequestManager",
			                    code: 501,
			                    userInfo: ["Error occured in JSON Parsing": NSLocalizedDescriptionKey])
			return ResponseError(error: erroR, response: urlresponse)
		}
	}

	open class func invokeRequestForJSON(_ request: URLRequest, handler: @escaping (Response) -> Void) -> URLSessionDataTask {
		let task = self.invokeRequestForData(request) { (response: Response) in
			if let responseData = response as? ResponseData {
				handler(RequestManager.parseJSONData(responseData.data, urlresponse: responseData.response))
			} else if let respError = response as? ResponseError {
				handler(respError)
			} else {
				let erroR = NSError(domain: "RequestManager",
				                    code: 500,
				                    userInfo: ["Some error occured": NSLocalizedDescriptionKey])
				handler(ResponseError(error: erroR, response: response.response))
			}
		}
		return task
	}

}
