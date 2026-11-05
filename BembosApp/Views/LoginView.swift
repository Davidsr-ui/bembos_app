import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = LoginViewModel()
    let onRegister: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 24)
                    VStack(spacing: 20) {
                        BembosLogo(white: false)
                            .frame(width: 290, height: 165)
                            .padding(.bottom, 12)

                        BembosFormField(title: "Correo electrónico", placeholder: "nombre@dominio.com", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocorrectionDisabled()
                        BembosSecureField(title: "Contraseña", placeholder: "Ingresa tu contraseña", text: $viewModel.password)

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(BembosTheme.bembosError)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button("Iniciar sesión") {
                            if viewModel.validate(),
                               let email = viewModel.validEmail,
                               let password = viewModel.validPassword {
                                switch session.signIn(email: email, password: password) {
                                case .success:
                                    viewModel.errorMessage = nil
                                case .userNotFound:
                                    viewModel.errorMessage = "Cuenta no encontrada. Crea una cuenta para empezar."
                                case .incorrectPassword:
                                    viewModel.errorMessage = "Contraseña incorrecta."
                                }
                            }
                        }
                        .buttonStyle(BembosPrimaryButtonStyle())
                        .disabled(!viewModel.canSubmit)

                        Button("¿No tienes cuenta? Regístrate", action: onRegister)
                            .font(.system(size: 14, weight: .bold))
                            .underline()
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: 500)
                    Spacer(minLength: 24)
                    Spacer(minLength: 24)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height)
            }
            .environment(\.colorScheme, .light)
        }
        .background(BembosTheme.white)
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct LoginPreview: View {
    @State private var showingRegister = false

    var body: some View {
        NavigationStack {
            LoginView(onRegister: { showingRegister = true })
                .navigationDestination(isPresented: $showingRegister) {
                    RegisterView()
                }
        }
        .environmentObject(SessionStore(defaults: UserDefaults(suiteName: "bembos.preview") ?? .standard))
        .preferredColorScheme(.light)
    }
}

#Preview("Login · cuentas guardadas") {
    LoginPreview()
}
