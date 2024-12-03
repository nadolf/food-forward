import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMeCheckbox = false
    var body: some View {
        VStack{
            //Logo Icon
            Text("Welcome to Food Forward")
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            HStack{
                Toggle(isOn: $rememberMeCheckbox) {
                    Text("Remember Me")
                }
                
                Button("Forget Password?"){
                    //Navigate to Reset Password Page
                }
            }
            Button("Sign In"){
                // Navigate to home page
            }.buttonStyle(.borderedProminent)
            HStack{
                Text("Don't Have an Account?")
                Button("Sign Up") {
                    //Navigate to Sign Up Page
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
