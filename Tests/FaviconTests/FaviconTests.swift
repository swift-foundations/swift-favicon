import Dependencies
import Dependencies_Test_Support
import Favicon
import Testing
import HTTP
import HTTP_Router
import RFC_3986

@Suite("Test")
struct Test {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension Test.Integration {

    @Test
    func `Serve favicon data for routes`() async throws {
        // Create an icon set with test data
        let iconSet = Favicon.IconSet(
            ico: bytes("test favicon"),
            png16: bytes("16x16"),
            png32: bytes("32x32"),
            png192: bytes("192x192"),
            appleTouchIcon: bytes("apple-touch-icon")
        )

        let favicon = Favicon(
            icons: iconSet
        )

        // Test favicon.ico retrieval
        let faviconData = favicon.data(for: Favicon.Route.favicon)
        #expect(faviconData == bytes("test favicon"))

        // Test PNG icon retrieval
        let png16 = favicon.data(for: Favicon.Route.icon(.png(.`16`)))
        #expect(png16 == bytes("16x16"))

        let png32 = favicon.data(for: Favicon.Route.icon(.png(.`32`)))
        #expect(png32 == bytes("32x32"))

        // Test Apple Touch Icon
        let appleTouchIcon = favicon.data(for: Favicon.Route.appleTouchIcon())
        #expect(appleTouchIcon == bytes("apple-touch-icon"))
    }

    @Test
    func `Content types for routes`() {
        let favicon = Favicon(
            icons: Favicon.IconSet()
        )

        #expect(favicon.contentType(for: Favicon.Route.favicon) == "image/x-icon")
        #expect(favicon.contentType(for: Favicon.Route.icon(.png(.`16`))) == "image/png")
        #expect(favicon.contentType(for: Favicon.Route.icon(.svg)) == "image/svg+xml")
        #expect(favicon.contentType(for: Favicon.Route.appleTouchIcon()) == "image/png")
    }

    @Test
    func `Response describes available favicon content`() {
        let body = bytes("test favicon")
        let favicon = Favicon(
            icons: Favicon.IconSet(ico: body)
        )

        let response = favicon.response(for: .favicon)

        #expect(response?.body == body)
        #expect(response?.contentType == "image/x-icon")
        #expect(response?.cacheControl == "public, max-age=31536000, immutable")
    }

    @Test
    func `Response is absent for missing favicon content`() {
        let favicon = Favicon(
            icons: Favicon.IconSet()
        )

        #expect(favicon.response(for: .favicon) == nil)
    }

    @Test
    func `Router parsing`() throws {
        let router = Favicon.Route.self

        // Test parsing various paths
        let route = try router.match(request: RouteRequest.make(path: "favicon.ico"))
        #expect(route == .favicon)

        let appleRoute = try router.match(request: RouteRequest.make(path: "apple-touch-icon.png"))
        #expect(appleRoute == .appleTouchIcon(size: nil))

        let svgRoute = try router.match(request: RouteRequest.make(path: "icon.svg"))
        #expect(svgRoute == .icon(.svg))

        let pngRoute = try router.match(request: RouteRequest.make(path: "icon-32x32.png"))
        #expect(pngRoute == .icon(.png(.`32`)))
    }

    @Test
    func `Custom router with base URL`() throws {
        // Create a custom router with base URL
        let customRouter = Favicon.Route.self

        // Create favicon with custom router configuration
        let favicon = Favicon(
            baseURL: try RFC_3986.URI("https://cdn.example.com/assets"),
            icons: Favicon.IconSet()
        )

        // The custom router can parse and print routes
        let route = try customRouter.match(request: RouteRequest.make(path: "favicon.ico"))
        #expect(route == .favicon)

        // Generate URL for a route
        let url = favicon.url(for: .favicon)
        #expect(url == "https://cdn.example.com/assets/favicon.ico")
    }

    @Test
    func `Returns nil for missing resources`() {
        // Create a minimal set with only favicon.ico
        let iconSet = Favicon.IconSet(
            ico: bytes("ico")
        )

        let favicon = Favicon(
            icons: iconSet
        )

        // Should return the ico data
        let icoData = favicon.data(for: Favicon.Route.favicon)
        #expect(icoData == bytes("ico"))

        // Should return nil for missing resources
        let pngData = favicon.data(for: Favicon.Route.icon(.png(.`16`)))
        #expect(pngData == nil)

        let appleTouchIconData = favicon.data(for: Favicon.Route.appleTouchIcon())
        #expect(appleTouchIconData == nil)

        let svgData = favicon.data(for: Favicon.Route.icon(.svg))
        #expect(svgData == nil)
    }

    @Test
    func `Live configuration`() throws {
        let iconSet = Favicon.IconSet(
            ico: bytes("configured")
        )

        let favicon = Favicon(
            baseURL: try RFC_3986.URI("https://example.com"),
            icons: iconSet
        )

        // Test that configuration was applied
        let data = favicon.data(for: Favicon.Route.favicon)
        #expect(data == bytes("configured"))
    }

    @Test
    func `Integration example`() throws {
        // This shows how it would be used in a real app
        let iconSet = Favicon.IconSet(
            ico: bytes("production"),
            svg: bytes("<svg></svg>")
        )

        // Create with custom router for CDN
        let cdnRouter = Favicon.Route.self

        let favicon = Favicon(
            baseURL: try RFC_3986.URI("https://cdn.myapp.com"),
            icons: iconSet
        )

        // In your route handler:
        let route = Favicon.Route.favicon
        if let data = favicon.data(for: route) {
            let contentType = favicon.contentType(for: route)
            // Return response with data and content type
            #expect(contentType == "image/x-icon")
            #expect(data == bytes("production"))
        }
    }
}
