import Foundation
import StoreKit
import Combine

enum SubscriptionID: String, CaseIterable {
    case weekly = "com.chatgt.subscription.weekly"
    case yearly = "com.chatgt.subscription.yearly"
    
    static var allIDs: [String] {
        allCases.map { $0.rawValue }
    }
}

// MARK: - Store Error
enum StoreError: LocalizedError {
    case failedVerification
    case productNotFound
    case purchaseFailed
    case userCancelled
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Transaction verification failed"
        case .productNotFound:
            return "Product not found"
        case .purchaseFailed:
            return "Purchase failed"
        case .userCancelled:
            return "Purchase was cancelled"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

@MainActor
final class StoreKitManager: ObservableObject {
    
    static let shared = StoreKitManager()
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var isSubscribed: Bool = false
    
    private var updateListenerTask: Task<Void, Error>?
    
    private init() {
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit { updateListenerTask?.cancel() }
        
    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: SubscriptionID.allIDs)
            
            products = storeProducts.sorted { product1, product2 in
                guard let sub1 = product1.subscription, let sub2 = product2.subscription else { return false }
                return sub1.subscriptionPeriod.value > sub2.subscriptionPeriod.value
            }
        } catch {
            print("Failed to load products: \(error)")
        }
    }
        
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateSubscriptionStatus()
            await transaction.finish()
            return transaction
            
        case .userCancelled:
            throw StoreError.userCancelled
            
        case .pending:
            return nil
            
        @unknown default:
            throw StoreError.unknown
        }
    }
        
    func restorePurchases() async throws {
        try await AppStore.sync()
        await updateSubscriptionStatus()
    }
        
    func updateSubscriptionStatus() async {
        var purchasedSubs: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.productType == .autoRenewable {
                if let product = products.first(where: { $0.id == transaction.productID }) {
                    purchasedSubs.append(product)
                }
            }
        }
        
        purchasedSubscriptions = purchasedSubs
        isSubscribed = !purchasedSubs.isEmpty
    }
        
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            for await result in Transaction.updates {
                do {
                    let transaction = try await self?.checkVerified(result)
                    await self?.updateSubscriptionStatus()
                    await transaction?.finish()
                } catch {
                    print("Transaction failed verification: \(error)")
                }
            }
        }
    }
        
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
        
    func product(for id: SubscriptionID) -> Product? {
        products.first { $0.id == id.rawValue }
    }
    
    /// Returns the weekly price for a yearly subscription (for display purposes)
    func weeklyPriceForYearly(_ product: Product) -> String? {
        guard let subscription = product.subscription,
              subscription.subscriptionPeriod.unit == .year else {
            return nil
        }
        
        let yearlyPrice = product.price
        let weeklyPrice = yearlyPrice / 52
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceFormatStyle.locale
        
        return formatter.string(from: weeklyPrice as NSDecimalNumber)
    }
    
    func introductoryOfferDescription(for product: Product) -> String? {
        guard let subscription = product.subscription,
              let introOffer = subscription.introductoryOffer else {
            return nil
        }
        
        let period = introOffer.period
        let periodString: String
        
        switch period.unit {
        case .day:
            periodString = period.value == 1 ? "day" : "\(period.value) days"
        case .week:
            periodString = period.value == 1 ? "week" : "\(period.value) weeks"
        case .month:
            periodString = period.value == 1 ? "month" : "\(period.value) months"
        case .year:
            periodString = period.value == 1 ? "year" : "\(period.value) years"
        @unknown default:
            periodString = "\(period.value) periods"
        }
        
        switch introOffer.paymentMode {
        case .freeTrial:
            return "\(periodString) Free Trial"
        case .payAsYouGo:
            return "\(introOffer.displayPrice) for \(periodString)"
        case .payUpFront:
            return "\(introOffer.displayPrice) for \(periodString)"
        default:
            return nil
        }
    }
}
