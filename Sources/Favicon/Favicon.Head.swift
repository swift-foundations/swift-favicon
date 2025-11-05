import Dependencies
import Foundation
import HTML
@preconcurrency import URLRouting

extension Favicon {
    public struct Head: HTML {
        @Dependency(\.favicon.router) var router
        @Dependency(\.favicon.icons) var icons
        @Dependency(\.favicon.configuration) var configuration

        public init() {}
    }
}

extension Favicon.Head {

    @HTMLBuilder
    public var body: some HTML {
        // Basic favicon.ico
        if icons.ico != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/x-icon")
                .attribute("href", router.url(for: .favicon).absoluteString)
        }

        // SVG variant - preferred for scalability
        if icons.svg != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/svg+xml")
                .attribute("href", router.url(for: .icon(.svg)).absoluteString)
        }

        // PNG variants
        if icons.png16 != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/png")
                .attribute("sizes", "16x16")
                .attribute("href", router.url(for: .icon(.png(.`16`))).absoluteString)
        }

        if icons.png32 != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/png")
                .attribute("sizes", "32x32")
                .attribute("href", router.url(for: .icon(.png(.`32`))).absoluteString)
        }

        if icons.png192 != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/png")
                .attribute("sizes", "192x192")
                .attribute("href", router.url(for: .icon(.png(.`192`))).absoluteString)
        }

        // Apple Touch Icon
        if configuration.includeAppleTouchIcon, icons.appleTouchIcon != nil {
            link()
                .attribute("rel", "apple-touch-icon")
                .attribute("sizes", "180x180")
                .attribute("href", router.url(for: .appleTouchIcon()).absoluteString)
        }

        // Apple Touch Icon 180x180 specific
        if configuration.includeAppleTouchIcon, icons.appleTouchIcon180 != nil {
            link()
                .attribute("rel", "apple-touch-icon")
                .attribute("sizes", "180x180")
                .attribute("href", router.url(for: .appleTouchIcon(size: .`180`)).absoluteString)
        }

        // Theme color
        if let colorScheme = configuration.colorScheme {
            meta()
                .attribute("name", "theme-color")
                .attribute("content", colorScheme.primary)
        }
    }
}
