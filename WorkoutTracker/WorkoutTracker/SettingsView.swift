import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @AppStorage("selectedAppearance") private var selectedAppearance = "System"

    let appearanceOptions = ["System", "Light", "Dark"]

    var body: some View {
        VStack(spacing: 25) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 10) {
                Text("Appearance")
                    .font(.headline)

                Picker("Appearance", selection: $selectedAppearance) {
                    ForEach(appearanceOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)

                Text("System follows your phone's current light or dark mode setting.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button(role: .destructive) {
                authViewModel.signOut()
            } label: {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
    }
}
