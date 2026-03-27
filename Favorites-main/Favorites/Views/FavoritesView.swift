

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if !viewModel.favoriteCities.isEmpty {
                    Section("Favorite Cities") {
                        ForEach(viewModel.favoriteCities) { city in
                            HStack {
                                Text(city.cityName)
                                
                                Spacer()
                                
                                Button {
                                    viewModel.toggleCityFavorite(id: city.id)
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                
                if !viewModel.favoriteHobbies.isEmpty {
                    Section("Favorite Hobbies") {
                        ForEach(viewModel.favoriteHobbies) { hobby in
                            HStack {
                                Text("\(hobby.hobbyIcon) \(hobby.hobbyName)")
                                
                                Spacer()
                                
                                Button {
                                    viewModel.toggleHobbyFavorite(id: hobby.id)
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                
                if !viewModel.favoriteBooks.isEmpty {
                    Section("Favorite Books") {
                        ForEach(viewModel.favoriteBooks) { book in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(book.bookTitle)
                                        .font(.headline)
                                    Text(book.bookAuthor)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button {
                                    viewModel.toggleBookFavorite(id: book.id)
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                
                if viewModel.favoriteCities.isEmpty &&
                    viewModel.favoriteHobbies.isEmpty &&
                    viewModel.favoriteBooks.isEmpty {
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
}
