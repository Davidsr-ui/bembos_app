import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var items: [ItemModel] = HomeViewModel.catalog
    @Published var searchText = ""
    @Published private(set) var filteredItems: [ItemModel] = HomeViewModel.catalog
    @Published private(set) var recommendedItems: [ItemModel] = HomeViewModel.catalog.filter(\.isPromo)

    init() {
        $items
            .combineLatest($searchText.debounce(for: .milliseconds(250), scheduler: RunLoop.main))
            .map { items, query in
                let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !term.isEmpty else { return items }
                return items.filter {
                    $0.name.localizedCaseInsensitiveContains(term)
                        || $0.subtitle.localizedCaseInsensitiveContains(term)
                        || $0.category.localizedCaseInsensitiveContains(term)
                }
            }
            .assign(to: &$filteredItems)

        $filteredItems
            .map { $0.filter(\.isPromo) }
            .assign(to: &$recommendedItems)
    }

    private static let catalog: [ItemModel] = [
        ItemModel(name: "Hamburguesa Clásica", subtitle: "La original de siempre", price: 18.90, imageName: "fork.knife", category: "Hamburguesas", calories: 540, description: "Carne a la parrilla, vegetales frescos y salsa de la casa.", prepTime: 15),
        ItemModel(name: "Royal", subtitle: "Con queso y sabor a lo grande", price: 24.90, imageName: "fork.knife", category: "Hamburguesas", calories: 680, description: "Hamburguesa a la parrilla con queso y nuestros complementos favoritos.", prepTime: 17, isPromo: true),
        ItemModel(name: "Extrema", subtitle: "Para un hambre extrema", price: 29.90, imageName: "fork.knife", category: "Hamburguesas", calories: 850, description: "Una hamburguesa contundente para quienes quieren más sabor.", prepTime: 20),
        ItemModel(name: "Hawaiana", subtitle: "Un toque tropical", price: 25.90, imageName: "fork.knife", category: "Hamburguesas", calories: 710, description: "Carne a la parrilla con piña y una mezcla dulce y salada.", prepTime: 18),
        ItemModel(name: "Cheese Bacon", subtitle: "Queso y tocino crocante", price: 27.90, imageName: "fork.knife", category: "Hamburguesas", calories: 790, description: "Queso fundido y tocino crocante sobre carne a la parrilla.", prepTime: 18, isNew: true),
        ItemModel(name: "Pollo Crispy", subtitle: "Crujiente en cada bocado", price: 23.90, imageName: "fork.knife", category: "Pollo", calories: 620, description: "Filete de pollo crocante con vegetales y salsa de la casa.", prepTime: 16),
        ItemModel(name: "Salchipapa", subtitle: "Papas y salchicha para compartir", price: 17.90, imageName: "takeoutbag.and.cup.and.straw.fill", category: "Acompañamientos", calories: 590, description: "Papas doradas con salchichas y salsas a elección.", prepTime: 12),
        ItemModel(name: "Combo con Inca Kola", subtitle: "Hamburguesa, papas y bebida", price: 34.90, imageName: "takeoutbag.and.cup.and.straw.fill", category: "Combos", calories: 1010, description: "Tu hamburguesa con papas y una Inca Kola para completar el pedido.", prepTime: 20, isPromo: true)
    ]
}
