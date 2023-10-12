//
//  ArtistPerformance.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import Foundation

struct ArtistPerformance: Codable, Identifiable, Hashable{
    var id: Int
    var artistId: Int
    var date: String
    var venue: Venue
}
