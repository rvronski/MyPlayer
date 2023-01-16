//
//  MusicNetworkManager.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 07.01.2023.
//

import Foundation
struct Metadata: Decodable {
    var artists: String?
    var title: String?
    var cover: String?
    var album: String?
   
}


struct Answer: Decodable {
    var success: Bool?
    var metadata: Metadata?
    var link: String?
    var status: String?
    var progress: String?
}
/*
 {
 "success": true,
 "metadata": {"artists": "David Guetta, Bebe Rexha",
 "title": "I'm Good (Blue)",
 "cover": "https://i.scdn.co/image/ab67616d0000b273933c036cd61cd40d3f17a9c4",
 "album": "I'm Good (Blue)"},
 "link": "https://api.spotifydown.com/dl/David%20Guetta%2C%20Bebe%20Rexha%20-%20I'm%20Good%20(Blue).mp3",
 "status": "ok",
 "progress": 0
 
 }
 */

struct Music: Decodable {
    var type: String
}

class MusicNetworkManager {
    
    static let shared: MusicNetworkManager = .init()
    
   func loadMusic(completion: ((_ music: String?) -> Void)?) {
        
        let headers = [
            "X-RapidAPI-Key": "0765c2b9b8msh16a080b9cd5b61fp1b04d2jsn66e7e997d5a5",
            "X-RapidAPI-Host": "spotify-downloader.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify-downloader.p.rapidapi.com/SpotifytrackDownloader?id=4uUG5RXrOk84mYEfFvj3cK")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = (response as? HTTPURLResponse)?.statusCode
                print(httpResponse as Any)
                if httpResponse != 200 {
                    print("Status Code = \(String(describing: httpResponse))")
                    completion?(nil)
                    return
                } else {
                    guard let data else {
                        print("data = nil")
                        completion?(nil)
                        return
                    }
                    do {
                        let music = try JSONDecoder().decode(Answer.self, from: data)
                        let result = music.link
                        completion?(result)
                    } catch {
                        completion?(nil)
                        print(error)
                    }
                }
            }
            })
            
            dataTask.resume()
            
        }
    }
           

