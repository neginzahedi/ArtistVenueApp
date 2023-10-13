//
//  DataManager.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import Foundation
import UIKit

enum DataManagerError: Error {
    case URLConversionFailed
    case FormattingFailed
}

/// - **DataManager** View Model Class
/// - Version: 1.0
/// - Note: This class handles networking working tasks such as fetching artists, performances, venues, entity images
class DataManager: ObservableObject {
    // MARK: - Properties
    @Published var artists = [Artist]()
    
    
    // MARK: - API Routes
    let BASE_URL = "http://ec2-44-211-66-223.compute-1.amazonaws.com"
    let BASE_IMG_URL = "https://songleap.s3.amazonaws.com"
    
    // MARK: - Methods
    /// Fetches all artists
    ///
    /// - Returns: an array of artists of type `Artist`
    /// - Throws: URLError if it fails to convert the stringURL to a URL instance
    func fetchArtists() async throws -> [Artist] {
        guard let url = URL(string: "\(BASE_URL)/artists") else {
            throw DataManagerError.URLConversionFailed
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let artists = try JSONDecoder().decode([Artist].self, from: data)
        return artists.sorted(by: { $0.name < $1.name })
    }
    
    /// Fetches artist performances for the next two weeks
    ///
    /// - Parameters:
    ///     - artistID: the integer id of the artist
    /// - Throws:
    ///     URLError if it fails to convert the stringURL to a URL instance
    /// - Returns: an array of artists along with their performances which are of type `ArtistPerformance`
    func fetchArtistPerformances(artistID: Int) async throws -> [ArtistPerformance]{
        guard let url = URL(string: "\(BASE_URL)/artists/\(artistID)/performances?\(DataManager.twoWeekRange(from: Date()))") else {
            throw DataManagerError.URLConversionFailed
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let performances = try JSONDecoder().decode([ArtistPerformance].self, from: data)
        return performances
    }
    
    /// Calculates a two week range starting from a given date and returns the range in the from-to format
    ///
    /// - Parameters:
    ///    - from: the starting date
    /// - Returns: the string representation of the range that could be directly used as the parameter part of the request's url
    static func twoWeekRange(from date: Date) -> String {
        let calendar = Calendar.current
        let twoWeeksFromNow = calendar.date(byAdding: .day, value: 13, to: date)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fromDateString = dateFormatter.string(from: date)
        let toDateString = dateFormatter.string(from: twoWeeksFromNow)
        
        return "from=\(fromDateString)&to=\(toDateString)"
    }
    
    
    /// Formats a date string from a specific format to "MMM d, yyyy" format.
    ///
    /// - Parameters:
    ///    - inputDate: The date string in the "yyyy-MM-dd'T'HH:mm:ss" format.
    /// - Throws: If the input format is invalid, `FormattingFailed` is thrown.
    /// - Returns: A formatted date string in the "MMM d, yyyy" format.
    static func formatDateString(_ inputDate: String)  throws -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: inputDate) else {
            throw DataManagerError.FormattingFailed
        }
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    /// Formats a time string from a specific format to "h:mm a" format.
    ///
    /// - Parameters:
    ///    - inputDate: The time string in the "yyyy-MM-dd'T'HH:mm:ss" format.
    /// - Throws: If the input format is invalid, `FormattingFailed` is thrown.
    /// - Returns: A formatted time string in the "h:mm a" format.
    static func formatTimeString(_ inputDate: String) throws -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: inputDate) else {
            throw DataManagerError.FormattingFailed
        }
        
        dateFormatter.dateFormat = "h:mm a"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    /// Generates a URL for an image based on the provided image name and type.
    ///
    /// - Parameters:
    ///   - name: The image name.
    ///   - type: The image type (e.g., "venues" or "artists").
    /// - Throws: Throws a URLError(.badURL) if the generated URL is invalid.
    /// - Returns: The URL for the image.
    func getImageURL(name: String, type: String) throws -> URL{
        let imageName = name.replacingOccurrences(of: " ", with: "+") + ".png"
        let url = "\(BASE_IMG_URL)/\(type)/\(imageName)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        guard let url = URL(string: url) else {
            throw DataManagerError.URLConversionFailed
        }
        
        return url
    }
    
    /// Fetches an image asynchronously from a given URL.
    ///
    /// - Parameters:
    ///    - url: The URL of the image to be fetched.
    /// - Throws: Throws any errors encountered during the image fetching process.
    /// - Returns: An optional UIImage if the image is successfully fetched, or nil if an error occurs.
    func fetchImage(url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        let image = UIImage(data: data)
        return image
    }
}
