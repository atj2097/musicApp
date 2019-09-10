//
//  SongModel.swift
//  musicApp
//
//  Created by God on 9/9/19.
//  Copyright © 2019 God. All rights reserved.
//

import Foundation
enum JSONError: Error {
    case decodingError(Error)
}


struct ArtistWrapper:Codable{
    let message:Message
}
struct Message:Codable{
    let body:Body
}
struct Body:Codable{
    let track_list:[TrackList]
}
struct TrackList:Codable {
    let track: Track
}
struct Track:Codable{
    let track_id:Int
    let track_name:String
    let  has_lyrics:Int
    let artist_name:String
}
