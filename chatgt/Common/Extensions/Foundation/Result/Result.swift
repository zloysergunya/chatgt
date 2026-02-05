import Foundation

public extension Result {
    var isFailure: Bool {
        switch self {
        case .success: false
        case .failure: true
        }
    }
    
    var isSuccess: Bool {
        switch self {
        case .success: true
        case .failure: false
        }
    }
}

public extension Result where Success == Void {
    static var success: Self { .success(()) }
}

public extension Result where Success == Any? {
    static var success: Self { .success(nil) }
}
