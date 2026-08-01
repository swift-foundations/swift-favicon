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
