//
//  GameView.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 09/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import UIKit


protocol GameViewDelegate: class {
    func gameView(gameView : GameView, tryToDragPieces numberOfDraggedPieces: Int, from: ModelSquare, to: ModelSquare) -> Bool
    func gameView(gameView : GameView, tryToSetPieceTo to: ModelSquare) -> Bool
    func gameView(gameView : GameView, tryToMakeMove move: ModelMove) -> Bool
}


class GameView: UIView, UIGestureRecognizerDelegate {

    weak var delegate: GameViewDelegate?

    var pressedSquare: ModelSquare?
    var pannedViews = [GamePieceView]()
    
    let upperLeftPoint: CGPoint
    let boardLength: CGFloat
    let squareLength: CGFloat
    let pieceWidth: CGFloat
    let pieceHeight: CGFloat
    
    lazy var fieldArray: [[[GamePieceView]]]! = {
        var lineArray = [[[GamePieceView]]]()
        for line in 0..<numberOfSquares {
            var columnArray = [[GamePieceView]]()
            for column in 0..<numberOfSquares {
                let viewArray = [GamePieceView]()
                columnArray.append(viewArray)
            }
            lineArray.append(columnArray)
        }
        return lineArray;
    }()

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        boardLength = min(frame.size.height, frame.size.width)
        squareLength = boardLength / CGFloat(numberOfSquares)
        pieceWidth = squareLength * 0.7
        pieceHeight = squareLength * 0.17
        
        let emptySpace = abs(frame.size.height - frame.size.width) / 2
        if frame.size.height > frame.size.width {
            // portrait view
            upperLeftPoint = CGPointMake(0, emptySpace)
        } else {
            upperLeftPoint = CGPointMake(emptySpace, 0)
        }
        
        super.init(frame: frame)
        
        // Background view with squares in two colors
        let backgroundRect = CGRectMake(upperLeftPoint.x, upperLeftPoint.y, boardLength, boardLength)
        let backgroundView = GameBackgroundView(frame: backgroundRect)
        addSubview(backgroundView)
        
        addGestureRecognizers()
    }
    
    
    // MARK: Manage logical arrangement of views in fieldArray
    
    private func pieceArrayForView(view: GamePieceView) -> [GamePieceView] {
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
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameView.handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameView.handleDoubleTapGesture(_:)))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func setPiecesForBoard(board: ModelBoard) {
        clearBoard()

        for column in 0..<numberOfSquares {
            for line in 0..<numberOfSquares {
                let square = ModelSquare(column: column, line: line)
                let height = board.heightOfSquare(square)
                for position in (0..<Int(height)).reverse() {
                    let player = board.colorOfSquare(square, atPosition: position)
                    let color = (player == ModelPlayer.White)
                        ? UIColor.yellowColor()
                        : UIColor.redColor()
                    // When there are 5 pieces, the upper most has - as always -
                    // the position 0, but the ui position 4
                    let uiPosition = height - position - 1
                    setPieceWithColor(color, onSquare: square, atUIPosition: uiPosition)
                }
            }
        }
    }
    
    
    private func setPieceWithColor(color: UIColor, onSquare square: ModelSquare, atUIPosition uiPosition: Int) {
        // find out where to place it
        let startX = upperLeftPoint.x
                + (squareLength * CGFloat(square.line))
                + ((squareLength - pieceWidth) / 2.0)
        let startY = upperLeftPoint.y
            + (squareLength * (CGFloat(square.column) + 0.9))
            - (pieceHeight * CGFloat(uiPosition + 1))
        let pieceFrame = CGRectMake(startX, startY, pieceWidth, pieceHeight)
        
        let pieceView = GamePieceView(frame: pieceFrame, baseColor: color)

        // display it
        addSubview(pieceView)
        
        // manage position logically
        fieldArray[square.column][square.line].append(pieceView)
    }
    

    private func squareForPosition(position: CGPoint) -> ModelSquare {
        let column = (position.y - upperLeftPoint.y) / squareLength
        let line = (position.x - upperLeftPoint.x) / squareLength
        let square = ModelSquare(column: Int(column), line: Int(line))
        return square
    }
    

    // MARK: GestureRecognizer Actions
    
    func handleDoubleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        let currentPoint = gestureRecognizer.locationInView(self)
        let square = squareForPosition(currentPoint)

        delegate?.gameView(self, tryToSetPieceTo: square)
    }

    func handlePressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        let currentPoint = gestureRecognizer.locationInView(self)
        let square = squareForPosition(currentPoint)
        print("handlePressGesture at square \(square.line)/\(square.column), state: \(gestureRecognizer.state.rawValue)")
        switch gestureRecognizer.state {
        case .Began:
            let upperMostView = hitTest(currentPoint, withEvent: nil)
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
        case .Ended, .Cancelled, .Failed:
            for view in pannedViews {
                view.alpha = 1.0
            }
            if (.Ended == gestureRecognizer.state) && (pannedViews.count > 0) {
                let currentPoint = gestureRecognizer.locationInView(self)
                let currentSquare = squareForPosition(currentPoint)
                delegate?.gameView(self, tryToDragPieces: pannedViews.count, from: pressedSquare!, to: currentSquare)
            }
            pannedViews.removeAll(keepCapacity: false)
        default: ()
        }
    }
    
    
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        print("handlePanGesture, state: \(gestureRecognizer.state.rawValue)");
        switch gestureRecognizer.state {
        case .Began, .Changed, .Ended:
            var center = gestureRecognizer.locationInView(self)
            for view in pannedViews {
                view.center = center;
                center.y -= pieceHeight;
            }
        default: ()
        }
    }
    
    
    // MARK: UIGestureRecognizer Delegate Methods
    

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
}

