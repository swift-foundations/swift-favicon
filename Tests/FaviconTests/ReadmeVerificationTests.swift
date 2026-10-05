import Dependencies
import Dependencies_Test_Support
import Favicon
import HTML
import Testing
import HTTP
import HTTP_Router
import RFC_3986

@Suite("Readme")
struct Readme {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension Readme.Integration {

    @Test
    func `Example from README line 35-52: Creating a Favicon Instance`() throws {
        // Example from README
        let icoData = bytes("test")
        let svgData = bytes("svg")
        let png16Data = bytes("16")
        let png32Data = bytes("32")
        let png192Data = bytes("192")
        let appleTouchIconData = bytes("apple")

        // Create an icon set with your favicon data
        let icons = Favicon.IconSet(
            ico: icoData,
            svg: svgData,
            png16: png16Data,
            png32: png32Data,
            png192: png192Data,
            appleTouchIcon: appleTouchIconData
        )

        // Create the favicon instance
        let favicon = Favicon(
            icons: icons
        )

        // Verify it was created correctly
        #expect(favicon.data(for: .favicon) == icoData)
        #expect(favicon.data(for: .icon(.svg)) == svgData)
    }

    @Test
    func `Example from README line 57-65: Serving Favicons`() throws {
        let icoData = bytes("favicon")
        let icons = Favicon.IconSet(ico: icoData)
        let favicon = Favicon(
            icons: icons
        )

        // Parse incoming request path
        let route = try Favicon.Route.match(request: RouteRequest.make(path: "favicon.ico"))

        // Get data and content type for the route
        if let data = favicon.data(for: route) {
            let contentType = favicon.contentType(for: route)
            // Return HTTP response with data and content type
            #expect(data == icoData)
            #expect(contentType == "image/x-icon")
        } else {
            Issue.record("Expected data for favicon route")
        }
    }

    @Test
    func `Example from README line 106-113: Custom Base URL`() throws {
        let icons = Favicon.IconSet()

        let router = Favicon.Route.self

        let favicon = Favicon(
            baseURL: try RFC_3986.URI("https://cdn.example.com/assets"),
            icons: icons
        )

        // Verify the router can generate URLs
        let url = favicon.url(for: .favicon)
        #expect(url == "https://cdn.example.com/assets/favicon.ico")
    }

    @Test
    func `README Supported Routes are parseable`() throws {
        let router = Favicon.Route.self

        // Test all routes documented in README
        let faviconRoute = try router.match(request: RouteRequest.make(path: "favicon.ico"))
        #expect(faviconRoute == .favicon)

        let svgRoute = try router.match(request: RouteRequest.make(path: "icon.svg"))
        #expect(svgRoute == .icon(.svg))

        let png16Route = try router.match(request: RouteRequest.make(path: "icon-16x16.png"))
        #expect(png16Route == .icon(.png(.`16`)))

        let png32Route = try router.match(request: RouteRequest.make(path: "icon-32x32.png"))
        #expect(png32Route == .icon(.png(.`32`)))

        let png180Route = try router.match(request: RouteRequest.make(path: "icon-180x180.png"))
        #expect(png180Route == .icon(.png(.`180`)))

        let png192Route = try router.match(request: RouteRequest.make(path: "icon-192x192.png"))
        #expect(png192Route == .icon(.png(.`192`)))

        let png512Route = try router.match(request: RouteRequest.make(path: "icon-512x512.png"))
        #expect(png512Route == .icon(.png(.`512`)))

        let appleTouchIconRoute = try router.match(request: RouteRequest.make(path: "apple-touch-icon.png"))
        #expect(appleTouchIconRoute == .appleTouchIcon(size: nil))

        let appleTouchIcon180Route = try router.match(request:
            RouteRequest.make(path: "apple-touch-icon-180x180.png")
        )
        #expect(appleTouchIcon180Route == .appleTouchIcon(size: .`180`))

        let appleTouchIconPrecomposedRoute = try router.match(request:
            RouteRequest.make(path: "apple-touch-icon-precomposed.png")
        )
        #expect(appleTouchIconPrecomposedRoute == .appleTouchIconPrecomposed)
    }

    @Test
    func `README data and content type functionality`() {
        let icons = Favicon.IconSet(
            ico: bytes("ico"),
            svg: bytes("svg"),
            png16: bytes("16"),
            appleTouchIcon: bytes("apple")
        )

        let favicon = Favicon(
            icons: icons
        )

        // Test data retrieval
        #expect(favicon.data(for: .favicon) == bytes("ico"))
        #expect(favicon.data(for: .icon(.svg)) == bytes("svg"))
        #expect(favicon.data(for: .icon(.png(.`16`))) == bytes("16"))
        #expect(favicon.data(for: .appleTouchIcon(size: nil)) == bytes("apple"))

        // Test content types
        #expect(favicon.contentType(for: .favicon) == "image/x-icon")
        #expect(favicon.contentType(for: .icon(.svg)) == "image/svg+xml")
        #expect(favicon.contentType(for: .icon(.png(.`16`))) == "image/png")
        #expect(favicon.contentType(for: .appleTouchIcon(size: nil)) == "image/png")
    }

    @Test
    func `Example from README line 70-86: Generating HTML`() throws {
        // Example from README - setup favicon with some icon data
        let icons = Favicon.IconSet(
            ico: bytes("ico"),
            svg: bytes("svg"),
            png16: bytes("16"),
            png32: bytes("32")
        )

        let favicon = Favicon(
            icons: icons
        )

        // Use with swift-html to generate favicon meta tags
        // @Dependency(\.favicon) var favicon
        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        // Verify it compiles and generates HTML with favicon elements
        let htmlString = try String(head)

        // Should contain link tags for the icons we provided
        #expect(htmlString.contains("<link"))
        #expect(htmlString.contains("rel=\"icon\""))
        #expect(htmlString.contains("favicon.ico"))
        #expect(htmlString.contains("icon.svg"))
        #expect(htmlString.contains("icon-16x16.png"))
        #expect(htmlString.contains("icon-32x32.png"))

        // Verify content types are correct
        #expect(htmlString.contains("image/x-icon"))
        #expect(htmlString.contains("image/svg+xml"))
        #expect(htmlString.contains("image/png"))
    }
}
