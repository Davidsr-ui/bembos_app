import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        searchBar
                        addressPill

                        HStack {
                            BembosSectionTitle(title: selectedTab == 0 ? "Explora nuestro menú" : "Nuestro menú")
                            Spacer()
                            if selectedTab == 0 {
                                Button("Ver todo") { selectedTab = 1 }
                                    .font(.system(size: 14, weight: .bold))
                                    .underline()
                            }
                        }
                        .padding(.top, 8)

                        if selectedTab == 0 {
                            if !viewModel.recommendedItems.isEmpty {
                                productSection("Promociones", items: viewModel.recommendedItems)
                            }
                            if !viewModel.filteredItems.isEmpty {
                                productSection("Los más vendidos", items: Array(viewModel.filteredItems.prefix(4)))
                            }
                        }

                        if !viewModel.filteredItems.isEmpty {
                            BembosSectionTitle(title: "Todos los productos")
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 14) {
                                ForEach(viewModel.filteredItems) { item in
                                    NavigationLink(value: item) {
                                        ItemRowView(item: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        if viewModel.filteredItems.isEmpty {
                            Text("No encontramos productos para tu búsqueda.")
                                .foregroundStyle(BembosTheme.bembosInk)
                                .padding(.vertical, 25)
                        }
                    }
                    .padding(18)
                }
                .background(BembosTheme.bembosBackground)

                tabBar
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: ItemModel.self) { item in
                ItemDetailView(item: item)
            }
        }
    }

    private var header: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .font(.title2)
                .accessibilityLabel("Perfil de \(session.currentUser?.name ?? "usuario")")
            Spacer()
            Button {
                session.signOut()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.title2)
            }
            .accessibilityLabel("Cerrar sesión")
            Image(systemName: "cart")
                .font(.title2)
                .padding(.leading, 10)
                .accessibilityLabel("Carrito")
        }
        .foregroundStyle(BembosTheme.white)
        .padding(.horizontal, 20)
        .frame(height: 58)
        .background(BembosTheme.bembosBlue.ignoresSafeArea(edges: .top))
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(BembosTheme.bembosBlue)
                TextField("Busca tu antojo", text: $viewModel.searchText)
                    .accessibilityLabel("Buscar productos")
                    .autocorrectionDisabled()
            }
            .padding(12)
            .background(BembosTheme.white, in: RoundedRectangle(cornerRadius: 7))
            .overlay(RoundedRectangle(cornerRadius: 7).stroke(BembosTheme.bembosBlue, lineWidth: 1.5))

            Button {} label: {
                Image(systemName: "mic.fill")
                    .foregroundStyle(BembosTheme.white)
                    .frame(width: 44, height: 44)
                    .background(BembosTheme.bembosBlue, in: Circle())
            }
            .accessibilityLabel("Búsqueda por voz no disponible")
        }
    }

    private var addressPill: some View {
        HStack(spacing: 10) {
            Image(systemName: "mappin.circle.fill")
            VStack(alignment: .leading, spacing: 2) {
                Text("¡Comienza tu pedido!").fontWeight(.bold)
                Text("Elige tu dirección").font(.subheadline)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(BembosTheme.bembosInk)
        .padding(15)
        .background(BembosTheme.bembosYellow, in: Capsule())
        .accessibilityElement(children: .combine)
    }

    private func productSection(_ title: String, items: [ItemModel]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            BembosSectionTitle(title: title)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            ItemRowView(item: item)
                                .frame(width: 178)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    private var tabBar: some View {
        HStack {
            tab(icon: "house.fill", title: "Home", index: 0)
            tab(icon: "menucard", title: "Menú", index: 1)
        }
        .padding(.top, 9)
        .background(BembosTheme.white.shadow(.drop(color: .black.opacity(0.08), radius: 4, y: -2)))
    }

    private func tab(icon: String, title: String, index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.title3)
                Text(title).font(.caption.weight(.bold))
            }
            .foregroundStyle(selectedTab == index ? BembosTheme.bembosBlue : BembosTheme.bembosBorder)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
        }
        .accessibilityAddTraits(selectedTab == index ? [.isSelected] : [])
    }
}

#Preview("Home · promociones y grilla") {
    let session = SessionStore()
    session.completeRegistration(for: User(name: "Ana", email: "ana@ejemplo.com", password: "Demo!1"))
    return HomeView().environmentObject(session)
}
