import Dependencies
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

// MARK: - Test Configuration

extension Favicon.Configuration: Dependency.Key.Test {
    public static var testValue: Self {
        Self()
    }
}
