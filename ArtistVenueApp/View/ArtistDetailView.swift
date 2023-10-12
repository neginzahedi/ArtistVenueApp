//
//  ArtistDetailView.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import SwiftUI

struct ArtistDetailView: View {
    
    var artist: Artist
    
    var body: some View {
        Text(artist.name)
    }
}

/*
 #Preview {
 ArtistDetailView()
 }
 */
