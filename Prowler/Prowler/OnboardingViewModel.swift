//
//  OnboardingViewModel.swift
//  Prowler
//
//  Created by Marc Moreno on 19/7/24.
//

import Foundation
//Control del onboarding
class OnboardingViewModel: ObservableObject {
    @Published var hasSeenOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding")
        }
    }

    init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }

    func completeOnboarding() {
        hasSeenOnboarding = true
    }
}
