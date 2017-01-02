//
//  RequestManager+File.swift
//  SKRequestManager
//

import Foundation

extension RequestManager {

	open class func generatedLocalURL(_ urlString: String) -> String {
		var anotherStr = RequestManager.removeURLEncoding(urlString).replacingOccurrences(of: ":", with: "_")
		anotherStr = anotherStr.replacingOccurrences(of: "/", with: "_")
		anotherStr = anotherStr.replacingOccurrences(of: "\\", with: "_")
		anotherStr = anotherStr.replacingOccurrences(of: "%", with: "_")
		return anotherStr
	}

	open class func writeFile(_ tempFilePathURL: URL, fileName: String) throws {
		let fm = FileManager.default
		let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
		let filePath = docDir + "/" + fileName
		let docDirFileURL = URL(fileURLWithPath: filePath)
		do {
			try fm.copyItem(at: tempFilePathURL, to: docDirFileURL)
		} catch {
			throw error
		}
	}

	@discardableResult open class func downloadFile(_ urlString: String, handler: @escaping (String) -> Void) -> URLSessionDownloadTask? {
		if let url = URL(string: urlString) {
			let downloadtask = URLSession.shared.downloadTask(with: url) { (location: URL?, response: URLResponse?, error: Error?) -> Void in
				if location != nil {
					print("Local file url is \(location)")
					let anotherStr = self.generatedLocalURL(urlString)
					do {
						try self.writeFile(location!, fileName: anotherStr)
						handler(anotherStr)
					} catch {
						handler("")
					}
				}
			}
			downloadtask.resume()
			return downloadtask
		} else {
			return nil
		}
	}

	@discardableResult open class func isFileDownloaded(_ urlString: String) -> Bool {
		let anotherStr = self.generatedLocalURL(urlString)
		let fm = FileManager.default
		let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
		let filePath = docDir + "/" + anotherStr
		return fm.fileExists(atPath: filePath)
	}

	@discardableResult open class func loadCachedFile(_ forURLString: String, handler: @escaping (String) -> Void) -> URLSessionDownloadTask? {
		if self.isFileDownloaded(forURLString) {
			handler(self.generatedLocalURL(forURLString))
			return nil
		} else {
			return self.downloadFile(forURLString, handler: handler)
		}
	}

}
