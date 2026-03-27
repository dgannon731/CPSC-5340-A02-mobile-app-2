

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @State private var selectedCategory = "Cities"
    @State private var searchText = ""
    
    let categories = ["Cities", "Hobbies", "Books"]
    
    var filteredCities: [CityModel] {
        if searchText.isEmpty {
            return viewModel.cities
        } else {
            return viewModel.cities.filter {
                $0.cityName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filteredHobbies: [HobbyModel] {
        if searchText.isEmpty {
            return viewModel.hobbies
        } else {
            return viewModel.hobbies.filter {
                $0.hobbyName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filteredBooks: [BookModel] {
        if searchText.isEmpty {
            return viewModel.books
        } else {
            return viewModel.books.filter {
                $0.bookTitle.localizedCaseInsensitiveContains(searchText) ||
                $0.bookAuthor.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])
                
                List {
                    if selectedCategory == "Cities" {
                        ForEach(filteredCities) { city in
                            ZStack(alignment: .bottomLeading) {
                                Image(city.cityImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 110)
                                    .clipped()
                                
                                Rectangle()
                                    .fill(.black.opacity(0.35))
                                
                                HStack {
                                    Text(city.cityName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button {
                                        viewModel.toggleCityFavorite(id: city.id)
                                    } label: {
                                        Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(.black.opacity(0.4))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
                            }
                            .frame(height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 6)

                        }
                    }
                    
                    if selectedCategory == "Hobbies" {
                        ForEach(filteredHobbies) { hobby in
                            HStack {
                                Text("\(hobby.hobbyIcon) \(hobby.hobbyName)")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Button {
                                    viewModel.toggleHobbyFavorite(id: hobby.id)
                                } label: {
                                    Image(systemName: hobby.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    if selectedCategory == "Books" {
                        ForEach(filteredBooks) { book in
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
                                    Image(systemName: book.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Home")
            .searchable(text: $searchText, prompt: "Search \(selectedCategory)")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(FavoritesViewModel())
}
