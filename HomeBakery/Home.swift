//
//  ContentView.swift
//  HomeBakery
//
//  Created by Wajd on 16/01/2025.
//

import SwiftUI   

struct Home: View {
    @State private var courses: [Course] = []
    @State private var isLoading = true

    @State var searchString = ""
    var body: some View {
            VStack {
                
                Text("Home Bakery")
                    .bold()
                    .padding()
                
                Divider()
                Spacer()
                    .frame(height: 20)
                
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
                
                
                VStack {
                    HStack {
                        Text("Upcoming")
                            .font(.title)
                            .bold()
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack {
                    HStack {
                        Text("Popular courses")
                            .font(.title)
                            .bold()
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
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

}

    #Preview {
        Home()
    }

