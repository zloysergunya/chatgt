import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PaywallViewModel()
    
    var onDismiss: (() -> Void)?
    var onPurchaseSuccess: (() -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("image_paywall_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerSection
                        
                        IconCard(
                            imageName: "image.launch.logo",
                            size: CGSize(width: 130, height: 130),
                            insets: EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
                        )
                        .padding(.top, 24)
                        
                        featureTagsSection
                            .padding(.top, 45)
                        
                        Spacer()
                        
                        subscriptionOptionsSection
                            .padding(.top, 32)
                        
                        ctaButton
                            .padding(.top, 24)
                        
                        trialInfoSection
                            .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                }
                
                VStack {
                    HStack {
                        Button {
                            onDismiss?()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    footerSection
                        .padding(.top, 20)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 36)
                }
                .padding(.top, 54)
                .padding(.leading, 20)
            }
        }
        .ignoresSafeArea()
        .task {
            await viewModel.loadProducts()
        }
        .onChange(of: viewModel.purchaseSuccessful) { _, success in
            if success {
                onPurchaseSuccess?()
                dismiss()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
    }
    
    private var headerSection: some View {
        VStack {
            HStack(spacing: 8) {
                Text("GET")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("PRO")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color(hex: 0x2F68FF))
                
                Text("ACCESS")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 96)
    }
    
    private var featureTagsSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                FeatureTagView(
                    icon: "circle.grid.2x2.fill",
                    iconColor: .green,
                    title: "All-in-One AI"
                )
                
                FeatureTagView(
                    icon: "paperplane.fill",
                    iconColor: Color(hex: 0x4A90E2),
                    title: "Thinking & Search"
                )
            }
            
            FeatureTagView(
                icon: "mic.fill",
                iconColor: .red,
                title: "Latest AI Models"
            )
        }
    }
        
    private var subscriptionOptionsSection: some View {
        VStack(spacing: 12) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .padding(.vertical, 40)
            } else if viewModel.products.isEmpty {
                placeholderSubscriptionOptions
            } else {
                ForEach(viewModel.products, id: \.id) { product in
                    let isBestOffer = viewModel.isBestOffer(product)
                    let isSelected = viewModel.isSelected(product)
                    
                    SubscriptionOptionContainer(
                        title: subscriptionTitle(for: product),
                        subtitle: isBestOffer ? product.displayPrice + "/year" : "",
                        pricePerWeek: viewModel.weeklyPriceDisplay(for: product) + "/week",
                        isSelected: isSelected,
                        isBestOffer: isBestOffer,
                        action: {
                            viewModel.selectProduct(product)
                        }
                    )
                }
            }
        }
    }
    
    private var placeholderSubscriptionOptions: some View {
        VStack(spacing: 12) {
            SubscriptionOptionContainer(
                title: "Yearly Access",
                subtitle: "Best value",
                pricePerWeek: "Loading...",
                isSelected: true,
                isBestOffer: true,
                action: {}
            )
            
            SubscriptionOptionContainer(
                title: "Weekly Access",
                subtitle: "",
                pricePerWeek: "Loading...",
                isSelected: false,
                isBestOffer: false,
                action: {}
            )
        }
    }
        
    private var ctaButton: some View {
        Button {
            Task {
                await viewModel.purchase()
            }
        } label: {
            Group {
                if viewModel.isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("UNLOCK ALL FEATURES")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(hex: 0x2F68FF))
            .cornerRadius(12)
        }
        .disabled(viewModel.isPurchasing || viewModel.isLoading)
    }
    
    // MARK: - Trial Info Section
    
    private var trialInfoSection: some View {
        VStack(spacing: 4) {
            if let description = viewModel.fullPriceDescription {
                Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            } else {
                Text("7 days Free Trial, then 179,99 AED per year.")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            
            Text("No commitment. Cancel anytime.")
                .font(.system(size: 10))
                .foregroundColor(Color(hex: 0x707579))
        }
        .multilineTextAlignment(.center)
    }
    
    private var footerSection: some View {
        HStack(spacing: 20) {
            Button {
                openURL(urlString: "https://example.com/terms")
            } label: {
                Text("Terms of Use")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button {
                Task {
                    await viewModel.restore()
                }
            } label: {
                Text("Restore Purchases")
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .underline()
            }
            
            Spacer()
            
            Button {
                openURL(urlString: "https://example.com/privacy")
            } label: {
                Text("Privacy Policy")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
    }
        
    private func subscriptionTitle(for product: Product) -> String {
        guard let subscription = product.subscription else {
            return product.displayName
        }
        
        switch subscription.subscriptionPeriod.unit {
        case .week:
            return "Weekly Access"
        case .month:
            return "Monthly Access"
        case .year:
            return "Weekly Access" // Shows as weekly but billed yearly
        default:
            return product.displayName
        }
    }
    
    private func openURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    PaywallView()
}
