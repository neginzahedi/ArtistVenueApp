//
//  ArtistsView.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import SwiftUI

struct ArtistsView: View {
    
    @StateObject var api = DataManager()
    @State private var artists = [Artist]()
    @State private var artistImages = [String:UIImage]()
    @State private var searchedArtist: String = ""
    
    let genres: [String] = ["All", "Punk", "Country", "Pop", "Synthpop", "Goth", "Metal", "Dance", "Folk", "Blues", "Rock"]
    @State private var selectedGenre: String = "All"
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10){
                        ForEach(genres, id:\.self) { genre in
                            GenreButton(genre: genre, isSelected: genre == selectedGenre)
                                .onTapGesture {
                                    selectedGenre = genre
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
                VStack{
                    if selectedGenre == "All"{
                        ForEach(artists){ artist in
                            ArtistCard(artist: artist, artistImage: artistImages[artist.name] ?? UIImage())
                        }
                    } else {
                        let filtredArtists = artists.filter { $0.genre == selectedGenre }
                        ForEach(filtredArtists){ artist in
                            ArtistCard(artist: artist, artistImage: artistImages[artist.name] ?? UIImage())
                        }
                    }
                }
            }
            .fontDesign(.rounded)
            .navigationTitle("Artists")
        }
        .onAppear(){
            api.fetchArtists { artists in
                self.artists = artists
                
                for artist in artists {
                    api.fetchArtistImage(artistName: artist.name) { image in
                        if let image = image{
                            artistImages[artist.name] = image
                        }
                    }
                }
            }
        }
    }
}


struct GenreButton: View {
    var genre: String
    var isSelected: Bool
    var body: some View {
        Text(genre)
            .foregroundStyle(isSelected ? .white : .black)
            .padding(8)
            .background(isSelected ? .black : .white)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.black, lineWidth: 1)
            )
            .font(.system(.subheadline, design: .rounded))
            .padding(2)
    }
}

struct ArtistCard: View {
    
    var artist: Artist
    let artistImage: UIImage
    
    var body: some View {
        NavigationLink {
            ArtistDetailView(artist: artist)
        } label: {
            ZStack(alignment: .topLeading) {
                Image(uiImage: artistImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 250)
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Text(artist.genre)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .padding(.trailing, 20)
                            .padding(.top, 20)
                    }
                    Spacer()
                    
                    HStack{
                        Text(artist.name)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                }
            }
            .cornerRadius(10)
            .padding()
        }
    }
}

#Preview {
    ArtistsView()
}
