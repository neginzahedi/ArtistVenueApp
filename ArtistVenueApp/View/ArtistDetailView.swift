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
    @State private var venueImages = [String:UIImage]()
    
    var body: some View {
        VStack{
            Image(uiImage: artistImage ?? UIImage())
                .resizable()
                .frame(width: 200, height: 200)
            Text(artist.name)
            List(performances){ performance in
                HStack{
                    Image(uiImage: venueImages[performance.venue.name] ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Text(performance.venue.name)
                    Text(performance.date)
                }
            }
        }
        
        .onAppear(){
            api.fetchArtistPerformances(artistID: artist.id) { performances in
                self.performances = performances
                
                for performance in performances {
                    
                    api.fetchVenueImage(venueName: performance.venue.name) { image in
                        if let image = image {
                            self.venueImages[performance.venue.name] = image
                        }
                    }
                }
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
