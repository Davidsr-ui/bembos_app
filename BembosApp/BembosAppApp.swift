//
//  BembosAppApp.swift
//  BembosApp
//
//  Created by Tecsup on 5/11/26.
//

import SwiftUI

@main
struct BembosAppApp: App {
    @StateObject private var session = SessionStore()

    var body: some Scene {
        WindowGroup {
            AppFlowView()
                .environmentObject(session)
                .preferredColorScheme(.light)
        }
    }
}

private struct AppFlowView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var splashFinished = false
    @State private var showingRegister = false

    var body: some View {
        Group {
            if !splashFinished {
                SplashView {
                    splashFinished = true
                }
            } else if session.currentUser != nil {
                HomeView()
            } else {
                NavigationStack {
                    LoginView(onRegister: { showingRegister = true })
                        .navigationDestination(isPresented: $showingRegister) {
                            RegisterView()
                        }
                }
            }
        }
        .tint(BembosTheme.bembosBlue)
    }
}
