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
    
    let genres: [String] = ["All", "Punk", "Country", "Pop", "Synthpop", "Goth", "Metal", "Dance", "Folk", "Blues", "Rock"]
    @State private var selectedGenre: String = "All"
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10){
                        ForEach(genres, id:\.self) { genre in
                            Text(genre)
                                .foregroundStyle(selectedGenre == genre ? .red : .black)
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
                            NavigationLink {
                                ArtistDetailView(artist: artist)
                            } label: {
                                ZStack(alignment: .topLeading) {
                                    Image(uiImage: artistImages[artist.name] ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .frame(maxHeight: 300)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack {
                                            Spacer()
                                            Text(artist.genre)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(.black)
                                                .cornerRadius(10)
                                                .opacity(0.8)
                                                .padding(.trailing, 20)
                                                .padding(.top, 20)
                                        }
                                        Spacer()
                                        
                                        HStack{
                                            Text(artist.name)
                                                .font(.title)
                                                .bold()
                                                .foregroundColor(.white)
                                                .shadow(color:.white,radius: 10)
                                                .padding(.leading, 20)
                                                .padding(.vertical, 20)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .background(.black)
                                        .opacity(0.8)
                                    }
                                }
                                .cornerRadius(10)
                                .padding()
                            }
                        }
                    } else {
                        let filtredArtists = artists.filter { $0.genre == selectedGenre }
                        ForEach(filtredArtists){ artist in
                            NavigationLink {
                                ArtistDetailView(artist: artist)
                            } label: {
                                ZStack(alignment: .topLeading) {
                                    Image(uiImage: artistImages[artist.name] ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .frame(maxHeight: 300)
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack {
                                            Spacer()
                                            Text(artist.genre)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(.black)
                                                .cornerRadius(10)
                                                .opacity(0.8)
                                                .padding(.trailing, 20)
                                                .padding(.top, 20)
                                        }
                                        Spacer()
                                        
                                        HStack{
                                            Text(artist.name)
                                                .font(.title)
                                                .bold()
                                                .foregroundColor(.white)
                                                .shadow(color:.white,radius: 10)
                                                .padding(.leading, 20)
                                                .padding(.vertical, 20)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .background(.black)
                                        .opacity(0.8)
                                        .cornerRadius(10)
                                        
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .fontDesign(.rounded)
            
            .navigationTitle("Artists")
            .navigationBarTitleDisplayMode(.inline)
            
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

#Preview {
    ArtistsView()
}
