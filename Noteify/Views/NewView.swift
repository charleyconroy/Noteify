//
//  NewView.swift
//  Noteify
//
//  Created by Charley Conroy on 4/27/23.
//

import SwiftUI

struct NewView: View {
    @State private var searchText = ""
    @State var album: Album = Album()
    @StateObject var albumVM = AlbumSearchViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List(albumVM.albums, id: \.url) { album in
                LazyVStack {
                    NavigationLink {
                        AlbumDetailView(album: Album(albumName: album.name, artist: album.artist))
                    } label: {
                        HStack{
//                            if let url = URL(string: album.image.first(where: { $0.size == "large" })?.text ?? "") {
//                                AsyncImage(url: url) { image in
//                                    image
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 60, height: 60)
//                                        .clipped()
//                                } placeholder: {
//                                    ProgressView()
//                                        .frame(width: 60, height: 60)
//                                }
//                            } else {
//                                RoundedRectangle(cornerRadius: 4)
//                                    .fill(Color.gray.opacity(0.2))
//                                    .frame(width: 60, height: 60)
//                            }
                            VStack(alignment: .leading){
                                Text(album.name)
                                Text(album.artist)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Albums")
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { text in
                Task {
                    albumVM.albums = []
                    if !text.isEmpty {
                        await albumVM.getData(searchTerm: searchText, method: "album")
                    } else {
                        albumVM.albums = []
                    }
                }
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        NewView()
    }
}
