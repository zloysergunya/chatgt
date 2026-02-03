import Foundation
import Moya

/// Custom Moya plugin that logs requests as curl commands and formats JSON responses
final class CurlLoggerPlugin: PluginType {

    func willSend(_ request: RequestType, target: any TargetType) {
        guard let urlRequest = request.request else { return }
        let curl = makeCurlCommand(from: urlRequest)
        print("\n" + "═".repeated(60))
        print("📤 REQUEST")
        print("═".repeated(60))
        print(curl)
        print("═".repeated(60) + "\n")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: any TargetType) {
        print("\n" + "═".repeated(60))
        print("📥 RESPONSE")
        print("═".repeated(60))

        switch result {
        case .success(let response):
            print("Status: \(response.statusCode)")
            print("URL: \(response.request?.url?.absoluteString ?? "N/A")")
            printFormattedJSON(response.data)

        case .failure(let error):
            print("❌ Error: \(error.localizedDescription)")
            if let data = error.response?.data {
                printFormattedJSON(data)
            }
        }
        print("═".repeated(60) + "\n")
    }

    // MARK: - Private Methods

    private func makeCurlCommand(from request: URLRequest) -> String {
        var components = ["curl -v"]

        if let method = request.httpMethod {
            components.append("-X \(method)")
        }

        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers.sorted(by: { $0.key < $1.key }) {
                let escapedValue = value.replacingOccurrences(of: "'", with: "'\\''")
                components.append("-H '\(key): \(escapedValue)'")
            }
        }

        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            let escapedBody = bodyString.replacingOccurrences(of: "'", with: "'\\''")
            components.append("-d '\(escapedBody)'")
        }

        if let url = request.url?.absoluteString {
            components.append("'\(url)'")
        }

        return components.joined(separator: " \\\n  ")
    }

    private func printFormattedJSON(_ data: Data) {
        guard !data.isEmpty else {
            print("Body: (empty)")
            return
        }

        if let json = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("Body:\n\(prettyString)")
        } else if let rawString = String(data: data, encoding: .utf8) {
            print("Body: \(rawString)")
        } else {
            print("Body: (\(data.count) bytes, non-UTF8)")
        }
    }
}

// MARK: - String Extension

private extension String {
    func repeated(_ count: Int) -> String {
        String(repeating: self, count: count)
    }
}
