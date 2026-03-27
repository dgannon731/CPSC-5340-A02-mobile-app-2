

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @AppStorage("selectedAppearance") private var selectedAppearance = "System"
    @State private var showClearConfirmation = false
    
    let appearanceOptions = ["System", "Light", "Dark"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Mode", selection: $selectedAppearance) {
                        ForEach(appearanceOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Favorites") {
                    Button("Clear All Favorites", role: .destructive) {
                        showClearConfirmation = true
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Clear all favorites?", isPresented: $showClearConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    viewModel.clearAllFavorites()
                }
            } message: {
                Text("This will remove all favorited cities, hobbies, and books.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(FavoritesViewModel())
}
