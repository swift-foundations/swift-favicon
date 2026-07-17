import Dependencies
import Dependencies_Test_Support
import Favicon
import Foundation
import HTML
import Testing
import URLRouting

@Suite(

)
struct Test {

    @Test
    func `Generate basic favicon HTML`() throws {
        let iconSet = Favicon.IconSet(
            ico: Data()
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet
        )

        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        let htmlString = try String(head)

        // Should contain basic favicon link
        #expect(htmlString.contains("favicon.ico"))
        #expect(htmlString.contains("rel=\"icon\""))
        #expect(htmlString.contains("type=\"image/x-icon\""))
    }

    @Test
    func `Generate HTML with PNG icons`() throws {
        let iconSet = Favicon.IconSet(
            png16: Data(),
            png32: Data(),
            png192: Data()
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet
        )

        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        let htmlString = try String(head)

        // Should contain PNG icon links with sizes
        #expect(htmlString.contains("icon"))
        #expect(htmlString.contains("16"))
        #expect(htmlString.contains("32"))
        #expect(htmlString.contains("192"))
        #expect(htmlString.contains("sizes=\"16x16\""))
        #expect(htmlString.contains("sizes=\"32x32\""))
        #expect(htmlString.contains("sizes=\"192x192\""))
    }

    @Test
    func `Generate HTML with Apple Touch Icon`() throws {
        let iconSet = Favicon.IconSet(
            appleTouchIcon: Data(),
            appleTouchIcon180: Data()
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet,
            configuration: Favicon.Configuration(includeAppleTouchIcon: true)
        )

        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        let htmlString = try String(head)

        // Should contain Apple Touch Icon links
        #expect(htmlString.contains("apple-touch-icon"))
        #expect(htmlString.contains("rel=\"apple-touch-icon\""))
        #expect(htmlString.contains("sizes=\"180x180\""))
    }

    @Test
    func `Generate HTML with SVG icon`() throws {
        let iconSet = Favicon.IconSet(
            svg: Data("<svg></svg>".utf8)
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet
        )

        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        let htmlString = try String(head)

        // Should contain SVG icon link
        #expect(htmlString.contains("icon.svg"))
        #expect(htmlString.contains("type=\"image/svg+xml\""))
    }

    @Test
    func `Generate HTML with base URL from router`() throws {
        let iconSet = Favicon.IconSet(
            ico: Data()
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().baseURL("https://cdn.example.com").eraseToAnyParserPrinter(),
            icons: iconSet
        )

        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        let htmlString = try String(head)

        // Should use paths from router with base URL
        #expect(htmlString.contains("https://cdn.example.com"))
        #expect(htmlString.contains("favicon.ico"))
    }

    @Test
    func `Generate HTML with theme color`() throws {
        let iconSet = Favicon.IconSet()

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet,
            configuration: Favicon.Configuration(
                colorScheme: Favicon.Configuration.ColorScheme(
                    primary: "#ff0000",
                    background: "#00ff00"
                )
            )
        )

        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        let htmlString = try String(head)

        // Should contain theme color meta tag
        #expect(htmlString.contains("name=\"theme-color\""))
        #expect(htmlString.contains("content=\"#ff0000\""))
    }

    @Test
    func `Generate minimal HTML when config excludes features`() throws {
        let iconSet = Favicon.IconSet(
            ico: Data(),
            appleTouchIcon: Data()
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet,
            configuration: Favicon.Configuration(includeAppleTouchIcon: false)
        )

        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        let htmlString = try String(head)

        // Should include favicon.ico
        #expect(htmlString.contains("favicon.ico"))

        // Should not include excluded features
        #expect(!htmlString.contains("apple-touch-icon"))
    }

    @Test
    func `Complete favicon set generates comprehensive HTML`() throws {
        let iconSet = Favicon.IconSet(
            ico: Data(),
            svg: Data("<svg></svg>".utf8),
            png16: Data(),
            png32: Data(),
            png192: Data(),
            appleTouchIcon: Data()
        )

        let favicon = Favicon(
            router: Favicon.Route.Router().eraseToAnyParserPrinter(),
            icons: iconSet,
            configuration: Favicon.Configuration(
                includeAppleTouchIcon: true,
                colorScheme: Favicon.Configuration.ColorScheme(
                    primary: "#2196f3",
                    background: "#1976d2"
                )
            )
        )

        let head = withDependencies {
            $0.favicon = favicon
        } operation: {
            Favicon.Head()
        }

        let htmlString = try String(head)

        // Should contain all elements
        #expect(htmlString.contains("favicon.ico"))
        #expect(htmlString.contains("icon"))
        #expect(htmlString.contains("16"))
        #expect(htmlString.contains("32"))
        #expect(htmlString.contains("192"))
        #expect(htmlString.contains("apple-touch-icon"))
        #expect(htmlString.contains("svg"))
        #expect(htmlString.contains("theme-color"))
    }
}
