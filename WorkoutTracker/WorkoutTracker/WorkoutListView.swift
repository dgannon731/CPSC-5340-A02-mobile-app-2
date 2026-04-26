import SwiftUI
import Combine

struct WorkoutListView: View {
    @ObservedObject var workoutViewModel: WorkoutViewModel

    var body: some View {
        List {
            if workoutViewModel.workouts.isEmpty {
                Text("No workouts saved yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(workoutViewModel.workouts) { workout in
                    NavigationLink {
                        WorkoutDetailView(
                            workout: workout,
                            workoutViewModel: workoutViewModel
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(workout.name)
                                .font(.headline)

                            Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text("\(workout.exercises.count) exercises")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(workout.isCompleted ? "Completed" : "Not Completed")
                                .font(.caption)
                                .foregroundStyle(workout.isCompleted ? .green : .orange)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let workout = workoutViewModel.workouts[index]
                        workoutViewModel.deleteWorkout(workout)
                    }
                }
            }
        }
        .navigationTitle("Workout History")
    }
}
