//
//  MainTabView.swift
//  Prowler
//
//  Created by Marc Moreno on 19/7/24.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = AgentsViewModel()
    var body: some View {
        
        TabView{
//            SearchView()
//                .tabItem{
//                    Label("Buscar", systemImage: "magnifyingglass")
//                }
            ProfileView()
                .tabItem{
                    Label("Perfil", systemImage: "person.fill")
                }

            LoadoutView(agents: viewModel.agents)
                .tabItem{
                    Label("key_loadout", systemImage: "book.closed.fill")
                }
            
            
            SettingView()
                .tabItem{
                    Label("key_settings", systemImage: "gear")
                }
        }
        .onAppear(){
            viewModel.loadAgents() //Si la primera vez no ha funcionado
        }
    }
}

#Preview {
    MainTabView()
}
