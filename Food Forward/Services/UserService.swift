import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserService {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    //Register User
    func registerUser(user: User, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: user.email, password: user.password) { authResult, error in
            if let error = error {
                print("Error during registration: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Save user data to Firestore
            guard let authResult = authResult else { return }
            let userRef = self.db.collection("users").document(authResult.user.uid)

            let userData: [String: Any] = [
                "email": user.email,
                "phoneNumber": user.phoneNumber,
                "address": user.address,
                "profilePhotoURL": user.profilePhotoURL,
                "accountType": user.accountType,
                "firstName": user.firstName ?? "",
                "lastName": user.lastName ?? "",
                "name": user.name ?? "",
                "bio": user.bio ?? ""
            ]
            
            userRef.setData(userData) { error in
                if let error = error {
                    print("Error saving user data to Firestore: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }

    // Sign In Functionality
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error during sign-in: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let user = authResult?.user, user.isEmailVerified else {
                print("Email is not verified yet.")
                completion(false)
                return
            }

            completion(true)
        }
    }
    
    // Fetch User Data
    func fetchUserDetails(userId: String, completion: @escaping (User?) -> Void) {
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let document = document, document.exists,
                  let data = document.data() else {
                print("No user data found for user ID \(userId)")
                completion(nil)
                return
            }

            let user = User(
                id: userId,
                email: data["email"] as? String ?? "",
                phoneNumber: data["phoneNumber"] as? String ?? "",
                address: data["address"] as? String ?? "",
                profilePhotoURL: data["profilePhotoURL"] as? String ?? "",
                accountType: data["accountType"] as? String ?? "",
                firstName: data["firstName"] as? String,
                lastName: data["lastName"] as? String,
                name: data["name"] as? String,
                bio: data["bio"] as? String,
                password: "",
                confirmPassword: ""
            )

            completion(user)
        }
    }

    func getCurrentUserId() -> String? {
        return auth.currentUser?.uid
    }


    // Sign Out Functionality
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
