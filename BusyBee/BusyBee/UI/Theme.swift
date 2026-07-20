import SwiftUI

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: ThemeProtocol = LightTheme()
}

extension EnvironmentValues {
    var theme: ThemeProtocol {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

protocol ThemeProtocol {
    var backgroundColor: Color { get }
    var primaryColor: Color { get }
    var containerText: Color { get }
    var textColor: Color { get }
    var colorScheme: ColorScheme { get }
}

struct LightTheme: ThemeProtocol {
    let backgroundColor = Color.white
    let primaryColor: Color = .blue
    let containerText: Color = .white
    let textColor = Color.black
    let colorScheme: ColorScheme = .light
}

struct DarkTheme: ThemeProtocol {
    let backgroundColor = Color.black
    let primaryColor: Color = .blue
    let containerText: Color = .white
    let textColor = Color.white
    let colorScheme: ColorScheme = .dark
}

