import Photos

public protocol __PHFetchResultConvertible {
    var count: Int { get }
}

extension PHFetchResult: __PHFetchResultConvertible {}

public extension __PHFetchResultConvertible {
    var isEmpty: Bool { count == 0 }
}
