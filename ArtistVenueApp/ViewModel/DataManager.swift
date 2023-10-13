//
//  DataManager.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import Foundation
import UIKit

class DataManager: ObservableObject {
    
    @Published var artists = [Artist]()
    
    let BASE_URL = "http://ec2-44-211-66-223.compute-1.amazonaws.com"
    let BASE_IMG_URL = "https://songleap.s3.amazonaws.com"
    
    // Fetch artists
    func fetchArtists() async throws -> [Artist] {
        guard let url = URL(string: "\(BASE_URL)/artists") else {
            print("Invalid url...")
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let artists = try JSONDecoder().decode([Artist].self, from: data)
        return artists.sorted(by: { $0.name < $1.name })
    }
    
    // Fetch artist performances (two weeks)
    func fetchArtistPerformances(artistID: Int) async throws -> [ArtistPerformance]{
        guard let url = URL(string: "\(BASE_URL)/artists/\(artistID)/performances?\(DataManager.twoWeekRange(from: Date()))") else {
            print("Invalid url...")
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let performances = try JSONDecoder().decode([ArtistPerformance].self, from: data)
        return performances
    }
    
    // Calculate date range for the next two weeks
    static func twoWeekRange(from date: Date) -> String {
        let calendar = Calendar.current
        let twoWeeksFromNow = calendar.date(byAdding: .day, value: 13, to: date)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fromDateString = dateFormatter.string(from: date)
        let toDateString = dateFormatter.string(from: twoWeeksFromNow)
        
        return "from=\(fromDateString)&to=\(toDateString)"
    }
    
    
    // Format date
    static func formatDateString(_ inputDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: inputDate) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return "Invalid date format"
        }
    }
    
    // Format time
    static func formatTimeString(_ inputDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: inputDate) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return "Invalid date format"
        }
    }
    
    // Format image url
    func getImageURL(name: String, type: String) throws -> URL{
        let imageName = name.replacingOccurrences(of: " ", with: "+") + ".png"
        let url = "\(BASE_IMG_URL)/\(type)/\(imageName)"
        guard let url = URL(string: url) else {
            print("Invalid url...")
            throw URLError(.badURL)
        }
        return url
    }
    
    // Fetch image
    func fetchImage(url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        let image = UIImage(data: data)
        return image
    }
}
