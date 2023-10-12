//
//  Venue.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import Foundation

struct Venue: Codable, Identifiable, Hashable{
    var id: Int
    var name: String
    var sortId: Int
}
