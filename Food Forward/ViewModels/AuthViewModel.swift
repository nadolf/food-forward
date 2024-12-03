import SwiftUI
import Combine
import Foundation

class AuthViewModel: ObservableObject {
    // Individual Specific
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    // Establishment Specific
    @Published var name: String = ""
    @Published var bio: String = ""
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var phoneNumber: String = ""
    @Published var address: String = ""
    @Published var profilePhotoURL: String = "" // Firebase Storage URL
    @Published var accountType: String = "" // "individual" or "Establishment"
    @Published var isAuthenticated: Bool = false

    // Alerts
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let validationService = ValidationService()
    private let userService = UserService()
    

    func individualSignUp() {
        if !validationService.isValidEmail(email) {
            alertMessage = "Invalid Email"
            showAlert = true
            return
        }
        
        if !validationService.isValidPassword(password) {
            alertMessage = "Invalid Password"
            showAlert = true
            return
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        if firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty || address.isEmpty {
            alertMessage = "All fields must be filled"
            showAlert = true
            return
        }
        
        // Create user model for individual
        let user = User(
            id: UUID().uuidString,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            profilePhotoURL: profilePhotoURL,
            accountType: "individual",
            firstName: firstName,
            lastName: lastName
        )
        
        // Register individual user
        userService.registerUser(user: user) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                } else {
                    self?.alertMessage = "Registration failed. Try again."
                    self?.showAlert = true
                }
            }
        }
    }
    
    func establishmentSignUp() {
        if !validationService.isValidEmail(email) {
            alertMessage = "Invalid Email"
            showAlert = true
            return
        }
        
        if !validationService.isValidPassword(password) {
            alertMessage = "Invalid Password"
            showAlert = true
            return
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        if name.isEmpty || bio.isEmpty || phoneNumber.isEmpty || address.isEmpty {
            alertMessage = "All fields must be filled"
            showAlert = true
            return
        }
        
        // Create user model for Establishment
        let user = User(
            id: UUID().uuidString,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            profilePhotoURL: profilePhotoURL,
            accountType: "establishment",
            name: name,
            bio: bio
        )
        
        // Register Establishment
        userService.registerUser(user: user) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                } else {
                    self?.alertMessage = "Registration failed. Try again."
                    self?.showAlert = true
                }
            }
        }
    }
    
    // Sign-Up Functionality
    func signUp() {
        if accountType == "individual" {
            individualSignUp()
        } else if accountType == "establishment" {
            establishmentSignUp()
        } else {
            alertMessage = "Invalid account type selected."
            showAlert = true
        }
    }
    
    // Sign-In Functionality
    func signIn() {
        if !validationService.isValidEmail(email) {
            alertMessage = "Invalid Email"
            showAlert = true
            return
        }
        
        if !validationService.isValidPassword(password) {
            alertMessage = "Invalid Password"
            showAlert = true
            return
        }
        
        // Sign In Logic
        userService.signIn(email: email, password: password) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                } else {
                    self?.alertMessage = "Sign-In failed. Check credentials."
                    self?.showAlert = true
                }
            }
        }
    }
    
    // Sign-Out Functionality
    func signOut() {
        userService.signOut()
        isAuthenticated = false
    }
}
