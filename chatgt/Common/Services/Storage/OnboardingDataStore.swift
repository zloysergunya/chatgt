import Foundation

protocol StoresOnboarding {
    var hasCompletedOnboarding: Bool { get nonmutating set }
}

final class OnboardingDataStore: PersistentStoring, StoresOnboarding {

    let persistentStorage: KeyValueStorage

    init(persistentStorage: KeyValueStorage = UserDefaults.standard) {
        self.persistentStorage = persistentStorage
    }

    @PersistentStored
    var hasCompletedOnboarding: Bool = false
}
