import SwiftUI

struct ItemDetailView: View {
    let item: ItemModel
    @State private var added = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: item.imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(BembosTheme.bembosBlue)
                    .padding(55)
                    .frame(maxWidth: .infinity)
                    .frame(height: 270)
                    .background(BembosTheme.white, in: RoundedRectangle(cornerRadius: 16))
                    .accessibilityLabel("Imagen referencial de \(item.name)")

                if item.isPromo { BembosBadge(title: "PROMO BOMBA") }
                Text(item.name)
                    .font(BembosTheme.heading(30))
                    .foregroundStyle(BembosTheme.bembosInk)
                Text(item.subtitle)
                    .font(.headline)
                Text(item.description)
                    .foregroundStyle(BembosTheme.bembosInk)
                Text(item.formattedPrice)
                    .font(BembosTheme.heading(25))
                    .foregroundStyle(BembosTheme.bembosBlue)

                BembosCard {
                    VStack(alignment: .leading, spacing: 12) {
                        attribute("Categoría", value: item.category)
                        attribute("Calorías aprox.", value: "\(item.calories) kcal")
                        attribute("Preparación aprox.", value: "\(item.prepTime) min")
                        attribute("Novedad", value: item.isNew ? "Nuevo" : "Favorito de siempre")
                    }
                }

                Button(added ? "Agregado al pedido ✓" : "Agregar al pedido") {
                    added = true // Pedido temporal en esta pantalla.
                }
                .buttonStyle(BembosPrimaryButtonStyle())
            }
            .padding(20)
        }
        .background(BembosTheme.bembosBackground)
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }

    private func attribute(_ label: String, value: String) -> some View {
        HStack {
            Text(label).fontWeight(.semibold)
            Spacer()
            Text(value)
        }
        .foregroundStyle(BembosTheme.bembosInk)
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(item: ItemModel(name: "Royal", subtitle: "Con queso y sabor a lo grande",
                                       price: 24.90, imageName: "fork.knife", category: "Hamburguesas",
                                       calories: 680, description: "Carne a la parrilla con queso.", prepTime: 17))
    }
}
