import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var workoutViewModel = WorkoutViewModel()

    var completedWorkouts: Int {
        workoutViewModel.workouts.filter { $0.isCompleted }.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Total Workouts: \(workoutViewModel.workouts.count)")
                    Text("Completed Workouts: \(completedWorkouts)")
                    Text("Active Workouts: \(workoutViewModel.workouts.count - completedWorkouts)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))

                NavigationLink {
                    AddWorkoutView(workoutViewModel: workoutViewModel)
                } label: {
                    Text("Add New Workout")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                NavigationLink {
                    WorkoutListView(workoutViewModel: workoutViewModel)
                } label: {
                    Text("Workout History")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink {
                    SettingsView()
                } label: {
                    Text("Settings")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                if !workoutViewModel.errorMessage.isEmpty {
                    Text(workoutViewModel.errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("FitLog")
            .onAppear {
                workoutViewModel.fetchWorkouts()
            }
        }
    }
}
