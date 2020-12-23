import UIKit

class GamePieceView: UIView {
    
    let baseColor: UIColor;
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, baseColor: UIColor) {
        self.baseColor = baseColor;
        super.init(frame: frame);
        self.backgroundColor = baseColor;
        self.layer.borderWidth = 1
    }
}
