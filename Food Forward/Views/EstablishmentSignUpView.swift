import SwiftUI
import PhotosUI

struct EstablishmentSignUpView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var address: String = ""
    @State var phoneNumber: String = ""
    @State var bio: String = "Bio"
    @State var selectedPhoto: [PhotosPickerItem] = []
    
    var body: some View {
        Text("Create Account")
        
        // Profile Photo Icon
        ZStack {
            // Circle background
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100) // Overall circle size
            // Icon inside the circle
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50) // Icon size
                .foregroundColor(.white)
        }
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 4) // Border
        )
        
        PhotosPicker(selection: $selectedPhoto,
                     matching: .any(of: [.images, .not(.screenshots)])) {
            Text("Change Profile Picture")
        }
        
        TextField("Name", text: $name)
        TextField("Email Address", text: $email)
        SecureField("Password", text: $password)
        SecureField("Confirm Password", text: $confirmPassword)
        TextField("Address", text: $address)
        TextField("Phone Number", text: $phoneNumber)
        TextEditor(text: $bio)
    }
}

#Preview {
    EstablishmentSignUpView()
}
