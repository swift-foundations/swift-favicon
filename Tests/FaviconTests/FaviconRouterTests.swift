import Dependencies
import Dependencies_Test_Support
import Favicon
import Testing
import HTTP
import HTTP_Router
import RFC_3986

@Suite("Routing")
struct Routing {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension Routing.Integration {
    var router: Favicon.Route.Type { Favicon.Route.self }

    @Test
    func `Parse favicon.ico route`() throws {

        let route = try router.match(request: RouteRequest.make(path: "favicon.ico"))
        #expect(route == .favicon)

        // Test roundtrip
        let path = try router.request(for: .favicon)
        #expect(path.pathComponents.joined(separator: "/") == "favicon.ico")
    }

    @Test
    func `Parse apple-touch-icon routes`() throws {

        // Test default apple-touch-icon
        let defaultRoute = try router.match(request: RouteRequest.make(path: "apple-touch-icon.png"))
        #expect(defaultRoute == .appleTouchIcon(size: nil))

        // Test sized apple-touch-icon
        let sizedRoute = try router.match(request: RouteRequest.make(path: "apple-touch-icon-180x180.png"))
        #expect(sizedRoute == .appleTouchIcon(size: .`180`))

        // Test precomposed
        let precomposedRoute = try router.match(request:
            RouteRequest.make(path: "apple-touch-icon-precomposed.png")
        )
        #expect(precomposedRoute == .appleTouchIconPrecomposed)
    }

    @Test
    func `Parse PNG icon routes`() throws {
        // Test 16x16 PNG
        let png16 = try router.match(request: RouteRequest.make(path: "icon-16x16.png"))
        #expect(png16 == .icon(.png(.`16`)))

        // Test 32x32 PNG
        let png32 = try router.match(request: RouteRequest.make(path: "icon-32x32.png"))
        #expect(png32 == .icon(.png(.`32`)))
    }

    @Test
    func `Parse SVG icon route`() throws {
        // Test SVG icon
        let iconSvg = try router.match(request: RouteRequest.make(path: "icon.svg"))
        #expect(iconSvg == .icon(.svg))
    }

    @Test
    func `Print routes`() throws {
        // Test printing various routes
        let favicon = try router.request(for: .favicon)
        #expect(favicon.pathComponents.joined(separator: "/") == "favicon.ico")

        let appleTouchIcon = try router.request(for: .appleTouchIcon())
        #expect(appleTouchIcon.pathComponents.joined(separator: "/") == "apple-touch-icon.png")

        let svg = try router.request(for: .icon(.svg))
        #expect(svg.pathComponents.joined(separator: "/") == "icon.svg")

        let png16 = try router.request(for: .icon(.png(.`16`)))
        #expect(png16.pathComponents.joined(separator: "/") == "icon-16x16.png")
    }

    @Test
    func `Invalid routes throw errors`() {

        #expect(throws: Error.self) {
            try router.match(request: RouteRequest.make(path: "invalid-route.txt"))
        }

        #expect(throws: Error.self) {
            try router.match(request: RouteRequest.make(path: "not-a-favicon"))
        }
    }
}
