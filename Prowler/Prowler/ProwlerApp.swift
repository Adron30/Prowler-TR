import SwiftUI
@main
struct ValorantTrackerApp: App {
    @StateObject var onboardingViewModel = OnboardingViewModel()
    @StateObject private var appearanceViewModel = AppearanceViewModel()
//Cambiar vistas
    var body: some Scene {
        WindowGroup {
            if onboardingViewModel.hasSeenOnboarding {
                MainTabView()
            } else {
                OnboardingView()
                    .environmentObject(onboardingViewModel)
                    .preferredColorScheme(appearanceViewModel.selectedAppearance.colorScheme)
            }
        }
    }
}
