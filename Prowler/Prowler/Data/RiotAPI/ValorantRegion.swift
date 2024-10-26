enum ValorantRegion: String {
    case NA = "na"
    case EU = "eu"
    case AP = "ap"
    case KO = "ko"
    
    var baseURL: String {
        switch self {
        case .NA:
            return "https://pd.na.a.pvp.net"
        case .EU:
            return "https://pd.eu.a.pvp.net"
        case .AP:
            return "https://pd.ap.a.pvp.net"
        case .KO:
            return "https://pd.ko.a.pvp.net"
        }
    }
}
