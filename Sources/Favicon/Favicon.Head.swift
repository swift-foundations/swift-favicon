import Dependencies
import HTML
import HTTP
import HTTP_Router
import RFC_3986
import RFC_9110

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
        let baseURL: RFC_3986.URI?
        let icons: Favicon.IconSet
        let configuration: Favicon.Configuration

        public init() {
            @Dependency(\.favicon.baseURL) var baseURL
            @Dependency(\.favicon.icons) var icons
            @Dependency(\.favicon.configuration) var configuration
            self.baseURL = baseURL
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
                .attribute("href", href(.favicon))
        }

        // SVG variant - preferred for scalability
        if icons.svg != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/svg+xml")
                .attribute("href", href(.icon(.svg)))
        }

        // PNG variants
        if icons.png16 != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/png")
                .attribute("sizes", "16x16")
                .attribute("href", href(.icon(.png(.`16`))))
        }

        if icons.png32 != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/png")
                .attribute("sizes", "32x32")
                .attribute("href", href(.icon(.png(.`32`))))
        }

        if icons.png192 != nil {
            link()
                .attribute("rel", "icon")
                .attribute("type", "image/png")
                .attribute("sizes", "192x192")
                .attribute("href", href(.icon(.png(.`192`))))
        }

        // Apple Touch Icon
        if configuration.includeAppleTouchIcon, icons.appleTouchIcon != nil {
            link()
                .attribute("rel", "apple-touch-icon")
                .attribute("sizes", "180x180")
                .attribute("href", href(.appleTouchIcon()))
        }

        // Apple Touch Icon 180x180 specific
        if configuration.includeAppleTouchIcon, icons.appleTouchIcon180 != nil {
            link()
                .attribute("rel", "apple-touch-icon")
                .attribute("sizes", "180x180")
                .attribute("href", href(.appleTouchIcon(size: .`180`)))
        }

        // Theme color
        if let colorScheme = configuration.colorScheme {
            meta()
                .attribute("name", "theme-color")
                .attribute("content", colorScheme.primary)
        }
    }
}

extension Favicon.Head {
    func href(_ route: Favicon.Route) -> String {
        Favicon.url(for: route, baseURL: baseURL)
    }
}
