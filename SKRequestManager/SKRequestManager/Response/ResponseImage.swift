//
//  ResponseImage.swift
//  SKRequestManager
//

import Foundation

@objc public class ResponseImage: Response {

	internal var resultImage: UIImage
	public var image: UIImage {
		return self.resultImage
	}

	override init() {
		self.resultImage = UIImage()
		super.init()
	}

	init(image: UIImage, response: URLResponse?) {
		self.resultImage = image
		if let res = response {
			super.init(response: res)
		} else {
			super.init()
		}
	}

}
