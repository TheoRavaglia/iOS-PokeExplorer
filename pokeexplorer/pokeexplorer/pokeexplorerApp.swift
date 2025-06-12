import SwiftUI

@main
struct PokeExplorerApp: App {
    let persistence = PersistenceController.shared
    @StateObject var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            if sessionManager.isLoggedIn {
                MainTabView()
                    .environment(\.managedObjectContext, persistence.container.viewContext)
                    .environmentObject(sessionManager)
            } else {
                LoginView()
                    .environment(\.managedObjectContext, persistence.container.viewContext)
                    .environmentObject(sessionManager)
            }
        }
    }
}
