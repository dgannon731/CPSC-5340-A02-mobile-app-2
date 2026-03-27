

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @AppStorage("selectedAppearance") private var selectedAppearance = "System"
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .environmentObject(viewModel)
        .preferredColorScheme(appColorScheme)
    }
    
    var appColorScheme: ColorScheme? {
        switch selectedAppearance {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return nil
        }
    }
}

#Preview {
    ContentView()
}
