//
//  RequestManager+RqstUtilities.swift
//  SKRequestManager
//
//  Created by Sagar on 1/2/17.
//  Copyright © 2017 Sagar R. Kothari. All rights reserved.
//

import Foundation

extension RequestManager {

	open class func generateQueryString(_ isHTTPsScheme: Bool, host: String, path: String, extensionOfPath: String = "", parameters: [String: String]) -> URL? {
		var components = URLComponents()
		components.scheme = isHTTPsScheme ? "https" : "http"
		components.host = host
		components.path = path + extensionOfPath
		components.queryItems = [URLQueryItem]()
		for (key, value) in parameters {
			let queryItem = URLQueryItem(name: key, value: value)
			components.queryItems!.append(queryItem)
		}
		return components.url
	}

	open class func addURLEncoding(_ string: String) -> String {
		return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
	}

	open class func removeURLEncoding(_ string: String) -> String {
		return string.removingPercentEncoding!
	}

	open class func generateRequest(_ urlString: String,
	                                dictionaryOfHeaders: [String: String]?,
	                                postData: Data?,
	                                requestType: RequestType,
	                                timeOut: Int) -> URLRequest {
		// Create Request using URL Sent
		var mRqst = URLRequest(url: URL(string: urlString)!)
		// set the request type
		mRqst.httpMethod = requestType.stringValue
		// set the content length & content
		if postData != nil {
			mRqst.setValue("\(postData!.count)", forHTTPHeaderField: "Content-Length")
			mRqst.httpBody = postData!
		}

		// set the request headers
		if let headers = dictionaryOfHeaders {
			for (key, value) in headers {
				mRqst.setValue(value, forHTTPHeaderField: key)
			}
		}
		// set the request time-out
		mRqst.timeoutInterval = TimeInterval(timeOut)
		return mRqst
	}

}
