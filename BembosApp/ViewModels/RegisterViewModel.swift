import Foundation
import Combine

final class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    @Published var showSuccess = false

    var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !password.isEmpty && !confirmPassword.isEmpty
    }

    func makeUser(existingUsers: [User]) -> User? {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard canSubmit else {
            errorMessage = "Este es un campo obligatorio. Completa todos los campos."
            return nil
        }
        guard LoginViewModel.validEmail(normalizedEmail) else {
            errorMessage = "Ingresa un correo electrónico válido."
            return nil
        }
        guard !existingUsers.contains(where: {
            $0.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == normalizedEmail
        }) else {
            errorMessage = "Este correo ya tiene una cuenta."
            return nil
        }
        guard LoginViewModel.validPassword(password) else {
            errorMessage = "La contraseña debe tener 6 caracteres, una mayúscula y un símbolo permitido."
            return nil
        }
        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden."
            return nil
        }
        errorMessage = nil
        return User(name: name.trimmingCharacters(in: .whitespacesAndNewlines), email: normalizedEmail, password: password)
    }
}
