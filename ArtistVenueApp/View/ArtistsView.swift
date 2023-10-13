//
//  ArtistsView.swift
//  ArtistVenueApp
//
//  Created by Negin Zahedi on 2023-10-12.
//

import SwiftUI

struct ArtistsView: View {
    
    @ObservedObject private var vm = DataManager.shared
    @State private var artists = [Artist]()
    @State private var artistImages = [String:UIImage]()
    @State private var selectedGenre = "All"
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                GenreButtonsView(selectedGenre: $selectedGenre)
                    .padding(.vertical, 15)
                ArtistsListView(artists: artists, artistImages: artistImages, selectedGenre: selectedGenre)
            }
            .navigationTitle("Artists")
        }
        .onAppear(){
            Task{
                do {
                    self.artists = try await vm.fetchArtists()
                    await fetchArtistsImages(artists: artists)
                } catch{
                    print("error fetch artist")
                }
            }
        }
    }
    
    private func fetchArtistsImages(artists: [Artist]) async{
        for artist in artists {
            do {
                let image = try await vm.fetchImage(url:vm.getImageURL(name: artist.name, type: "artists"))
                self.artistImages[artist.name] = image
            } catch{
                print("no image for artist")
            }
        }
    }
}

struct GenreButtonsView: View {
    let genres: [String] = ["All", "Punk", "Country", "Pop", "Synthpop", "Goth", "Metal", "Dance", "Folk", "Blues", "Rock"]
    @Binding var selectedGenre: String
    
    var body: some View {
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
    }
}

struct GenreButton: View {
    let genre: String
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

struct ArtistsListView: View {
    let artists: [Artist]
    let artistImages: [String: UIImage]
    var selectedGenre: String
    
    var body: some View {
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
}

struct ArtistCard: View {
    let artist: Artist
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
