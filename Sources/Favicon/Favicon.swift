import Dependencies
import Foundation
import HTTP
import HTTP_Router
import RFC_3986
import RFC_9110

public struct Favicon: Sendable {
    public let baseURL: RFC_3986.URI?
    public let icons: IconSet
    public let configuration: Configuration

    public init(
        baseURL: RFC_3986.URI? = nil,
        icons: IconSet,
        configuration: Configuration = .init()
    ) {
        self.baseURL = baseURL
        self.icons = icons
        self.configuration = configuration
    }
}

// MARK: - Serving

extension Favicon {
    /// Returns the data for a given favicon route
    public func data(for route: Route) -> Data? {
        switch route {
        case .favicon:
            return icons.ico

        case .appleTouchIcon(let size):
            switch size {
            case .some(.`180`):
                return icons.appleTouchIcon180 ?? icons.appleTouchIcon

            case .none:
                return icons.appleTouchIcon

            default:
                return icons.appleTouchIcon
            }

        case .appleTouchIconPrecomposed:
            return icons.appleTouchIconPrecomposed

        case .icon(let format):
            switch format {
            case .png(let size):
                switch size {
                case .`16`: return icons.png16
                case .`32`: return icons.png32
                case .`180`: return icons.png180
                case .`192`: return icons.png192
                case .`512`: return icons.png512
                }

            case .svg:
                return icons.svg
            }
        }
    }

    /// Returns the content type for a given route
    public func contentType(for route: Route) -> String {
        switch route {
        case .favicon:
            return "image/x-icon"

        case .icon(let format):
            switch format {
            case .png: return "image/png"
            case .svg: return "image/svg+xml"
            }

        case .appleTouchIcon, .appleTouchIconPrecomposed:
            return "image/png"
        }
    }

    /// Fast path for checking if SVG data exists
    public var hasSVG: Bool {
        icons.svg != nil
    }

    /// Direct access to SVG data for common case
    public var svgData: Data? {
        icons.svg
    }
}

// MARK: - Dependency

extension Dependency.Values {
    public var favicon: Favicon {
        get { self[Favicon.self] }
        set { self[Favicon.self] = newValue }
    }
}

extension Favicon: Dependency.Key.Test {
    public static var testValue: Favicon {
        Favicon(icons: IconSet())
    }
}

extension Favicon {
    public func url(for route: Route) -> String {
        Self.url(for: route, baseURL: baseURL)
    }

    static func url(for route: Route, baseURL: RFC_3986.URI?) -> String {
        let target: RFC_9110.Target
        do throws(HTTP.Router.Error) {
            target = try HTTP.target(Route.self, for: route)
        } catch {
            return ""
        }
        guard case .resource(let uri) = target else { return "" }
        guard let baseURL else { return uri.value }
        let base = baseURL.value.hasSuffix("/") ? String(baseURL.value.dropLast()) : baseURL.value
        return base + uri.value
    }
}
