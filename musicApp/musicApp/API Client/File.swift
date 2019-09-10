//
//  File.swift
//  musicApp
//
//  Created by God on 9/9/19.
//  Copyright © 2019 God. All rights reserved.
//
//
import UIKit
struct SongAPIClient {
    static var shared = SongAPIClient()
    let songURL = "http://api.musixmatch.com/ws/1.1/track.search?page_size=100&page=1&s_track_rating=desc&apikey=bd66c872465de313fb33270d31515cf6"

    func getSong(completion:@escaping (Result<[TrackList], Error>) -> ()){
        guard let url = URL(string: songURL) else { return }
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            //Error handler
            if let err = err {
                completion(.failure(err))
            }
            //success
            do {
               let song = try JSONDecoder().decode([TrackList].self, from: data!)
                completion(.success(song))
            }
            catch let jsonError {
                completion(.failure(jsonError))
            }
            }.resume()
    }
}

