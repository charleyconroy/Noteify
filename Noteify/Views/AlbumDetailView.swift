//
//  AlbumView.swift
//  Noteify
//
//  Created by Charley Conroy on 4/26/23.
//

import SwiftUI

struct AlbumDetailView: View {
    @EnvironmentObject var albumVM: AlbumViewModel
    @State private var showDeleteAlert = false
    @State var album: Album = Album()
    @State var songNames: [String] = []
    @Environment(\.dismiss) var dismiss
    @State private var imageURL: URL? // will hold URL of FirebaseStorage image
    
    var body: some View {
        VStack{
            HStack{
//                if let url = URL(string: album.image.first(where: { $0.size == "large" })?.text ?? "") {
//                    AsyncImage(url: url) { image in
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 100, height: 100)
//                            .clipped()
//                    } placeholder: {
//                        ProgressView()
//                            .frame(width: 100, height: 100)
//                    }
//                } else {
//                    RoundedRectangle(cornerRadius: 4)
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(width: 60, height: 60)
//                }
                VStack(alignment: .leading){
                    Text(album.albumName)
                    Text(album.artist)
                }
            }
            HStack {
                StarSelectionView(rating: $album.rating)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .padding(.top)
            TextField("Your thoughts on \(album.albumName):", text: $album.notes, axis: .vertical)
                .frame(maxHeight: .infinity, alignment: .topLeading)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth:0.3)
                }
                .padding()
        }
        .padding()
        .font(.title)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        let id = await albumVM.saveAlbum(album: Album(albumName: album.albumName, artist: album.artist, notes: album.notes,rating: album.rating, reviewer: album.reviewer))
                        if id != nil { // save worked!
                            album.id = id
                            dismiss()
                        } else { // did not save
                            print("😡 DANG! Error saving!")
                        }
                    }
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showDeleteAlert.toggle()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .alert("Are you sure you want to delete your notes for this album?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .none) {
                Task {
                    let success = await albumVM.deleteAlbum(album:album)
                    if success {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView(album:Album(id: "", albumName: "Abbey Road", artist: "The Beatles"))
            .environmentObject(AlbumViewModel())
    }
}
