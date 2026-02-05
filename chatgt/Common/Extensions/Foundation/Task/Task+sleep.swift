import Foundation

public extension Task<Never, Never> {

    static func sleep(_ time: TimeInterval) async throws {
        try await sleep(nanoseconds: .init(time * 1000000000))
    }
}
