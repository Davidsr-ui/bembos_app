import SwiftUI

struct ItemRowView: View {
    let item: ItemModel
    @State private var added = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: item.imageName)
                .font(.system(size: 48))
                .foregroundStyle(BembosTheme.bembosBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .background(BembosTheme.bembosBackground, in: RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .topLeading) {
                    if item.isPromo {
                        BembosBadge(title: "PROMO BOMBA")
                            .padding(6)
                    }
                }
                .accessibilityLabel("Imagen referencial de \(item.name)")

            HStack(alignment: .top, spacing: 4) {
                Text(item.name)
                    .font(BembosTheme.heading(16))
                    .foregroundStyle(BembosTheme.bembosInk)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "heart")
                    .foregroundStyle(BembosTheme.bembosRed)
                    .accessibilityHidden(true)
            }
            .frame(height: 42, alignment: .top)

            Text(item.subtitle)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .frame(height: 34, alignment: .topLeading)

            Spacer(minLength: 0)

            HStack(alignment: .bottom, spacing: 4) {
                VStack(alignment: .leading, spacing: 2) {
                    if item.isPromo {
                        Text(String(format: "S/ %.2f", NSDecimalNumber(decimal: item.price).doubleValue * 1.2))
                            .strikethrough()
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .accessibilityLabel("Precio anterior referencial")
                    }
                    Text(item.formattedPrice)
                        .font(BembosTheme.heading(17))
                        .foregroundStyle(BembosTheme.bembosInk)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
                Button {
                    added.toggle()
                } label: {
                    Image(systemName: added ? "checkmark" : "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(BembosTheme.white)
                        .frame(width: 34, height: 34)
                        .background(BembosTheme.bembosBlue, in: Circle())
                }
                .buttonStyle(.borderless)
                .accessibilityLabel(added ? "Producto marcado" : "Agregar \(item.name)")
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 320)
        .background(BembosTheme.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }
}

#Preview("Card de promoción") {
    ItemRowView(item: ItemModel(name: "Royal", subtitle: "Con queso", price: 24.90,
                                imageName: "fork.knife", category: "Hamburguesas", calories: 680,
                                description: "Carne a la parrilla.", prepTime: 17, isPromo: true))
        .frame(width: 178)
        .padding()
        .background(BembosTheme.bembosBackground)
}
