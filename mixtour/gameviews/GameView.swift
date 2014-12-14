//
//  GameView.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 09/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import UIKit

class GameView: MIXGameView {


    // MARK: pragma mark GestureRecognizer Actions

    override func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer!) {
        println("handlePanGesture, state: %ld", gestureRecognizer.state);
        switch gestureRecognizer.state {
        case .Began, .Changed, .Ended:
            // TODO: remove casting and nil checking
            if let pannedViews = self.pannedViews? {
                var center = gestureRecognizer.locationInView(self)
                for object in pannedViews {
                    var view = object as UIView
                    view.center = center;
                    center.y -= self.pieceHeight;
                }
            }
        default: ()
        }
    }
    
    
    // MARK: UIGestureRecognizer Delegate Methods
    

    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
}

