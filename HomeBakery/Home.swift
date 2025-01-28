//
//  ContentView.swift
//  HomeBakery
//
//  Created by Wajd on 16/01/2025.
//

import SwiftUI   

struct Home: View {
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
}
    #Preview {
        Home()
    }

