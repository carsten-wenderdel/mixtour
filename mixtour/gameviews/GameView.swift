//
//  GameView.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 09/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import UIKit

class GameView: MIXGameView {

    let numberOfSquares = 5

    var pressedSquare: MIXCoreSquare?
    var pannedViews = [MIXGamePieceView]()
    
    let upperLeftPoint: CGPoint
    let boardLength: CGFloat
    let squareLength: CGFloat
    let pieceWidth: CGFloat
    let pieceHeight: CGFloat
    

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
        let backgroundView = MIXGameBackgroundView(frame: backgroundRect)
        addSubview(backgroundView)
        
        addGestureRecognizers()
    }
    
    
    func addGestureRecognizers() {
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handlePressGesture:")
        pressGestureRecognizer.delegate = self
        pressGestureRecognizer.minimumPressDuration = 0.3
        self.addGestureRecognizer(pressGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    func setPiecesForBoard(board: MIXModelBoard) {
        for column in 0..<numberOfSquares {
            for line in 0..<numberOfSquares {
                let square = MIXCoreSquareMake(UInt8(column), UInt8(line))
                let height = board.heightOfSquare(square)
                for var position = Int(height) - 1; position >= 0; position-- {
                    let player:MIXCorePlayer = board.colorOfSquare(square, atPosition: UInt8(position))
                    let color = (player.value == MIXCorePlayerWhite.value)
                        ? UIColor.yellowColor()
                        : UIColor.redColor()
                    // When there are 5 pieces, the upper most has - as always -
                    // the position 0, but the ui position 4
                    let uiPosition = height - position - 1
                    self.setPieceWithColor(color, onSquare: square, atUIPosition: uiPosition)
                }
            }
        }
    }
    
    
    func setPieceWithColor(color: UIColor, onSquare square: MIXCoreSquare, atUIPosition uiPosition: UInt) {
        let startX = upperLeftPoint.x
                + (squareLength * CGFloat(square.line))
                + ((squareLength - pieceWidth) / 2.0)
        let startY = upperLeftPoint.y
            + (squareLength * (CGFloat(square.column) + 0.9))
            - (pieceHeight * CGFloat(uiPosition + 1))
        let pieceFrame = CGRectMake(startX, startY, pieceWidth, pieceHeight)
        
        let pieceView = MIXGamePieceView(frame: pieceFrame, withColor: color)
        addSubview(pieceView)
        pieceViewArrayForSquare(square).addObject(pieceView)
    }
    
    func squareForPosition(position: CGPoint) -> MIXCoreSquare {
        let column = (position.y - upperLeftPoint.y) / squareLength
        let line = (position.x - upperLeftPoint.x) / squareLength
        var square = MIXCoreSquare(column: UInt8(column), line: UInt8(line))
        return square
    }
    
    // MARK: pragma mark GestureRecognizer Actions

    func handlePressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        var currentPoint = gestureRecognizer.locationInView(self)
        var square = self.squareForPosition(currentPoint)
        println("handlePressGesture at square \(square.line)/\(square.column), state: \(gestureRecognizer.state.rawValue)")
        switch gestureRecognizer.state {
        case .Began:
            let upperMostView = self.hitTest(currentPoint, withEvent: nil)
            if let pressedPieceView = upperMostView as? MIXGamePieceView {
                var viewsToPan = [MIXGamePieceView]()
                let viewArray = self.pieceArrayForView(pressedPieceView)
                var viewNeedsToBePanned = false
                for pieceView in viewArray {
                    if pieceView === pressedPieceView {
                        viewNeedsToBePanned = true
                    }
                    if viewNeedsToBePanned {
                        // TODO: remove casting
                        viewsToPan.append(pieceView as MIXGamePieceView)
                    }
                }
                self.pannedViews = viewsToPan
                self.pressedSquare = square
            }
        case .Ended, .Cancelled, .Failed:
            for view in self.pannedViews {
                view.alpha = 1.0
            }
            if (.Ended == gestureRecognizer.state) && (self.pannedViews.count > 0) {
                let currentPoint = gestureRecognizer.locationInView(self)
                let currentSquare = self.squareForPosition(currentPoint)
                // TODO: maybe rethink UInt / Int
                self.delegate .tryToDragPiecesFrom(self.pressedSquare!, to: currentSquare, withNumber:UInt(self.pannedViews.count))
            }
            self.pannedViews.removeAll(keepCapacity: false)
        default: ()
        }
    }
    
    
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        println("handlePanGesture, state: \(gestureRecognizer.state.rawValue)");
        switch gestureRecognizer.state {
        case .Began, .Changed, .Ended:
            var center = gestureRecognizer.locationInView(self)
            for view in self.pannedViews {
                view.center = center;
                center.y -= self.pieceHeight;
            }
        default: ()
        }
    }
    
    
    // MARK: UIGestureRecognizer Delegate Methods
    

    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
}

