//
//  Song.swift
//  Noteify
//
//  Created by Charley Conroy on 4/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Song: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var songName = ""
    var notes = ""
    var liked = false
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["notes": notes, "songName": songName, "liked":liked, "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
}
