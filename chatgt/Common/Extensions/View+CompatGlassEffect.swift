import SwiftUI

// MARK: - Types

enum CompatGlassShape {
    case rect(cornerRadius: CGFloat)
    case circle
}

enum CompatGlassStyle {
    case regular
    case clear
}

// MARK: - View Extension

extension View {
    @ViewBuilder
    func compatGlassEffect(
        _ style: CompatGlassStyle = .regular,
        tint: Color,
        interactive: Bool = false,
        in shape: CompatGlassShape
    ) -> some View {
        if #available(iOS 26, *) {
            modifier(NativeGlassModifier(
                style: style, tint: tint, interactive: interactive, shape: shape
            ))
        } else {
            modifier(FallbackGlassModifier(
                style: style, tint: tint, shape: shape
            ))
        }
    }
}

// MARK: - Native Modifier (iOS 26+)

@available(iOS 26, *)
private struct NativeGlassModifier: ViewModifier {
    let style: CompatGlassStyle
    let tint: Color
    let interactive: Bool
    let shape: CompatGlassShape

    @ViewBuilder
    func body(content: Content) -> some View {
        switch (style, interactive, shape) {
        case (.regular, true, .rect(let cr)):
            content.glassEffect(.regular.interactive().tint(tint), in: .rect(cornerRadius: cr))
        case (.regular, false, .rect(let cr)):
            content.glassEffect(.regular.tint(tint), in: .rect(cornerRadius: cr))
        case (.regular, true, .circle):
            content.glassEffect(.regular.interactive().tint(tint), in: .circle)
        case (.regular, false, .circle):
            content.glassEffect(.regular.tint(tint), in: .circle)
        case (.clear, true, .rect(let cr)):
            content.glassEffect(.clear.interactive().tint(tint), in: .rect(cornerRadius: cr))
        case (.clear, false, .rect(let cr)):
            content.glassEffect(.clear.tint(tint), in: .rect(cornerRadius: cr))
        case (.clear, true, .circle):
            content.glassEffect(.clear.interactive().tint(tint), in: .circle)
        case (.clear, false, .circle):
            content.glassEffect(.clear.tint(tint), in: .circle)
        }
    }
}

// MARK: - Fallback Modifier (iOS < 26)

private struct FallbackGlassModifier: ViewModifier {
    let style: CompatGlassStyle
    let tint: Color
    let shape: CompatGlassShape

    func body(content: Content) -> some View {
        switch shape {
        case .rect(let cornerRadius):
            content
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.ultraThinMaterial)
                            .opacity(style == .clear ? 0.6 : 1.0)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(tint)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .circle:
            content
                .background(
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .opacity(style == .clear ? 0.6 : 1.0)
                        Circle()
                            .fill(tint)
                    }
                )
                .clipShape(Circle())
        }
    }
}
