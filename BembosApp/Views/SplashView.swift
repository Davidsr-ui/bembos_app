import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void
    @State private var isActive = false

    var body: some View {
        ZStack {
            BembosTheme.bembosBlue
            Image("bembos_logo1")
                .resizable()
                .scaledToFit()
                .frame(width: 290)
                .accessibilityLabel("Logo oficial de Bembos")
                .scaleEffect(isActive ? 1 : 0.5)
                .opacity(isActive ? 1 : 0)
        }
        .ignoresSafeArea()
        .task {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.72)) {
                isActive = true
            }
            do {
                try await Task.sleep(for: .seconds(2))
                onFinish()
            } catch {
                // Si la vista desaparece, no se navega.
            }
        }
    }
}

#Preview("Splash · bembos_logo1") {
    SplashView(onFinish: {})
}
