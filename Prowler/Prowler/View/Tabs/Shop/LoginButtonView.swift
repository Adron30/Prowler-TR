//
//  LoginButtonView.swift
//  Prowler
//
//  Created by Marc Moreno on 23/8/24.
//

import SwiftUI

struct LoginButtonView: View {
    @State var showAlert: Bool = false
    @State private var showSheet: Bool = false
    var body: some View {
        HStack {
            Text("key_logInWithRiot")
                
               
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Image(.riotIcon)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
        }
        .padding(10.0)
        .background(Color(red: 0.924, green: -0.006, blue: 0.16))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            showAlert = true
        }
        .alert("key_aboutToLogInWithRiot", isPresented: $showAlert)
        {
            Button("key_continue", role: .destructive){
               showSheet = true
            }
            Button("key_cancel", role: .cancel){
                
            }
        } message: {
            Text("key_youResponsability")
        }
        .sheet(isPresented: $showSheet, content: {
            RiotLoginView()
        })
        
    }
}

#Preview {
    LoginButtonView()
}
