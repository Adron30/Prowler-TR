//
//  OnboardingPage.swift
//  Prowler
//
//  Created by Marc Moreno on 20/7/24.
//

import SwiftUI


struct OnboardingPage: View {
    let symbol: String
    let title: String
    let description: String
    var isLastPage: Bool = false
    var symbolRendering: SymbolRenderingMode = .monochrome
    
    
   @State private var currentStep  = 0
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var showMainTabView = false
    
    var body: some View {
        VStack {
            VStack{
                    Image(systemName: symbol)
                        .symbolRenderingMode(symbolRendering)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .font(.largeTitle)
                        .padding()
                    
                    
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    
                    Text(description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    
                    
                    if isLastPage {
                        Button(action: {
                            onboardingViewModel.completeOnboarding()
                        }) {
                            Text("Comenzar")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                }
            
           
        }
        
    }
}

    #Preview {
        OnboardingPage(symbol: "hand.palm.facing.fill", title: "Bienvenido", description: "Bienvenido a Prowler")
    
}
