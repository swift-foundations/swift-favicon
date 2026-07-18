import Foundation

extension Favicon {
    /// The engine-free response description for an available favicon.
    public struct Response: Equatable, Sendable {
        public let body: Data
        public let contentType: String
        public let cacheControl: String

        public init(
            body: Data,
            contentType: String,
            cacheControl: String = "public, max-age=31536000, immutable"
        ) {
            self.body = body
            self.contentType = contentType
            self.cacheControl = cacheControl
        }
    }
}

extension Favicon {
    /// Describes the successful response for an available favicon route.
    ///
    /// Missing icon data returns `nil`; filesystem lookup and server-engine conversion remain
    /// responsibilities of the integration layer.
    public func response(for route: Route) -> Response? {
        guard let body = data(for: route) else { return nil }

        return Response(
            body: body,
            contentType: contentType(for: route)
        )
    }
}
