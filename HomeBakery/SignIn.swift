import SwiftUI

struct SignIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var users: [User] = [] // Store fetched users
    @State private var errorMessage: String? // To display login errors
    @State private var isAuthenticated: Bool = false // To control navigation

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("Sign In")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                // Email Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.primary)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                // Password Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Enter your password", text: $password)
                                .padding()
                        } else {
                            SecureField("Enter your password", text: $password)
                                .padding()
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 10)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
                
                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                
                Spacer()
                
                // Sign In Button
                Button(action: {
                    Task {
                        await signIn()
                    }
                }) {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBrown))
                        .cornerRadius(12)
                }
                .padding(.top)
                .disabled(email.isEmpty || password.isEmpty) // Disable button if fields are empty
                
                // Navigation on Successful Login
                if isAuthenticated {
                    NavigationLink(destination: Home(), isActive: $isAuthenticated) {
                        EmptyView()
                    }
                }
            }
            .padding()
        }
        .task {
            await loadUsers()
        }
    }
    
    // Fetch users from the API
    func loadUsers() async {
        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(UserAPIResponse.self, from: data)
            
            // Map the 'fields' to users
            self.users = response.records.map { $0.fields }
        } catch {
            print("Error fetching users: \(error)")
        }
    }

    // Validate login credentials
    func signIn() async {
        guard !users.isEmpty else {
            errorMessage = "Unable to fetch users. Please try again."
            return
        }
        
        // Check if the entered credentials match any user
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            isAuthenticated = true // Login successful
            errorMessage = nil
            print("Login successful for user: \(user.name)")
        } else {
            errorMessage = "Invalid email or password. Please try again."
        }
    }
}

// Unique API Response Models for Users
struct UserAPIResponse: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable {
    let id: String
    let fields: User
}

struct User: Codable {
    let name: String
    let email: String
    let password: String
}

#Preview {
    SignIn()
}
