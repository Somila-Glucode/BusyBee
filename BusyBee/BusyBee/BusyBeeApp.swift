import SwiftUI

@Observable
class AppSettings {
    var isDarkMode = false
}

@main
struct BusyBeeApp: App {
    @State private var settings = AppSettings()
    
    var body: some Scene {
        let currentTheme: ThemeProtocol = settings.isDarkMode ? DarkTheme() : LightTheme()
        
        WindowGroup {
            ContentView()
                .environment(settings)
                .environment(\.theme, currentTheme)
        }
    }
}
