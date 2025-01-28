import SwiftUI
import MapKit

struct CourseDetailView: View {
    let course: Course
    @StateObject private var chefViewModel = ChefViewModel()
    @State private var showSignInSheet = false
    
    // Add a region state for the map
    @State private var mapRegion: MKCoordinateRegion

    init(course: Course) {
        self.course = course
        _mapRegion = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text(course.title)
                    .font(.largeTitle)
                    .bold()
                
                AsyncImage(url: URL(string: course.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }

                Text("Description:")
                    .font(.headline)
                Text(course.description)
                    .font(.body)

                Text("Level: \(course.level)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Location: \(course.locationName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("End Date: \(formatDate(course.endDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                // Add the map view here
                Text("Course Location:")
                    .font(.headline)
                Map(coordinateRegion: $mapRegion, annotationItems: [course]) { location in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.locationLatitude, longitude: location.locationLongitude))
                }
                .frame(height: 200)
                .cornerRadius(10)
                
                Divider()
                
                Text("Chef:")
                    .font(.headline)

                if !chefViewModel.chefName.isEmpty {
                    VStack(alignment: .leading) {
                        Text(chefViewModel.chefName)
                            .font(.headline)
                        Text("Email: example@example.com")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("No chef available for this course.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Course Details")
        .task {
            if let chefID = course.chefID {
                print("Loading chef for course: \(course.title), chefID: \(chefID)")
                await chefViewModel.loadChefName(chefId: chefID)
            } else {
                print("No chef associated with this course.")
            }
        }
        
        VStack {
            Button(action: {
                showSignInSheet = true
            }) {
                Text("Book a space")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBrown))
                    .cornerRadius(12)
            }
            .sheet(isPresented: $showSignInSheet) {
                SignIn()
            }
        }
        .padding()
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
    CourseDetailView(course: Course(
        title: "Swift Programming",
        description: "Learn how to build iOS apps using Swift and SwiftUI.",
        level: "Beginner",
        imageUrl: "https://via.placeholder.com/300",
        locationName: "Online",
        locationLongitude: 0.0,
        locationLatitude: 0.0,
        startDate: 1672531200,
        endDate: 1675123200,
        chefID: "rec0zyLMcXfhT3cDh" // Example chef ID
    ))
}
