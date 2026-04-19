import SwiftUI

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        Group {
            if authViewModel.user != nil {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(favoritesViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
        .onChange(of: authViewModel.user?.uid) { _, _ in
            favoritesViewModel.loadForCurrentUser()
        }
        .task {
            favoritesViewModel.loadForCurrentUser()
        }
    }
}
