//
//  SettingsListView.swift
//  Prowler
//
//  Created by Marc Moreno on 22/7/24.
//

import SwiftUI

struct SettingsListView: View {
    @StateObject private var appearanceViewModel = AppearanceViewModel()
private var DiscordLink = URL(string: "https://discord.gg/BhSCnMFrSr")!
    @State var isSheetOpen: Bool = false
    @State var isSheetOpen2: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("key_app")) {
                    Picker("key_Appearance", selection: $appearanceViewModel.selectedAppearance) {
                        ForEach(AppearanceOption.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    HStack {
                        Button("key_language"){
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                     UIApplication.shared.open(url)
                                 }
                        }
                                                   
        
                        Spacer()
                        Text(Locale.current.language.languageCode!.identifier.uppercased())
                            .foregroundStyle(.gray)
                    }
                }
                

                // Otras secciones...
                
                
                Section(header: Text("key_commentsFeedback")){
                    Button("key_sendFeedback"){
                        openDiscordLink()
                    }
                    Button("key_reportError"){
                        openDiscordLink()
                    }
                   
                }
                Section(header: Text("key_about")) {
                        NavigationLink("key_aboutDev", destination: aboutDevView())
                        NavigationLink("key_credits", destination: creditsView())
                }
            }
            .navigationTitle("key_settings")
            .preferredColorScheme(appearanceViewModel.selectedAppearance.colorScheme) // Aplica el esquema de color seleccionado
        }
    }
    private func openDiscordLink(){
        UIApplication.shared.open(DiscordLink)
    }
    
}

#Preview {
    SettingsListView()
}
