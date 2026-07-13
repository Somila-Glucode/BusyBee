import SwiftUI

protocol ThemeProtocol {
    var backgroundColor: Color { get }
    var primaryColor: Color { get }
    var textColor: Color { get }
}

struct LightTheme: ThemeProtocol {
    let backgroundColor = Color.white
    let primaryColor: Color = .blue
    let textColor = Color.black
}

struct DarkTheme: ThemeProtocol {
    let backgroundColor = Color.black
    let primaryColor: Color = .blue
    let textColor = Color.white
}

