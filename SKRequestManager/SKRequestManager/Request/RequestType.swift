//
//  RequestType.swift
//  RequestManager

import Foundation

@objc public enum RequestType: Int {

	case Get // = "GET"
	case Post // = "POST"
	case Delete // = "DELETE"
	case Put // = "PUT"

	public var stringValue: String {
		switch self.rawValue {
		case 0:
			return "GET"
		case 1:
			return "POST"
		case 2:
			return "DELETE"
		case 3:
			return "PUT"
		default:
			return "GET"
		}
	}

}
