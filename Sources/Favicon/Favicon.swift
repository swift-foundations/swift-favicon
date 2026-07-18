import Dependencies
import Foundation
@preconcurrency import URLRouting

public struct Favicon: Sendable {
    public let router: AnyParserPrinter<RFC_3986.URI.Request.Data, Favicon.Route>
    public let icons: IconSet
    public let configuration: Configuration

    public init(
        router: AnyParserPrinter<RFC_3986.URI.Request.Data, Favicon.Route> =
            Route.Router().eraseToAnyParserPrinter(),
        icons: IconSet,
        configuration: Configuration = .init()
    ) {
        self.router = router
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

// MARK: - IconSet

extension Favicon {
    public struct IconSet: Sendable {
        public let ico: Data?
        public let svg: Data?
        public let png16: Data?
        public let png32: Data?
        public let png180: Data?
        public let png192: Data?
        public let png512: Data?
        public let appleTouchIcon: Data?
        public let appleTouchIcon180: Data?
        public let appleTouchIconPrecomposed: Data?

        public init(
            ico: Data? = nil,
            svg: Data? = nil,
            png16: Data? = nil,
            png32: Data? = nil,
            png180: Data? = nil,
            png192: Data? = nil,
            png512: Data? = nil,
            appleTouchIcon: Data? = nil,
            appleTouchIcon180: Data? = nil,
            appleTouchIconPrecomposed: Data? = nil
        ) {
            self.ico = ico
            self.svg = svg
            self.png16 = png16
            self.png32 = png32
            self.png180 = png180
            self.png192 = png192
            self.png512 = png512
            self.appleTouchIcon = appleTouchIcon
            self.appleTouchIcon180 = appleTouchIcon180
            self.appleTouchIconPrecomposed = appleTouchIconPrecomposed
        }
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
        Favicon(
            router: Route.Router().eraseToAnyParserPrinter(),
            icons: IconSet()
        )
    }
}
