//
//  Album.swift
//  Noteify
//
//  Created by Charley Conroy on 4/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct Album: Identifiable, Codable {
    @DocumentID var id: String?
    var albumName = ""
    var artist = ""
    var notes = ""
    var rating = 0
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["albumName": albumName, "artist":artist, "notes":notes, "rating":rating, "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
}
