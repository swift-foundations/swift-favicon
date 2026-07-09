import Dependencies
import Foundation
@preconcurrency import URLRouting

extension Favicon {
    /// Configuration for HTML meta tag generation
    public struct Configuration: Sendable {
        /// Include Apple touch icon links in HTML
        public var includeAppleTouchIcon: Bool

        /// Color scheme for theme meta tags
        public var colorScheme: ColorScheme?

        public init(
            includeAppleTouchIcon: Bool = true,
            colorScheme: ColorScheme? = nil
        ) {
            self.includeAppleTouchIcon = includeAppleTouchIcon
            self.colorScheme = colorScheme
        }
    }
}

// MARK: - Color Scheme

extension Favicon.Configuration {
    /// Color scheme for theme meta tags
    public struct ColorScheme: Sendable {
        public var primary: String
        public var background: String

        public init(primary: String, background: String) {
            self.primary = primary
            self.background = background
        }
    }
}

// MARK: - Test Configuration

extension Favicon.Configuration: Dependency.Key.Test {
    public static var testValue: Self {
        Self()
    }
}
