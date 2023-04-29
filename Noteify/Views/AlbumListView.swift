//
//  ListView.swift
//  Noteify
//
//  Created by Charley Conroy on 4/25/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct AlbumListView: View {
    @FirestoreQuery(collectionPath: "albums") var albums: [Album]
    @StateObject var albumVM = AlbumViewModel()
    @State private var searchText = ""
    @State private var sheetIsPresented = false
    @Environment (\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(albums) { album in
                        NavigationLink {
                            AlbumDetailView(album: album)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(album.albumName)
                                        .font(.title2)
                                    Text(album.artist)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out successful!")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out!")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print(albums)
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Your Albums")
            .searchable(text: $searchText)
        }
        .sheet(isPresented: $sheetIsPresented) {
            NewView()
        }
    }
}


struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumListView()
    }
}
