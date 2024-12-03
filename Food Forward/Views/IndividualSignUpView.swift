import SwiftUI
import PhotosUI

struct IndividualSignUpView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var address: String = ""
    @State var phoneNumber: String = ""
    @State var selectedPhoto: [PhotosPickerItem] = []

    var body: some View{
        VStack{
            Text("Create Account")
            
            //Profile Photo Icon
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
            
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Email Address", text: $email)
            SecureField("Password", text: $password)
            SecureField("Confirm Password", text: $confirmPassword)
            TextField("Address", text: $address)
            TextField("Phone Number", text: $phoneNumber)
            
            Button("Create Account"){}.buttonStyle(.borderedProminent)
        }
    }
    
}

#Preview {
    IndividualSignUpView()
}
