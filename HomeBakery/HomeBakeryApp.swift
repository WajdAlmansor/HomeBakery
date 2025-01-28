//
//  HomeBakeryApp.swift
//  HomeBakery
//
//  Created by Wajd on 16/01/2025.
//

import SwiftUI

@main
struct HomeBakeryApp: App {
    var body: some Scene {
        WindowGroup {
           // Home()
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
    }
}
