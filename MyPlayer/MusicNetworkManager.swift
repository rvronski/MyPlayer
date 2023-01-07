//
//  MusicNetworkManager.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 07.01.2023.
//

import Foundation
struct Tracks: Decodable {
    var source: String
    var status: String
    var data: Datas
    var type: String
}

struct Datas: Decodable {
    var name: String
    var albumName: String
    var imageUrl: String
    var url: String
    
}

struct Answer: Decodable {
    var tracks: [Tracks, Tracks]
    
}
/*
 {
   "tracks": [
     {
       "source": "spotify",
       "status": "success",
       "data": {
         "externalId": "5aszL9hl6SBzFNsOvw8u8w",
         "previewUrl": null,
         "name": "Bezos I",
         "artistNames": [
           "Bo Burnham"
         ],
         "albumName": "INSIDE",
         "imageUrl": "https://i.scdn.co/image/ab67616d0000b27388fed14b936c38007a302413",
         "isrc": "",
         "duration": 58149,
         "url": "https://open.spotify.com/track/5aszL9hl6SBzFNsOvw8u8w"
       },
       "type": "track"
     },
     {
       "source": "youtube",
       "status": "success",
       "data": {
         "externalId": "lI5w2QwdYik",
         "previewUrl": null,
         "name": "Bo Burnham: Inside  - Jeff Bezos",
         "artistNames": null,
         "albumName": "",
         "imageUrl": "https://i.ytimg.com/vi/lI5w2QwdYik/mqdefault.jpg",
         "isrc": "",
         "duration": null,
         "url": null
       },
       "type": "track"
     }
   ]
 }
 */

struct Music: Decodable {
    var type: String
}

class MusicNetworkManager {
    
    static func loadMusic(completion: ((_ music: [Tracks]?) -> Void)?) {
        let headers = [
            "content-type": "application/json",
            "X-RapidAPI-Key": "7d47c62672msh5e5465a8c85495dp1a94afjsn75f03ee65e7d",
            "X-RapidAPI-Host": "musicapi13.p.rapidapi.com"
        ]
        let parameters = [
            "track": "Bezos I",
            "artist": "Bo Burnham",
            "type": "track",
            "sources": ["spotify", "youtube"]
        ] as [String : Any]
//        let parameters = ["url": "https://open.spotify.com/track/5aszL9hl6SBzFNsOvw8u8w"] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://musicapi13.p.rapidapi.com/search")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
//        guard let url = URL(string:" https://musicapi13.p.rapidapi.com/inspect/url") else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            }
            let httpResponse = (response as? HTTPURLResponse)?.statusCode
            print(httpResponse as Any)
            if httpResponse != 200 {
                print("Status Code = \(String(describing: httpResponse))")
                completion?(nil)
                return
            }
            guard let data else {
                print("data = nil")
                completion?(nil)
                return
            }
            do {
                let music = try JSONDecoder().decode(Answer.self, from: data)
                let result = music.tracks
                completion?(result)
            } catch {
                completion?(nil)
                print(error)
            }
        })
        
        task.resume()
        
    }
}
