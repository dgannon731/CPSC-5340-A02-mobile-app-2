import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel

    var favoriteCities: [CityModel] {
        viewModel.cities.filter { $0.isFavorite }
    }

    var favoriteHobbies: [HobbyModel] {
        viewModel.hobbies.filter { $0.isFavorite }
    }

    var favoriteBooks: [BookModel] {
        viewModel.books.filter { $0.isFavorite }
    }

    var body: some View {
        NavigationStack {
            List {
                if !favoriteCities.isEmpty {
                    Section("Cities") {
                        ForEach(favoriteCities) { city in
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

                if !favoriteHobbies.isEmpty {
                    Section("Hobbies") {
                        ForEach(favoriteHobbies) { hobby in
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

                if !favoriteBooks.isEmpty {
                    Section("Books") {
                        ForEach(favoriteBooks) { book in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(book.bookTitle)
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

                if favoriteCities.isEmpty && favoriteHobbies.isEmpty && favoriteBooks.isEmpty {
                    Text("No favorites yet.")
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
