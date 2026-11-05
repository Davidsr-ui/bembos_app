import SwiftUI

enum BembosTheme {
    static let bembosBlue = Color(hex: 0x1200CC)
    static let bembosBlueLight = Color(hex: 0x3B2FD9)
    static let bembosYellow = Color(hex: 0xF5B82E)
    static let bembosRed = Color(hex: 0xE52620)
    static let bembosError = Color(hex: 0xD32F2F)
    static let bembosInk = Color(hex: 0x3A2F2C)
    static let bembosBackground = Color(hex: 0xF7F7F7)
    static let bembosBorder = Color(hex: 0x9AA0A6)
    static let white = Color.white

    // Al agregar RobotoSlab-Bold.ttf, registrar UIAppFonts en el target.
    static func heading(_ size: CGFloat) -> Font {
        if UIFont(name: "RobotoSlab-Bold", size: size) != nil {
            return .custom("RobotoSlab-Bold", size: size)
        }
        return .system(size: size, weight: .bold, design: .serif)
    }
}

private extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

struct BembosPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 52)
            .foregroundStyle(BembosTheme.white)
            .background(isEnabled ? BembosTheme.bembosBlue : BembosTheme.bembosBorder)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct BembosSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 52)
            .foregroundStyle(BembosTheme.bembosBlue)
            .background(BembosTheme.white)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(BembosTheme.bembosBlue, lineWidth: 1.5))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct BembosTextFieldStyle: TextFieldStyle {
    var focused = false
    var height: CGFloat = 50

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 14)
            .frame(height: height)
            .background(BembosTheme.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(focused ? BembosTheme.bembosBlue : BembosTheme.bembosBorder, lineWidth: focused ? 1.5 : 1)
            }
    }
}

struct BembosCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(BembosTheme.white, in: RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }
}

struct BembosSectionTitle: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(BembosTheme.heading(21))
            .foregroundStyle(BembosTheme.bembosInk)
    }
}

struct BembosBadge: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 10, weight: .heavy))
            .foregroundStyle(BembosTheme.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(BembosTheme.bembosRed, in: Capsule())
    }
}

struct BembosLogo: View {
    let white: Bool

    var body: some View {
        Group {
            if let image = UIImage(named: white ? "bembos_logo_white" : "bembos_logo") {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("Logo oficial de Bembos")
            } else {
                // TODO: reemplazar por logo oficial.
                Text("BEMBOS")
                    .font(BembosTheme.heading(36))
                    .foregroundStyle(white ? BembosTheme.white : BembosTheme.bembosBlue)
                    .accessibilityLabel("Bembos; falta agregar el logo oficial")
            }
        }
    }
}

struct BembosFormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var required = true
    var error: String? = nil
    var fieldHeight: CGFloat = 50
    var labelFontSize: CGFloat = 14

    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 3) {
                Text(title).foregroundStyle(.black)
                if required {
                    Text("*").foregroundStyle(BembosTheme.bembosRed)
                }
            }
            .font(.system(size: labelFontSize, weight: .semibold))

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .foregroundColor(.black)
                .tint(BembosTheme.bembosBlue)
                .focused($focused)
                .padding(.horizontal, 14)
                .frame(height: fieldHeight)
                .background(BembosTheme.white, in: RoundedRectangle(cornerRadius: 6))
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(focused ? BembosTheme.bembosBlue : BembosTheme.bembosBorder,
                                lineWidth: focused ? 1.5 : 1)
                        .allowsHitTesting(false)
                }
            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(BembosTheme.bembosError)
            }
        }
    }
}

struct BembosSecureField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var contentType: UITextContentType = .password
    var error: String? = nil
    var fieldHeight: CGFloat = 50
    var labelFontSize: CGFloat = 14

    private enum FieldFocus: Hashable { case secured, revealed }
    @FocusState private var focusedField: FieldFocus?
    @State private var revealsPassword = false

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 3) {
                Text(title).foregroundStyle(.black)
                Text("*").foregroundStyle(BembosTheme.bembosRed)
            }
            .font(.system(size: labelFontSize, weight: .semibold))

            HStack(spacing: 0) {
                ZStack {
                    SecureField(placeholder, text: $text)
                        .textContentType(contentType)
                        .foregroundColor(.black)
                        .tint(BembosTheme.bembosBlue)
                        .focused($focusedField, equals: .secured)
                        .opacity(revealsPassword ? 0 : 1)
                        .allowsHitTesting(!revealsPassword)
                        .accessibilityHidden(revealsPassword)
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .textContentType(contentType)
                        .foregroundColor(.black)
                        .tint(BembosTheme.bembosBlue)
                        .focused($focusedField, equals: .revealed)
                        .opacity(revealsPassword ? 1 : 0)
                        .allowsHitTesting(revealsPassword)
                        .accessibilityHidden(!revealsPassword)
                }
                .padding(.leading, 14)
                .padding(.trailing, 8)

                Button {
                    let wasFocused = focusedField != nil
                    revealsPassword.toggle()
                    if wasFocused {
                        focusedField = revealsPassword ? .revealed : .secured
                    }
                } label: {
                    Image(systemName: revealsPassword ? "eye.slash" : "eye")
                        .foregroundStyle(BembosTheme.bembosBlue)
                        .frame(width: 32, height: fieldHeight)
                }
                .accessibilityLabel(revealsPassword ? "Ocultar contraseña" : "Mostrar contraseña")
                .padding(.trailing, 12)
            }
            .frame(height: fieldHeight)
            .background(BembosTheme.white, in: RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(focusedField != nil ? BembosTheme.bembosBlue : BembosTheme.bembosBorder,
                            lineWidth: focusedField != nil ? 1.5 : 1)
                    .allowsHitTesting(false)
            }

            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(BembosTheme.bembosError)
            }
        }
    }
}
