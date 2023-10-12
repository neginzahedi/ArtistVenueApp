//
//  DataManager.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import Foundation

class DataManager: ObservableObject {
    
    @Published var artists = [Artist]()
    
    let BASE_URL = "http://ec2-44-211-66-223.compute-1.amazonaws.com"
    
    // Fetch artists
    func fetchArtists(completion: @escaping ([Artist]) -> ()) {
        guard let url = URL(string: "\(BASE_URL)/artists") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let artists = try JSONDecoder().decode([Artist].self, from: data)
                    print(artists)
                    DispatchQueue.main.async {
                        completion(artists)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
}
