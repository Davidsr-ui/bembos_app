import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published private(set) var validEmail: String?
    @Published private(set) var validPassword: String?

    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty
    }

    static func validEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    static func validPassword(_ password: String) -> Bool {
        let specials = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}<>?/\\|:\"'")
        return password.count >= 6
            && password.rangeOfCharacter(from: .uppercaseLetters) != nil
            && password.rangeOfCharacter(from: specials) != nil
    }

    func validate() -> Bool {
        validEmail = nil
        validPassword = nil
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.validEmail(normalized) else {
            errorMessage = "Ingresa un correo electrónico válido."
            return false
        }
        guard Self.validPassword(password) else {
            errorMessage = "La contraseña debe tener 6 caracteres, una mayúscula y un símbolo permitido."
            return false
        }
        validEmail = normalized
        validPassword = password
        errorMessage = nil
        return true
    }
}
