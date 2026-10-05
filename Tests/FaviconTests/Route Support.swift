import Byte
import HTTP
import HTTP_Router
import RFC_3986
import RFC_9110

extension HTTP.Routable where Router.Output == Self {
    static func request(for route: Self) throws -> HTTP.Router.Request {
        try HTTP.request(Self.self, for: route)
    }

    static func match(request: HTTP.Router.Request) throws -> Self {
        try HTTP.route(Self.self, request)
    }
}

extension RFC_9110.Message.Request where Content == [Byte] {
    var pathComponents: [String] {
        guard case .resource(let uri) = target, let path = uri.path else { return [] }
        return path.segments.map { String(decoding: RFC_3986.percentDecode(Array($0.utf8)), as: UTF8.self) }
    }
}

enum RouteRequest {
    static func make(_ method: HTTP.Method = .get, path: String) -> HTTP.Router.Request {
        HTTP.Router.Request(method: method, target: .resource(RFC_3986.URI(unchecked: path)))
    }
}
