import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

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

                Section("Account") {
                    if let email = authViewModel.user?.email {
                        Text("Signed in as: \(email)")
                            .font(.subheadline)
                    }

                    Button("Log Out", role: .destructive) {
                        authViewModel.signOut()
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
        .environmentObject(AuthViewModel())
}
