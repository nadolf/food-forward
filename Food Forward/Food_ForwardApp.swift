import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Food_ForwardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                if authViewModel.accountType == "individual"{
                    IndividualHomeView().environmentObject(authViewModel)
                } else if authViewModel.accountType == "establishment"{
                    EstablishmentHomeView().environmentObject(authViewModel)
                }
            } else {
                SignInView()
            }
        }
    }
}
