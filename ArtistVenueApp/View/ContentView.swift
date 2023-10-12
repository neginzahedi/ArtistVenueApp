//
//  ContentView.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var api = DataManager()
    @State var artists = [Artist]()
    
    var body: some View {
        List(artists){ artist in
            Text(artist.name)
        }
        
        .onAppear(){
            api.fetchArtists { artists in
                self.artists = artists
            }
        }
    }
}

#Preview {
    ContentView()
}
