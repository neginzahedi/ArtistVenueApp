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
    @State private var performances = [ArtistPerformance]()
    @State private var venueImages = [String:UIImage]()
    
    var body: some View {
        PerformancesListView(performances: performances, venueImages : venueImages)
            .onAppear {
                Task{
                    do {
                        self.performances =  try await api.fetchArtistPerformances(artistID: artist.id)
                        for performance in performances {
                            do {
                                let image = try await api.fetchImage(url: api.getImageURL(name: performance.venue.name, type: "venues"))
                                self.venueImages[performance.venue.name] = image
                            } catch{
                                print("no image for artist")
                            }
                        }
                    } catch{
                        print("Error fetch")
                    }
                }
            }
            .navigationTitle(artist.name)
    }
}

struct PerformancesListView: View {
    let performances: [ArtistPerformance]
    let venueImages: [String:UIImage]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment: .leading){
                HStack{
                    Text("Performances")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                ForEach(performances) { performance in
                    VenueCard(performance: performance, venueImage: venueImages[performance.venue.name] ?? UIImage())
                    Divider()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
        }
    }
}

struct VenueCard: View {
    let performance: ArtistPerformance
    let venueImage: UIImage
    
    var body: some View {
        HStack{
            Image(uiImage: venueImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
            VStack(alignment: .leading) {
                HStack{
                    Text(DataManager.formatDateString(performance.date))
                        .bold()
                    Text(DataManager.formatTimeString(performance.date))
                        .foregroundStyle(.secondary)
                }
                Text(performance.venue.name)
                    .font(.caption)
            }
        }
    }
}
