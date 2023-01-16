//
//  DownloadManager.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 13.01.2023.
//

import Foundation

class DownloadManager {
   
    static let shared: DownloadManager = .init()
    let networkManager = MusicNetworkManager.shared
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    
    func download(url: String, completiton: @escaping ((URL) -> Void)) {
       
        print(url)

        let urlSession = URLSession(configuration: .default)
        let downloadTask = urlSession.downloadTask(with: URL(string: url)!) { [weak self] localURL,responce,error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            if let localURL = localURL {
                let songName = localURL.lastPathComponent + ".mp3"
                let toURL = self?.path.appending(component: songName)
                try? FileManager.default.copyItem(at: localURL, to: toURL!)
                completiton(toURL!)
            }
        }
        downloadTask.resume()
    }
    
}

   /* extension ViewController:  URLSessionDownloadDelegate {
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            print("downloadLocation:", location)
            // create destination URL with the original pdf name
            guard let url = downloadTask.originalRequest?.url else { return }
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
            // delete original copy
            try? FileManager.default.removeItem(at: destinationURL)
            // copy from temp to Document
            do {
                try FileManager.default.copyItem(at: location, to: destinationURL)
                self.pdfURL = destinationURL
            } catch let error {
                print("Copy Error: \(error.localizedDescription)")
            }
        }
   }
*/

