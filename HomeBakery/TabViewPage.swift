import SwiftUI

struct TabViewPage: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            if selectedTab == 0 {
                Home()
            } else if selectedTab == 1 {
                ListCourses()
            } else if selectedTab == 2 {
                Profile()
            }

            // Custom Tab Bar
            HStack {
                Button(action: { selectedTab = 0 }) {
                    VStack {
                        Image(systemName: "leaf")
                        Text("Bake")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)

                Button(action: { selectedTab = 1 }) {
                    VStack {
                        Image(systemName: "book")
                        Text("Courses")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)

                Button(action: { selectedTab = 2 }) {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(.systemGray6))
        }
    }
}


#Preview {
    TabViewPage()
}
