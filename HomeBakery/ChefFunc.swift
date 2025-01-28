import Foundation
import SwiftUI

class ChefViewModel: ObservableObject {
    @Published var chefName: String = ""

    func loadChefName(chefId: String) async {
        // Construct the URL with the correct filterByFormula syntax
        guard let url = URL(string: "https://api.airtable.com/v0/appXMZSaDdTpCIm/chef?filterByFormula={id}='\(chefId)'") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer pat7EB8Wy3dgz1Y61.2b7d03863aca9f1626dcb72f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")

        do {
            // Fetch data from the API
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Print the raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            // Decode the response
            let decodedResponse = try JSONDecoder().decode(ChefApi.self, from: data)
            
            // Check if any records were returned
            if decodedResponse.records.isEmpty {
                print("No chef found with ID: \(chefId)")
            } else {
                // Update the chef name
                if let chef = decodedResponse.records.first?.fields {
                    DispatchQueue.main.async {
                        self.chefName = chef.name
                    }
                }
            }
        } catch {
            print("Error fetching or decoding data: \(error)")
        }
    }}
