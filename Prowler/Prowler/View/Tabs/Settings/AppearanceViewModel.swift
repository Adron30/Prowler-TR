import SwiftUI

class AppearanceViewModel: ObservableObject {
    @Published var selectedAppearance: AppearanceOption {
        didSet {
            saveAppearancePreference()
        }
    }

    init() {
        self.selectedAppearance = AppearanceOption(rawValue: UserDefaults.standard.string(forKey: "appearance") ?? "system") ?? .system
    }

    private func saveAppearancePreference() {
        UserDefaults.standard.set(selectedAppearance.rawValue, forKey: "appearance")
    }
}

enum AppearanceOption: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"

    var displayName: String {
        switch self {
        case .light:
            return NSLocalizedString("key_light", comment: "Light Mode")
        case .dark:
            return NSLocalizedString("key_dark", comment: "Dark Mode")
        case .system:
            return NSLocalizedString("key_default", comment: "por defecto")
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
