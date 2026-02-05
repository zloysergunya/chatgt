import Foundation

protocol StoresProfile {
    var profile: Profile? { get nonmutating set }
}

final class ProfileDataStore: PersistentStoring, StoresProfile {

    let persistentStorage: KeyValueStorage

    init(persistentStorage: KeyValueStorage = UserDefaults.standard) {
        self.persistentStorage =  persistentStorage
    }

    @PersistentStored
    var profile: Profile? = nil
}
