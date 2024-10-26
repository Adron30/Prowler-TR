//
//  RiotProfileView.swift
//  Prowler
//
//  Created by Marc Moreno on 27/7/24.
//

import SwiftUI

struct RiotProfileView: View {
    var username: String

    var body: some View {
        VStack {
            Text("Welcome,")
                .font(.largeTitle)
                .padding(.top, 50)
            
            Text(username)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Spacer()
        }
        .navigationTitle("Profile")
        .padding()
    }
}

#Preview {
    RiotProfileView(username: "TestUser#0001")
}
