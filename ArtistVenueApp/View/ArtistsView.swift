//
//  ArtistsView.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import SwiftUI

struct ArtistsView: View {
    
    @StateObject var api = DataManager()
    @State var artists = [Artist]()
    
    var body: some View {
        NavigationStack{
            List(artists){ artist in
                NavigationLink(value: artist) {
                    Text(artist.name)
                }
            }
            .navigationTitle("Artists")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Artist.self) { artist in
                ArtistDetailView(artist:artist)
            }
        }
        .onAppear(){
            api.fetchArtists { artists in
                self.artists = artists
            }
        }
    }
}

#Preview {
    ArtistsView()
}
