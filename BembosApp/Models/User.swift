import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String
    let password: String

    init(name: String, email: String, password: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.password = password
    }
}
