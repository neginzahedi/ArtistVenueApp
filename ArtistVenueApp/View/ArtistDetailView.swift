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
            .onAppear(){
                fetchArtistDetail()
            }
            .fontDesign(.rounded)
            .navigationTitle(artist.name)
    }
    
    private func fetchArtistDetail() {
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
