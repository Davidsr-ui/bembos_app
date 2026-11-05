import Foundation
import Combine

final class SessionStore: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var currentUser: User?
    private let defaults: UserDefaults
    private let usersKey = "bembos_users"

    enum SignInResult {
        case success
        case userNotFound
        case incorrectPassword
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: usersKey),
           let savedUsers = try? JSONDecoder().decode([User].self, from: data) {
            users = savedUsers
        }
        // currentUser solo vive en memoria: cada apertura empieza en Splash → Login.
    }

    func register(_ user: User) {
        users.append(user)
        saveUsers()
    }

    func signIn(email: String, password: String) -> SignInResult {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let user = users.first(where: {
            $0.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == normalizedEmail
        }) else { return .userNotFound }
        guard user.password == password else { return .incorrectPassword }
        currentUser = user
        return .success
    }

    // Usado únicamente para preparar la preview de Home; el registro no inicia sesión.
    func completeRegistration(for user: User) {
        currentUser = user
    }

    func signOut() {
        currentUser = nil
    }

    private func saveUsers() {
        // Demo académica: en producción, contraseñas con hash y credenciales en Keychain.
        if let data = try? JSONEncoder().encode(users) {
            defaults.set(data, forKey: usersKey)
        }
    }
}
