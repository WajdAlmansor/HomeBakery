import SwiftUI

struct ListCourses: View {
    @State private var searchString = ""
    @State private var courses: [Course] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack {
                Text("Courses")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                Divider()

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchString)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                if isLoading {
                    ProgressView("Loading courses...")
                        .padding()
                } else if courses.isEmpty {
                    Text("No courses available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(filteredCourses, id: \.title) { course in
                                NavigationLink(destination: CourseDetailView(course: course)) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack(alignment: .top) {
                                            AsyncImage(url: URL(string: course.imageUrl)) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: 80, height: 80)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 80, height: 80)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundColor(.gray)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }

                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(course.title)
                                                    .font(.headline)
                                                Text(course.description)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                Text("Level: \(course.level)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text("Location: \(course.locationName)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text("End Date: \(formatDate(course.endDate))")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                    }
                                    .frame(width: 350, height: 150)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .task {
                await loadItems()
            }
        }
    }

    var filteredCourses: [Course] {
        if searchString.isEmpty {
            return courses
        } else {
            return courses.filter { $0.title.lowercased().contains(searchString.lowercased()) }
        }
    }

    func loadItems() async {
        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/course") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(data: data, encoding: .utf8) ?? "Invalid Course JSON") // Debug: Print raw course data
            let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            courses = apiResponse.records.map { $0.fields }
            isLoading = false
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }

    func formatDate(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    ListCourses()
}
