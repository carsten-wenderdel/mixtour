//
//  GameView.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 09/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import UIKit

class GameView: MIXGameView {

    var pressedSquare: MIXCoreSquare?
    var pannedViews = [MIXGamePieceView]()
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizers()
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

