//
//  AgentDetailListView.swift
//  Prowler
//
//  Created by Marc Moreno on 22/7/24.
//

import SwiftUI

struct AgentDetailListView: View {
    let agent: Agent
    
    var body: some View {
        ZStack {
            // Verifica que los colores están presentes y se utilizan
            if let colors = agent.backgroundGradientColors, colors.count == 4 {
                LinearGradient(
                    gradient: Gradient(colors: colors.compactMap { Color(hex: $0) }),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Imagen completa del agente
                    if let portraitUrl = agent.fullPortrait, let url = URL(string: portraitUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxHeight: 300)
                        .padding(.bottom, 16)
                    }
                    
                    // Nombre del agente
                    Text(agent.displayName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Descripción del agente
                    if let description = agent.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.top, 8)
                    }
                    
                    // Información del rol del agente
                    if let role = agent.role {
                        HStack {
                            if let roleIcon = role.displayIcon, let url = URL(string: roleIcon) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(role.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                if let roleDescription = role.description {
                                    Text(roleDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.top, 16)
                    }
                    
                    // Mostrar habilidades
                    Text("key_abilities")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 16)
                    
                    ForEach(agent.abilities) { ability in
                        HStack {
                            if let abilityIcon = ability.displayIcon, let url = URL(string: abilityIcon) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(ability.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                if let abilityDescription = ability.description {
                                    Text(abilityDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(agent.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension Color {
    init?(hex: String) {
        let r, g, b, a: CGFloat
        let start = hex.index(hex.startIndex, offsetBy: 0)
        let hexColor = String(hex[start...])

        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255

                self.init(red: r, green: g, blue: b, opacity: a)
                return
            }
        }

        return nil
    }
}
#Preview {
    AgentDetailListView(agent: Agent.example())
}
