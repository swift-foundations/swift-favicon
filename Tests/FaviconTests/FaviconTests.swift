import Dependencies
import Dependencies_Test_Support
import Favicon
import Foundation
import Testing
import URLRouting

@Suite(

)
struct Test {

    @Test
    func `Serve favicon data for routes`() async throws {
        // Create an icon set with test data
        let iconSet = Favicon.IconSet(
            ico: Data("test favicon".utf8),
            png16: Data("16x16".utf8),
            png32: Data("32x32".utf8),
            png192: Data("192x192".utf8),
            appleTouchIcon: Data("apple-touch-icon".utf8)
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet
        )

        // Test favicon.ico retrieval
        let faviconData = favicon.data(for: Favicon.Route.favicon)
        #expect(faviconData == Data("test favicon".utf8))

        // Test PNG icon retrieval
        let png16 = favicon.data(for: Favicon.Route.icon(.png(.`16`)))
        #expect(png16 == Data("16x16".utf8))

        let png32 = favicon.data(for: Favicon.Route.icon(.png(.`32`)))
        #expect(png32 == Data("32x32".utf8))

        // Test Apple Touch Icon
        let appleTouchIcon = favicon.data(for: Favicon.Route.appleTouchIcon())
        #expect(appleTouchIcon == Data("apple-touch-icon".utf8))
    }

    @Test
    func `Content types for routes`() {
        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: Favicon.IconSet()
        )

        #expect(favicon.contentType(for: Favicon.Route.favicon) == "image/x-icon")
        #expect(favicon.contentType(for: Favicon.Route.icon(.png(.`16`))) == "image/png")
        #expect(favicon.contentType(for: Favicon.Route.icon(.svg)) == "image/svg+xml")
        #expect(favicon.contentType(for: Favicon.Route.appleTouchIcon()) == "image/png")
    }

    @Test
    func `Router parsing`() throws {
        let router = Favicon.Route.Router()

        // Test parsing various paths
        let route = try router.parse(URLRequestData(path: "favicon.ico"))
        #expect(route == .favicon)

        let appleRoute = try router.parse(URLRequestData(path: "apple-touch-icon.png"))
        #expect(appleRoute == .appleTouchIcon(size: nil))

        let svgRoute = try router.parse(URLRequestData(path: "icon.svg"))
        #expect(svgRoute == .icon(.svg))

        let pngRoute = try router.parse(URLRequestData(path: "icon-32x32.png"))
        #expect(pngRoute == .icon(.png(.`32`)))
    }

    @Test
    func `Custom router with base URL`() throws {
        // Create a custom router with base URL
        let customRouter = Favicon.Route.Router()
            .baseURL("https://cdn.example.com/assets")

        // Create favicon with custom router configuration
        let _ = Favicon(
            router: customRouter.eraseToAnyParserPrinter(),
            icons: Favicon.IconSet()
        )

        // The custom router can parse and print routes
        let route = try customRouter.parse(URLRequestData(path: "favicon.ico"))
        #expect(route == .favicon)

        // Generate URL for a route
        let url = customRouter.url(for: .favicon)
        #expect(url.absoluteString == "https://cdn.example.com/assets/favicon.ico")
    }

    @Test
    func `Returns nil for missing resources`() {
        // Create a minimal set with only favicon.ico
        let iconSet = Favicon.IconSet(
            ico: Data("ico".utf8)
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet
        )

        // Should return the ico data
        let icoData = favicon.data(for: Favicon.Route.favicon)
        #expect(icoData == Data("ico".utf8))

        // Should return nil for missing resources
        let pngData = favicon.data(for: Favicon.Route.icon(.png(.`16`)))
        #expect(pngData == nil)

        let appleTouchIconData = favicon.data(for: Favicon.Route.appleTouchIcon())
        #expect(appleTouchIconData == nil)

        let svgData = favicon.data(for: Favicon.Route.icon(.svg))
        #expect(svgData == nil)
    }

    @Test
    func `Live configuration`() {
        let iconSet = Favicon.IconSet(
            ico: Data("configured".utf8)
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().baseURL("https://example.com").eraseToAnyParserPrinter(),
            icons: iconSet
        )

        // Test that configuration was applied
        let data = favicon.data(for: Favicon.Route.favicon)
        #expect(data == Data("configured".utf8))
    }

    @Test
    func `Integration example`() throws {
        // This shows how it would be used in a real app
        let iconSet = Favicon.IconSet(
            ico: Data("production".utf8),
            svg: Data("<svg></svg>".utf8)
        )

        // Create with custom router for CDN
        let cdnRouter = Favicon.Route.Router()
            .baseURL("https://cdn.myapp.com")

        let favicon = Favicon(
            router: cdnRouter.eraseToAnyParserPrinter(),
            icons: iconSet
        )

        // In your route handler:
        let route = Favicon.Route.favicon
        if let data = favicon.data(for: route) {
            let contentType = favicon.contentType(for: route)
            // Return response with data and content type
            #expect(contentType == "image/x-icon")
            #expect(data == Data("production".utf8))
        }
    }
}
