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
    func fetchArtists(completion: @escaping ([Artist]) -> ()) {
        guard let url = URL(string: "\(BASE_URL)/artists") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let artists = try JSONDecoder().decode([Artist].self, from: data)
                    //print(artists)
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
    
    // Fetch artist performances (two weeks)
    func fetchArtistPerformances(artistID: Int, completion: @escaping ([ArtistPerformance]) -> ()){
        guard let url = URL(string: "\(BASE_URL)/artists/\(artistID)/performances?\(DataManager.currentTwoWeekRange())") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let performances = try JSONDecoder().decode([ArtistPerformance].self, from: data)
                    //print(performances)
                    DispatchQueue.main.async {
                        completion(performances)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
    
    // Calculate date range for the next two weeks
    static func currentTwoWeekRange() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let twoWeeksFromNow = calendar.date(byAdding: .day, value: 13, to: currentDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fromDateString = dateFormatter.string(from: currentDate)
        let toDateString = dateFormatter.string(from: twoWeeksFromNow!)
        
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
    
    
    static func sum(first: Int, second: Int) -> Int {
        return first + second;
    }
    
    // Fetch artist image
    func fetchArtistImage(artistName: String, completion: @escaping (UIImage?) -> Void) {
        let imageName = artistName.replacingOccurrences(of: " ", with: "+") + ".png"
        let urlString = "\(BASE_IMG_URL)/artists/\(imageName)"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
    
    // Fetch venue image
    func fetchVenueImage(venueName: String, completion: @escaping (UIImage?) -> Void) {
        let imageName = venueName.replacingOccurrences(of: " ", with: "+") + ".png"
        let urlString = "\(BASE_IMG_URL)/venues/\(imageName)"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
}
