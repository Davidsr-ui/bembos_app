import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 28) {
                        BembosFormField(title: "Nombre", placeholder: "Tu nombre", text: $viewModel.name,
                                        fieldHeight: 56, labelFontSize: 16)
                            .textContentType(.name)
                        BembosFormField(title: "Correo electrónico", placeholder: "nombre@dominio.com", text: $viewModel.email,
                                        fieldHeight: 56, labelFontSize: 16)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocorrectionDisabled()
                        BembosSecureField(title: "Contraseña", placeholder: "Crea una contraseña", text: $viewModel.password,
                                          contentType: .newPassword, fieldHeight: 56, labelFontSize: 16)
                        BembosSecureField(title: "Confirmar contraseña", placeholder: "Repite tu contraseña", text: $viewModel.confirmPassword,
                                          contentType: .newPassword, fieldHeight: 56, labelFontSize: 16)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(BembosTheme.bembosError)
                                .padding(.bottom, 12)
                        }
                        if viewModel.showSuccess {
                            Text("Cuenta creada ✓")
                                .font(.headline)
                                .foregroundStyle(BembosTheme.bembosBlue)
                                .accessibilityAddTraits(.updatesFrequently)
                                .padding(.bottom, 12)
                        }

                        Button("Crear cuenta") {
                            guard let user = viewModel.makeUser(existingUsers: session.users) else { return }
                            session.register(user)
                            viewModel.showSuccess = true
                            Task {
                                do {
                                    try await Task.sleep(for: .milliseconds(1200))
                                    dismiss()
                                } catch {
                                    // Evita navegar si se cancela la tarea.
                                }
                            }
                        }
                        .buttonStyle(BembosPrimaryButtonStyle())
                        .disabled(viewModel.showSuccess)
                    }
                    .padding(.top, 32)

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: 500)
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height)
            }
            .environment(\.colorScheme, .light)
        }
        .background(BembosTheme.white)
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(BembosTheme.bembosBlue, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark) // Status bar blanco; el formulario conserva su modo claro.
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(BembosTheme.white)
                }
                .accessibilityLabel("Regresar")
            }
            ToolbarItem(placement: .principal) {
                Text("Crear cuenta")
                    .font(BembosTheme.heading(20))
                    .foregroundStyle(BembosTheme.white)
            }
        }
    }
}

#Preview("Registro · cuatro campos editables") {
    NavigationStack {
        RegisterView()
    }
    .environmentObject(SessionStore(defaults: UserDefaults(suiteName: "bembos.preview") ?? .standard))
}
