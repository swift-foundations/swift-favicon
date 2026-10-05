extension Favicon.Route.Format: LosslessStringConvertible {
    public init?(_ description: String) {
        switch description {
        case "icon.svg": self = .svg
        case "icon-16x16.png": self = .png(.`16`)
        case "icon-32x32.png": self = .png(.`32`)
        case "icon-180x180.png": self = .png(.`180`)
        case "icon-192x192.png": self = .png(.`192`)
        case "icon-512x512.png": self = .png(.`512`)
        default: return nil
        }
    }

    public var description: String {
        switch self {
        case .svg: "icon.svg"
        case .png(.`16`): "icon-16x16.png"
        case .png(.`32`): "icon-32x32.png"
        case .png(.`180`): "icon-180x180.png"
        case .png(.`192`): "icon-192x192.png"
        case .png(.`512`): "icon-512x512.png"
        }
    }
}
