import Foundation
import FirebaseAuth
import Combine

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
    @Published var profilePhotoURL: String = ""
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
        
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || phoneNumber.isEmpty || address.isEmpty {
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
            lastName: lastName,
            name: nil,
            bio: nil,
            password: password,
            confirmPassword: confirmPassword
        )
        
        // Register individual user
        userService.registerUser(user: user) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.sendEmailVerification() // Email verification
                } else {
                    self?.alertMessage = "Sign Up failed, Please try again."
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
            firstName: nil,
            lastName: nil,
            name: name,
            bio: bio,
            password: password,
            confirmPassword: confirmPassword
        )
        
        // Register Establishment
        userService.registerUser(user: user) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.sendEmailVerification() // Email verification
                } else {
                    self?.alertMessage = "Sign Up failed, Please try again."
                    self?.showAlert = true
                }
            }
        }
    }
    
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
    
    private func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = "Failed to send email verification: \(error.localizedDescription)"
                    self?.showAlert = true
                } else {
                    self?.alertMessage = "Account created! Please verify your email before signing in."
                    self?.showAlert = true
                }
            }
        }
    }
    
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

        userService.signIn(email: email, password: password) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.fetchUserData() // Fetch user data after sign-in
                    self?.isAuthenticated = true
                } else {
                    self?.alertMessage = "Unsuccessful Sign-in. Please check email and/or password"
                    self?.showAlert = true
                }
            }
        }
    }
    
    func getCurrentUserID() -> String? {
        return userService.getCurrentUserId()
    }

    func fetchUserData() {
        guard let userId = userService.getCurrentUserId() else {
            print("User ID does not exist")
            return
        }

        userService.fetchUserDetails(userId: userId) { [weak self] user in
            DispatchQueue.main.async {
                if let user = user {
                    print("User data fetched: \(user)")
                    self?.firstName = user.firstName ?? ""
                    self?.lastName = user.lastName ?? ""
                    self?.email = user.email
                    self?.phoneNumber = user.phoneNumber
                    self?.address = user.address
                    self?.profilePhotoURL = user.profilePhotoURL
                    self?.accountType = user.accountType
                } else {
                    print("Failed to fetch user data")
                    self?.alertMessage = "Failed to fetch user data."
                    self?.showAlert = true
                }
            }
        }
    }
    
    func signOut() {
        userService.signOut()
        isAuthenticated = false
    }
}
