//
//  Profile.swift
//  HomeBakery
//
//  Created by Wajd on 26/01/2025.
//

import SwiftUI

struct Profile: View {
    @State private var username: String = "username"

    var body: some View {
        VStack(alignment: .leading) { // Align all content to the left
            // Header
            Text("Profile")
                .font(.title)
                .bold()
                .padding(.top)
            
            Divider()
                .padding()
            
            // Profile Section (Immediately below the header)
            HStack(spacing: 16) {
                // Profile Image with Add Icon
                ZStack(alignment: .bottomTrailing) {
                    // Circle Background for Profile Icon
                    Circle()
                        .fill(Color(.systemGray5)) // Background color for the profile
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black) // Icon color
                        )
                    
                    // Add Icon
                    Circle()
                        .fill(Color(.systemBrown)) // Background color for the add icon
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white) // Icon color
                        )
                        .offset(x: 6, y: 6) // Adjust position of the add icon
                }
                
                // Text Field for Username
                TextField("Enter username", text: $username)
                    .font(.system(size: 16))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                // Done Button
                Button(action: {
                    print("Done button tapped")
                }) {
                    Text("Done")
                        .foregroundColor(Color(.systemBrown))
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            Divider()
                .padding(.top, 10)
            
            // Booked Courses Section
            Text("Booked courses")
                .font(.title) // Optional: make it slightly larger
                .fontWeight(.bold)
                .padding(.top, 10) // Adds spacing below the divider
        }
        .padding(.horizontal)// Adds padding to the horizontal edges
        Spacer()
        
        
    }
}

#Preview {
    Profile()
}
