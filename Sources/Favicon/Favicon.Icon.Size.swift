import Foundation

extension Favicon.Icon {
    /// Standard favicon sizes as an enum with numeric cases
    public enum Size: String, Sendable, Hashable, CaseIterable, CustomStringConvertible {
        case `16` = "16x16"
        case `32` = "32x32"
        case `180` = "180x180"
        case `192` = "192x192"
        case `512` = "512x512"

        public var width: Int {
            switch self {
            case .`16`: return 16
            case .`32`: return 32
            case .`180`: return 180
            case .`192`: return 192
            case .`512`: return 512
            }
        }

        public var height: Int {
            width  // Square icons
        }

        public var description: String {
            rawValue
        }

    }
}
