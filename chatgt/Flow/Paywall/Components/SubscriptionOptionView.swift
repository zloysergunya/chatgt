import SwiftUI
import StoreKit

struct SubscriptionOptionContainer: View {
    let title: String
    let subtitle: String
    let pricePerWeek: String
    let isSelected: Bool
    let isBestOffer: Bool
    let action: () -> Void
    
    private let selectedBorderColor = Color(hex: 0x2F68FF)
    
    var body: some View {
        if isBestOffer {
            VStack(spacing: 0) {
                Text("BEST OFFER")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 3)
                    .background(selectedBorderColor)
                
                SubscriptionOptionContent(
                    title: title,
                    subtitle: subtitle,
                    pricePerWeek: pricePerWeek,
                    isSelected: isSelected,
                    action: action
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? selectedBorderColor : Color.clear, lineWidth: 3)
            )
        } else {
            SubscriptionOptionContent(
                title: title,
                subtitle: subtitle,
                pricePerWeek: pricePerWeek,
                isSelected: isSelected,
                action: action
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? selectedBorderColor : Color.clear, lineWidth: 3)
            )
        }
    }
}

struct SubscriptionOptionContent: View {
    let title: String
    let subtitle: String
    let pricePerWeek: String
    let isSelected: Bool
    let action: () -> Void
    
    private let selectedBorderColor = Color(hex: 0x2F68FF)
    private let unselectedBackgroundColor = Color(hex: 0x1C1C1E)
    
    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(isSelected ? selectedBorderColor : Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(selectedBorderColor)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text(pricePerWeek)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(unselectedBackgroundColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 10) {
            SubscriptionOptionContainer(
                title: "Weekly Access",
                subtitle: "AED 0.00/year",
                pricePerWeek: "AED 0.00/week",
                isSelected: true,
                isBestOffer: true,
                action: {}
            )
            
            SubscriptionOptionContainer(
                title: "Weekly Access",
                subtitle: "",
                pricePerWeek: "AED 0.00/week",
                isSelected: false,
                isBestOffer: false,
                action: {}
            )
        }
        .padding()
    }
}
