import Foundation

extension Favicon.Route {
    public enum Format: Equatable, Sendable, Hashable {
        case png(Favicon.Icon.Size)
        case svg
    }
}
