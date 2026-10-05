import Case_Macro
import Coder
import HTTP
import HTTP_Router
import Optic

extension Favicon.Route: HTTP.Routable {
    public static var router: some HTTP.Router.`Protocol`<Favicon.Route> {
        Coder::Case(Self.cases.favicon.prism, Self.cases.favicon.fold, absent: .mismatch) {
            HTTP.Segment("favicon.ico")
            HTTP.Segment.End()
        }
        Coder::Case(Optic<Self, Self, Void, Void>.Prism.fixed(.appleTouchIcon(size: .`180`)), absent: .mismatch) {
            HTTP.Segment("apple-touch-icon-180x180.png")
            HTTP.Segment.End()
        }
        Coder::Case(Optic<Self, Self, Void, Void>.Prism.fixed(.appleTouchIcon(size: nil)), absent: .mismatch) {
            HTTP.Segment("apple-touch-icon.png")
            HTTP.Segment.End()
        }
        Coder::Case(Self.cases.appleTouchIconPrecomposed.prism, Self.cases.appleTouchIconPrecomposed.fold, absent: .mismatch) {
            HTTP.Segment("apple-touch-icon-precomposed.png")
            HTTP.Segment.End()
        }
        Coder::Case(Self.cases.icon.prism, Self.cases.icon.fold, absent: .mismatch) {
            HTTP.Segment.Value<Favicon.Route.Format>()
            HTTP.Segment.End()
        }
    }
}
