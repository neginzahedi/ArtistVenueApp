//
//  ArtistDetailView.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import SwiftUI

struct ArtistDetailView: View {
    
    var artist: Artist
    
    @StateObject var api = DataManager()
    
    @State var performances = [ArtistPerformance]()
    @State private var artistImage: UIImage?
    
    var body: some View {
        VStack{
            Image(uiImage: artistImage ?? UIImage())
                .resizable()
                .frame(width: 200, height: 200)
            Text(artist.name)
            List(performances){ performance in
                HStack{
                    Text(performance.venue.name)
                    Text(performance.date)
                }
            }
        }
        
        .onAppear(){
            api.fetchArtistPerformances(artistID: artist.id) { performances in
                self.performances = performances
            }
            
            api.fetchArtistImage(artistName: artist.name) { image in
                self.artistImage = image
            }
        }
    }
}

/*
 #Preview {
 ArtistDetailView()
 }
 */
