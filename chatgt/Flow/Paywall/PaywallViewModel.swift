import Foundation
import StoreKit
import Combine

@MainActor
final class PaywallViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var products: [Product] = []
    @Published var selectedProduct: Product?
    @Published var isLoading: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var purchaseSuccessful: Bool = false
    
    // MARK: - Dependencies
    
    private let storeManager: StoreKitManager
    
    // MARK: - Computed Properties
    
    var isSubscribed: Bool {
        storeManager.isSubscribed
    }
    
    var yearlyProduct: Product? {
        products.first { $0.id == SubscriptionID.yearly.rawValue }
    }
    
    var weeklyProduct: Product? {
        products.first { $0.id == SubscriptionID.weekly.rawValue }
    }
    
    /// Trial description for the selected product
    var trialDescription: String? {
        guard let product = selectedProduct ?? yearlyProduct else { return nil }
        return storeManager.introductoryOfferDescription(for: product)
    }
    
    /// Full price description for footer
    var fullPriceDescription: String? {
        guard let yearly = yearlyProduct else { return nil }
        
        if let trialDays = trialDescription {
            return "\(trialDays), then \(yearly.displayPrice) per year."
        }
        return "\(yearly.displayPrice) per year."
    }
    
    // MARK: - Initialization
    init(storeManager: StoreKitManager = .shared) {
        self.storeManager = storeManager
    }
    
    // MARK: - Methods
    
    func loadProducts() async {
        isLoading = true
        
        await storeManager.loadProducts()
        products = storeManager.products
        
        // Select yearly product by default (best offer)
        if selectedProduct == nil {
            selectedProduct = yearlyProduct ?? products.first
        }
        
        isLoading = false
    }
    
    func selectProduct(_ product: Product) {
        selectedProduct = product
    }
    
    func purchase() async {
        guard let product = selectedProduct else {
            showError(message: "Please select a subscription")
            return
        }
        
        isPurchasing = true
        errorMessage = nil
        
        do {
            let transaction = try await storeManager.purchase(product)
            if transaction != nil {
                purchaseSuccessful = true
            }
        } catch StoreError.userCancelled {
            // User cancelled - no error message needed
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isPurchasing = false
    }
    
    func restore() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await storeManager.restorePurchases()
            if storeManager.isSubscribed {
                purchaseSuccessful = true
            } else {
                showError(message: "No purchases to restore")
            }
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    // MARK: - Helper Methods
    
    func isSelected(_ product: Product) -> Bool {
        selectedProduct?.id == product.id
    }
    
    func isBestOffer(_ product: Product) -> Bool {
        product.id == SubscriptionID.yearly.rawValue
    }
    
    func weeklyPriceDisplay(for product: Product) -> String {
        if product.id == SubscriptionID.yearly.rawValue {
            return storeManager.weeklyPriceForYearly(product) ?? product.displayPrice
        }
        return product.displayPrice
    }
    
    func periodDescription(for product: Product) -> String {
        guard let subscription = product.subscription else {
            return ""
        }
        
        let period = subscription.subscriptionPeriod
        switch period.unit {
        case .day:
            return period.value == 1 ? "/day" : "/\(period.value) days"
        case .week:
            return period.value == 1 ? "/week" : "/\(period.value) weeks"
        case .month:
            return period.value == 1 ? "/month" : "/\(period.value) months"
        case .year:
            return period.value == 1 ? "/year" : "/\(period.value) years"
        @unknown default:
            return ""
        }
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}
