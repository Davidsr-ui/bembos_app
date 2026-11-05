import Foundation

struct ItemModel: Identifiable, Hashable {
    let id: UUID
    let name: String
    let subtitle: String
    let price: Decimal
    let imageName: String
    let category: String
    let calories: Int
    let description: String
    let prepTime: Int
    let isNew: Bool
    let isPromo: Bool

    init(name: String, subtitle: String, price: Decimal, imageName: String, category: String,
         calories: Int, description: String, prepTime: Int, isNew: Bool = false, isPromo: Bool = false) {
        self.id = UUID()
        self.name = name
        self.subtitle = subtitle
        self.price = price
        self.imageName = imageName
        self.category = category
        self.calories = calories
        self.description = description
        self.prepTime = prepTime
        self.isNew = isNew
        self.isPromo = isPromo
    }

    var formattedPrice: String {
        String(format: "S/ %.2f", NSDecimalNumber(decimal: price).doubleValue)
    }
}
