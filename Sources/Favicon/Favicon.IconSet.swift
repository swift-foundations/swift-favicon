import Foundation

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
