//
//  RequestManager+ImageUploadDownload.swift
//  SKRequestManager
//

import Foundation

extension RequestManager {

	open class func uploadPhoto(_ request: URLRequest, image: UIImage, handler: @escaping (Response) -> Void) -> URLSessionDataTask {
		var rqst = request
		let imageData = UIImagePNGRepresentation(image)
		rqst.httpMethod = "POST"
		let boundry = "---------------------------14737809831466499882746641449"
		let stringContentType = "multipart/form-data; boundary=\(boundry)"
		rqst.addValue(stringContentType, forHTTPHeaderField: "Content-Type")
		let dataToUpload = NSMutableData()
		// add boundry
		let boundryData = "\r\n--" + boundry + "\r\n"
		dataToUpload.append(boundryData.data(using: String.Encoding.utf8)!)
		// add file name
		let fileName = "Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"abc.png\"\r\n"
		dataToUpload.append(fileName.data(using: String.Encoding.utf8)!)
		// add content type
		let contentType = "Content-Type: application/octet-stream\r\n\r\n"
		dataToUpload.append(contentType.data(using: String.Encoding.utf8)!)
		// add UIImage-Data
		dataToUpload.append(imageData!)
		// add end boundry
		let boundryEndData = "\r\n--" + boundry + "--\r\n"
		dataToUpload.append(boundryEndData.data(using: String.Encoding.utf8)!)
		// set HTTPBody to Request
		rqst.httpBody = dataToUpload as Data

		return self.invokeRequestForData(rqst, handler: handler)
	}

	open class func invokeRequestToDownloadImage(_ stringURLOfImage: String, handler: @escaping (Response) -> Void) -> URLSessionDataTask? {
		var anotherStr = self.removeURLEncoding(stringURLOfImage).replacingOccurrences(of: ":", with: "_")
		anotherStr = anotherStr.replacingOccurrences(of: "/", with: "_")
		anotherStr = anotherStr.replacingOccurrences(of: "\\", with: "_")
		anotherStr = anotherStr.replacingOccurrences(of: "%", with: "_")

		let fm = FileManager.default
		let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
		let filePath = docDir + "/" + anotherStr
		if fm.fileExists(atPath: filePath) == true {
			if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
				if let img = UIImage(data: data) {
					handler(ResponseImage(image: img, response: nil))
					return nil
				}
			}
		}

		let req = self.generateRequest(stringURLOfImage, dictionaryOfHeaders: nil, postData: nil, requestType: .Get, timeOut: 60)
		let task = self.invokeRequestForData(req) { (response: Response) in
			if let responseData = response as? ResponseData, let img = UIImage(data: responseData.data) {
				try? responseData.data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
				handler(ResponseImage(image: img, response: nil))
			} else if let respError = response as? ResponseError {
				handler(respError)
			} else {
				let erroR = NSError(domain: "RequestManager",
				                    code: 500,
				                    userInfo: ["Some error occured": NSLocalizedDescriptionKey])
				handler(ResponseError(error: erroR, response: response.response))
			}
		}
		task.resume()
		return task
	}

}
