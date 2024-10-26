//
//  OnboardingView.swift
//  Prowler
//
//  Created by Marc Moreno on 19/7/24.
//

import SwiftUI

struct OnboardingView: View {
    var bienvenido_onboarding = NSLocalizedString("key_welcome_subtitle", comment: "Welcome Subtitle")
    var busca_onboarding = "Busca informacióm sobre jugadores de Valorant como pueden ser sus ultimas partidas, agentes más usados y estadísticas."
    var ultimaPantalla_onboarding = "¡Explora la aplicación y descubre todas sus funcionalidades!"
    
    
    
    var body: some View {
        TabView{
            OnboardingPage(symbol: "hand.wave.fill" ,title: NSLocalizedString("key_welcome", comment: "Welcome_Onboarding"), description: bienvenido_onboarding)
            OnboardingPage(symbol: "person.fill" ,title: "key_findUsers", description: busca_onboarding)
            OnboardingPage(symbol: "person.fill" ,title: "key_startUsingProwler", description: ultimaPantalla_onboarding, isLastPage: true)
//            OnboardingPage(symbol: "exclamationmark.triangle.fill", title: "Pruebas internas", description: "Esta build está hecha para testeos y otras funciones. No es la versión definitiva" , isLastPage: true ,symbolRendering: .multicolor)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
       
    }
}

#Preview {
    OnboardingView()
}
