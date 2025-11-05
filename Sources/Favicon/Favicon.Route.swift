import Foundation

extension Favicon {
    public enum Route: Equatable, Sendable, Hashable {
        case favicon  // /favicon.ico
        case icon(Format)  // /icon-{size}.png
        case appleTouchIcon(size: Favicon.Icon.Size? = nil)  // /apple-touch-icon{-size}.png
        case appleTouchIconPrecomposed  // /apple-touch-icon-precomposed.png
    }
}
