import SwiftUI
import PhotosUI

struct EstablishmentSignUpView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State var selectedPhoto: [PhotosPickerItem] = []
    
    var body: some View {
        Text("Create Account")
        
        // Profile Photo Icon
        ZStack {
            // Circle background
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
            // Icon inside the circle
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
        }
        .overlay(
            Circle()
                .stroke(Color.white, lineWidth: 4)
        )
        
        PhotosPicker(selection: $selectedPhoto,
                     matching: .any(of: [.images, .not(.screenshots)])) {
            Text("Change Profile Picture")
        }
        
        //Text Fields Sections
        TextField("Name", text: $authViewModel.name)
        TextField("Email Address", text: $authViewModel.email)
        SecureField("Password", text: $authViewModel.password)
        SecureField("Confirm Password", text: $authViewModel.confirmPassword)
        TextField("Address", text: $authViewModel.address)
        TextField("Phone Number", text: $authViewModel.phoneNumber)
        TextEditor(text: $authViewModel.bio)
    }
}

#Preview {
    EstablishmentSignUpView()
}
