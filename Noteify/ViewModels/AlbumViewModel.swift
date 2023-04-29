//
//  AlbumInfoViewModel.swift
//  Noteify
//
//  Created by Charley Conroy on 4/27/23.
//

import Foundation
import FirebaseFirestore

class AlbumViewModel:ObservableObject {
    @Published var albums: [Album] = []
    private var listenerRegistration: ListenerRegistration?
    
    func saveAlbum(album: Album) async -> String? {
        let db = Firestore.firestore()
        if let albumID = album.id {
            // If the album has an ID, update the existing document
            do {
                let albumRef = try await db.collection("albums").document(albumID)
                try await albumRef.setData(album.dictionary)
                print("😎 Data updated successfully!")
                return albumID
            } catch {
                print("😡 ERROR: Could not update data in 'albums' \(error.localizedDescription)")
                return nil
            }
        } else {
            // If the album doesn't have an ID, create a new document
            do {
                let docRef = try await db.collection("albums").addDocument(data: album.dictionary)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 ERROR: Could not create a new album in 'albums' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func deleteAlbum(album: Album) async -> Bool {
        let db = Firestore.firestore()
        guard let albumID = album.id else {
            print("🤮 ERROR: spot.id = \(album.id ?? "nil").")
            return false
        }
        
        do {
            let _ = try await db.collection("albums").document(albumID).delete()
            print("Document successfully deleted!")
            return true
        } catch {
            print("🤮 ERROR: removing document \(error.localizedDescription)")
            return false
        }
    }
}
