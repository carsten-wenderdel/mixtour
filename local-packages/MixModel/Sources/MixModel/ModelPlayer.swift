import Core

public enum ModelPlayer: Int {
    case white = 0
    case black = 1
    
    init?(corePlayer: MIXCorePlayer) {
        switch corePlayer.rawValue {
        case MIXCorePlayerWhite.rawValue:
            self = .white
        case MIXCorePlayerBlack.rawValue:
            self = .black
        default:
            return nil
        }
    }
    
    func corePlayer() -> MIXCorePlayer {
        switch self {
        case .white:
            return MIXCorePlayerWhite
        case .black:
            return MIXCorePlayerBlack
        }
    }
}
