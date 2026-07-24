import Dependencies
import Foundation
import HTML
@preconcurrency import URLRouting
import URL_Routing_Foundation_Integration  // MemberImportVisibility: router.url(for:)

extension Favicon {
    public struct Head: HTML.View {
        // WHY: Captured eagerly at init (not held as `@Dependency` stored
        // properties) because `body` is evaluated lazily by the renderer,
        // outside `withDependencies`'s task-local scope. A `@Dependency`
        // *stored* property re-resolves `wrappedValue` on every access
        // (see swift-dependencies `Dependency.wrappedValue`), so reading
        // it from `body` after the scope has closed silently falls back
        // to `Favicon.testValue` / `Favicon.Configuration.testValue`
        // (all-nil `IconSet`, no color scheme) and renders empty HTML.
        // Reading through local `@Dependency` wrappers here, inside
        // `init()`, resolves them once while the scope is still active
        // and freezes the result in plain stored properties.
        let router: AnyParserPrinter<RFC_3986.URI.Request.Data, Favicon.Route>
        let icons: Favicon.IconSet
        let configuration: Favicon.Configuration

        public init() {
            @Dependency(\.favicon.router) var router
            @Dependency(\.favicon.icons) var icons
            @Dependency(\.favicon.configuration) var configuration
            self.router = router
            self.icons = icons
            self.configuration = configuration
        }
    }
}

extension Favicon.Head {

    @HTML.Builder
    public var body: some HTML.View {
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
