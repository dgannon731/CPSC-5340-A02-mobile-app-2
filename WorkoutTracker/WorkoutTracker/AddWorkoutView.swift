import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var workoutViewModel: WorkoutViewModel

    @State private var workoutName = ""
    @State private var workoutDate = Date()
    @State private var notes = ""

    @State private var exerciseName = ""
    @State private var muscleGroup = "Chest"
    @State private var repsText = ""
    @State private var weightText = ""
    @State private var timeText = ""
    @State private var distanceText = ""

    @State private var temporarySets: [ExerciseSet] = []
    @State private var exercises: [Exercise] = []

    @State private var errorMessage = ""

    let muscleGroups = [
        "Chest",
        "Back",
        "Shoulders",
        "Biceps",
        "Triceps",
        "Legs",
        "Core",
        "Cardio",
        "Other"
    ]

    var body: some View {
        Form {
            Section("Workout Info") {
                TextField("Workout Name", text: $workoutName)

                DatePicker(
                    "Date",
                    selection: $workoutDate,
                    displayedComponents: .date
                )

                TextField("Notes", text: $notes, axis: .vertical)
            }

            Section("Add Exercise") {
                TextField("Exercise Name", text: $exerciseName)

                Picker("Muscle Group", selection: $muscleGroup) {
                    ForEach(muscleGroups, id: \.self) { group in
                        Text(group)
                    }
                }
                .onChange(of: muscleGroup) {
                    temporarySets = []
                    repsText = ""
                    weightText = ""
                    timeText = ""
                    distanceText = ""
                }

                if muscleGroup == "Cardio" {
                    TextField("Time in minutes", text: $timeText)
                        .keyboardType(.numberPad)

                    TextField("Distance in miles", text: $distanceText)
                        .keyboardType(.decimalPad)
                } else {
                    TextField("Reps", text: $repsText)
                        .keyboardType(.numberPad)

                    TextField("Weight", text: $weightText)
                        .keyboardType(.decimalPad)
                }

                Button("Add Set") {
                    addSet()
                }

                if !temporarySets.isEmpty {
                    ForEach(Array(temporarySets.enumerated()), id: \.element.id) { index, set in
                        if muscleGroup == "Cardio" {
                            Text("Entry \(index + 1): \(set.timeMinutes ?? 0) minutes, \(set.distanceMiles ?? 0.0, specifier: "%.2f") miles")
                        } else {
                            Text("Set \(index + 1): \(set.reps ?? 0) reps at \(set.weight ?? 0.0, specifier: "%.1f") lbs")
                        }
                    }
                }

                Button("Add Exercise to Workout") {
                    addExercise()
                }
            }

            Section("Exercises Added") {
                if exercises.isEmpty {
                    Text("No exercises added yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(exercises) { exercise in
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.headline)

                            Text(exercise.muscleGroup)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text("\(exercise.sets.count) sets")
                                .font(.caption)
                        }
                    }
                    .onDelete { indexSet in
                        exercises.remove(atOffsets: indexSet)
                    }
                }
            }

            if !errorMessage.isEmpty {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("Save Workout") {
                    saveWorkout()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Add Workout")
    }

    private func addSet() {
        errorMessage = ""

        if muscleGroup == "Cardio" {
            guard let timeMinutes = Int(timeText), timeMinutes > 0 else {
                errorMessage = "Enter a valid time in minutes."
                return
            }

            guard let distanceMiles = Double(distanceText), distanceMiles >= 0 else {
                errorMessage = "Enter a valid distance."
                return
            }

            let newSet = ExerciseSet(
                timeMinutes: timeMinutes,
                distanceMiles: distanceMiles
            )

            temporarySets.append(newSet)

            timeText = ""
            distanceText = ""
        } else {
            guard let reps = Int(repsText), reps > 0 else {
                errorMessage = "Enter a valid number of reps."
                return
            }

            guard let weight = Double(weightText), weight >= 0 else {
                errorMessage = "Enter a valid weight."
                return
            }

            let newSet = ExerciseSet(
                reps: reps,
                weight: weight
            )

            temporarySets.append(newSet)

            repsText = ""
            weightText = ""
        }
    }

    private func addExercise() {
        errorMessage = ""

        guard !exerciseName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Enter an exercise name."
            return
        }

        guard !temporarySets.isEmpty else {
            errorMessage = "Add at least one set before adding the exercise."
            return
        }

        let exercise = Exercise(
            name: exerciseName,
            muscleGroup: muscleGroup,
            sets: temporarySets
        )

        exercises.append(exercise)

        exerciseName = ""
        muscleGroup = "Chest"
        temporarySets = []
        repsText = ""
        weightText = ""
    }

    private func saveWorkout() {
        errorMessage = ""

        guard !workoutName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Enter a workout name."
            return
        }

        guard !exercises.isEmpty else {
            errorMessage = "Add at least one exercise."
            return
        }

        let workout = Workout(
            name: workoutName,
            date: workoutDate,
            notes: notes,
            isCompleted: false,
            exercises: exercises
        )

        workoutViewModel.addWorkout(workout)
        dismiss()
    }
}
