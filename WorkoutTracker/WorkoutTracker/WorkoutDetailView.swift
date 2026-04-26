import SwiftUI
import Combine

struct WorkoutDetailView: View {
    @Environment(\.dismiss) var dismiss

    let workout: Workout
    @ObservedObject var workoutViewModel: WorkoutViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                workoutHeader

                Divider()

                Text("Exercises")
                    .font(.title2)
                    .fontWeight(.bold)

                ForEach(workout.exercises) { exercise in
                    ExerciseCardView(exercise: exercise)
                }

                Button(role: .destructive) {
                    workoutViewModel.deleteWorkout(workout)
                    dismiss()
                } label: {
                    Text("Delete Workout")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var workoutHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(workout.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(workout.date.formatted(date: .long, time: .omitted))
                .foregroundStyle(.secondary)

            if !workout.notes.isEmpty {
                Text("Notes")
                    .font(.headline)

                Text(workout.notes)
                    .foregroundStyle(.secondary)
            }

            Button {
                workoutViewModel.toggleCompleted(workout)
            } label: {
                Text(workout.isCompleted ? "Mark Not Completed" : "Mark Completed")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ExerciseCardView: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(exercise.name)
                .font(.headline)

            Text(exercise.muscleGroup)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, set in
                ExerciseSetRowView(
                    index: index,
                    set: set,
                    isCardio: exercise.muscleGroup == "Cardio"
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ExerciseSetRowView: View {
    let index: Int
    let set: ExerciseSet
    let isCardio: Bool

    var body: some View {
        HStack {
            if isCardio {
                Text("Entry \(index + 1)")
                Spacer()
                Text("\(set.timeMinutes ?? 0) min")
                Text("\(set.distanceMiles ?? 0.0, specifier: "%.2f") mi")
            } else {
                Text("Set \(index + 1)")
                Spacer()
                Text("\(set.reps ?? 0) reps")
                Text("\(set.weight ?? 0.0, specifier: "%.1f") lbs")
            }
        }
        .font(.subheadline)
    }
}
