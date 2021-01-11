import UIKit
import MixModel

protocol GameViewDelegate: class {
    @discardableResult func gameView(_ gameView : GameView, tryToDragPieces numberOfDraggedPieces: Int, from: Square, to: Square) -> Bool
    @discardableResult func gameView(_ gameView : GameView, tryToSetPieceTo to: Square) -> Bool
    @discardableResult func gameView(_ gameView : GameView, tryToMakeMove move: Move) -> Bool
}


class GameView: UIView, UIGestureRecognizerDelegate {

    let usePieceDivider = false
    var dividerStartSquare: Square?
    
    weak var delegate: GameViewDelegate?

    var pressedSquare: Square?
    var pannedViews = [GamePieceView]()
    
    let upperLeftPoint: CGPoint
    let boardLength: CGFloat
    let squareLength: CGFloat
    let pieceWidth: CGFloat
    let pieceHeight: CGFloat
    
    private var _fieldArray: [[[GamePieceView]]]?
    var fieldArray: [[[GamePieceView]]]! {
        get {
            if (nil == _fieldArray) {
                var lineArray = [[[GamePieceView]]]()
                for _ in 0..<numberOfSquares { // line
                    var columnArray = [[GamePieceView]]()
                    for _ in 0..<numberOfSquares { // column
                        let viewArray = [GamePieceView]()
                        columnArray.append(viewArray)
                    }
                    lineArray.append(columnArray)
                }
                _fieldArray = lineArray;
            }
            return _fieldArray
        }
        set {
            _fieldArray = newValue
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        boardLength = min(frame.size.height, frame.size.width)
        squareLength = boardLength / CGFloat(numberOfSquares)
        pieceWidth = squareLength * 0.8
        pieceHeight = squareLength * 0.18
        
        let emptySpace = abs(frame.size.height - frame.size.width) / 2
        if frame.size.height > frame.size.width {
            // portrait view
            upperLeftPoint = CGPoint(x: 0, y: emptySpace)
        } else {
            upperLeftPoint = CGPoint(x: emptySpace, y: 0)
        }
        
        super.init(frame: frame)
        
        // Background view with squares in two colors
        let backgroundRect = CGRect(x: upperLeftPoint.x, y: upperLeftPoint.y, width: boardLength, height: boardLength)
        let backgroundView = GameBackgroundView(frame: backgroundRect)
        addSubview(backgroundView)
        
        addGestureRecognizers()
    }
    
    
    // MARK: Manage logical arrangement of views in fieldArray
    
    private func pieceArrayForView(_ view: GamePieceView) -> [GamePieceView] {
        for columnArray in fieldArray {
            for viewArray in columnArray {
                for pieceView in viewArray {
                    if (pieceView == view) {
                        return viewArray
                    }
                }
            }
        }
        assert(false, "view is not in fieldArray, but should be")
        return [GamePieceView]()
    }
    
    func clearBoard() {
        // remove all references to piece views to avoid memory leaks
        for columnArray in fieldArray {
            for viewArray in columnArray {
                for pieceView in viewArray {
                    pieceView.removeFromSuperview()
                }
            }
        }
        fieldArray = nil
    }
    
    
    private func addGestureRecognizers() {
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GameView.handlePressGesture(_:)))
        pressGestureRecognizer.delegate = self
        pressGestureRecognizer.minimumPressDuration = 0.3
        addGestureRecognizer(pressGestureRecognizer)
        pressGestureRecognizer.isEnabled = !usePieceDivider
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameView.handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.isEnabled = !usePieceDivider
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePieceDividerGesture(_:)))
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.isEnabled = usePieceDivider
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameView.handleDoubleTapGesture(_:)))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func setPiecesForBoard(_ board: ModelBoard) {
        clearBoard()

        for column in 0..<numberOfSquares {
            for line in 0..<numberOfSquares {
                let square = Square(column: column, line: line)
                let height = board.heightOfSquare(square)
                for position in (0..<Int(height)).reversed() {
                    let player = board.colorOfSquare(square, atPosition: position)
                    let color = (player == ModelPlayer.white)
                        ? UIColor.yellow
                        : UIColor.red
                    // When there are 5 pieces, the upper most has - as always -
                    // the position 0, but the ui position 4
                    let uiPosition = height - position - 1
                    setPieceWithColor(color, onSquare: square, atUIPosition: uiPosition)
                }
            }
        }
    }
    
    
    private func setPieceWithColor(_ color: UIColor, onSquare square: Square, atUIPosition uiPosition: Int) {
        let pieceFrame = frameOnSquare(square, atUIPosition: uiPosition)
        let pieceView = GamePieceView(frame: pieceFrame, baseColor: color)

        // display it
        addSubview(pieceView)
        
        // manage position logically
        fieldArray[square.column][square.line].append(pieceView)
    }
    
    private func frameOnSquare(_ square: Square, atUIPosition uiPosition: Int) -> CGRect {
        let startX = upperLeftPoint.x
            + (squareLength * CGFloat(square.column))
            + ((squareLength - pieceWidth) / 2.0)
        let startY = upperLeftPoint.y
            + (squareLength * (CGFloat(square.line) + 0.9))
            - (pieceHeight * CGFloat(uiPosition + 1))
        let pieceFrame = CGRect(x: startX, y: startY, width: pieceWidth, height: pieceHeight)
        return pieceFrame
    }
    
    private func uiPositionForPosition(_ position: CGPoint) -> Int {
        let yPositionInSquare = (position.y - upperLeftPoint.y).truncatingRemainder(dividingBy: squareLength)
        let uiPosition = (0.9 * squareLength - yPositionInSquare) / pieceHeight
        return Int(uiPosition)
    }
    
    private func squareForPosition(_ position: CGPoint) -> Square {
        let line = (position.y - upperLeftPoint.y) / squareLength
        let column = (position.x - upperLeftPoint.x) / squareLength
        let square = Square(column: Int(column), line: Int(line))
        return square
    }
    

    // MARK: GestureRecognizer Actions
    
    @objc func handleDoubleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        let currentPoint = gestureRecognizer.location(in: self)
        let square = squareForPosition(currentPoint)

        delegate?.gameView(self, tryToSetPieceTo: square)
    }

    @objc func handlePressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let currentPoint = gestureRecognizer.location(in: self)
        let square = squareForPosition(currentPoint)
        print("handlePressGesture at square \(square.line)/\(square.column), state: \(gestureRecognizer.state.rawValue)")
        switch gestureRecognizer.state {
        case .began:
            let upperMostView = hitTest(currentPoint, with: nil)
            if let pressedPieceView = upperMostView as? GamePieceView {
                var viewsToPan = [GamePieceView]()
                let viewArray = pieceArrayForView(pressedPieceView)
                var viewNeedsToBePanned = false
                for pieceView in viewArray {
                    if pieceView === pressedPieceView {
                        viewNeedsToBePanned = true
                    }
                    if viewNeedsToBePanned {
                        viewsToPan.append(pieceView)
                    }
                }
                pannedViews = viewsToPan
                pressedSquare = square
            }
        case .ended, .cancelled, .failed:
            for view in pannedViews {
                view.alpha = 1.0
            }
            if (.ended == gestureRecognizer.state) && (pannedViews.count > 0) {
                let currentPoint = gestureRecognizer.location(in: self)
                let currentSquare = squareForPosition(currentPoint)
                delegate?.gameView(self, tryToDragPieces: pannedViews.count, from: pressedSquare!, to: currentSquare)
            }
            pannedViews.removeAll(keepingCapacity: false)
        default: ()
        }
    }
    
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("handlePanGesture, state: \(gestureRecognizer.state.rawValue)");
        switch gestureRecognizer.state {
        case .began, .changed, .ended:
            var center = gestureRecognizer.location(in: self)
            for view in pannedViews {
                view.center = center;
                center.y -= pieceHeight;
            }
        default: ()
        }
    }
    
    @objc func handlePieceDividerGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let currentPoint = gestureRecognizer.location(in: self)
        let square = squareForPosition(currentPoint)
        print("handlePieceDividerGesture at square \(square.line)/\(square.column), state: \(gestureRecognizer.state.rawValue)")
        
        switch gestureRecognizer.state {
        case .began :
            dividerStartSquare = square
        case .changed:
            guard let square = dividerStartSquare else {
                break
            }
            let uiPosition = uiPositionForPosition(currentPoint)
            print("uiPosition: \(uiPosition)")
            let pieceViewsInSquare = fieldArray[square.column][square.line]
            if pieceViewsInSquare.count > uiPosition {
                for (index, pieceView) in pieceViewsInSquare.enumerated() {
                    var pieceFrame = self.frameOnSquare(square, atUIPosition: index)
                    print ("old: \(pieceView.frame), new: \(pieceFrame)")
                    if index >= uiPosition {
                        pieceFrame.origin.y -= 20
                    }
                    pieceView.frame = pieceFrame;
                }
            }

        case .ended:
            delegate?.gameView(self, tryToSetPieceTo: Square(column: 10, line: 10))
        default: ()
        }
    }
    
    
    // MARK: UIGestureRecognizer Delegate Methods
    

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
}

