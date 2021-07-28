import Core

public enum PlayerColor: Int, Identifiable {

    public var id: Int {
        self.rawValue
    }

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
