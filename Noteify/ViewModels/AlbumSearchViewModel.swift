//
//  NotesViewModel.swift
//  Noteify
//
//  Created by Charley Conroy on 4/27/23.
//

import Foundation
import FirebaseFirestore

@MainActor
class AlbumSearchViewModel: ObservableObject {
    let apiKey = "191b19cf0bbb3335b33a236dc73d42ea"
    let limit = 30
    
    struct SearchResult: Codable {
        let results: Results
    }
    
    struct Results: Codable {
        let opensearchQuery: OpensearchQuery
        let opensearchTotalResults, opensearchStartIndex, opensearchItemsPerPage: String
        let albummatches: AlbumMatches
        let attr: Attr
        
        enum CodingKeys: String, CodingKey {
            case opensearchQuery = "opensearch:Query"
            case opensearchTotalResults = "opensearch:totalResults"
            case opensearchStartIndex = "opensearch:startIndex"
            case opensearchItemsPerPage = "opensearch:itemsPerPage"
            case albummatches = "albummatches"
            case attr = "@attr"
        }
    }
    
    struct OpensearchQuery: Codable {
        let text, role, searchTerms, startPage: String
        
        enum CodingKeys: String, CodingKey {
            case text = "#text"
            case role = "role"
            case searchTerms = "searchTerms"
            case startPage = "startPage"
        }
    }
    
    struct AlbumMatches: Codable {
        let album: [Album]
    }
    
    struct Album: Codable {
        let name, artist, url: String
        let image: [Image]
        let streamable, mbid: String
    }
    
    struct Image: Codable {
        let text: String
        let size: String
        
        enum CodingKeys: String, CodingKey {
            case text = "#text"
            case size = "size"
        }
        var dictionary: [String: Any] {
                return ["text": text,"size": size]
        }
    }
    
    struct Attr: Codable {
        let attrFor: String
        
        enum CodingKeys: String, CodingKey {
            case attrFor = "for"
        }
    }
    
    
    var albums: [Album] = []
    var name = ""
    var artist = ""
    
    func getData(searchTerm: String, method: String) async {
        let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm
        let urlString = "http://ws.audioscrobbler.com/2.0/?method=\(method).search&\(method)=\(encodedSearchTerm)&api_key=\(apiKey)&format=json&limit=\(limit)"
        print("🕸️Accessing url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("🤮Could not create a URL from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(SearchResult.self, from: data) else {
                print("JSON Data: \(String(data: data, encoding: .utf8) ?? "No JSON Data")")
                print("🤮 JSON ERROR: Could not decode returned JSON data")
                return
            }
            print("JSON Data: \(String(data: data, encoding: .utf8) ?? "No JSON Data")")
            for album in returned.results.albummatches.album {
                print("Album Name: \(album.name), Artist: \(album.artist), image \(album.image)")
                albums.append(Album(name: album.name, artist: album.artist, url: album.artist, image: album.image, streamable: album.streamable, mbid: album.mbid))
            }
            
        } catch {
            print("🤮Could not get data from \(urlString)")
        }
    }
}
