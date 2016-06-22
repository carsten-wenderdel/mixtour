//
//  GameBackgroundView.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 23/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import UIKit

class GameBackgroundView : UIView {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let squareHeight = frame.size.height / CGFloat(numberOfSquares)
        let squareWidth = frame.size.width / CGFloat(numberOfSquares)
        
        for i in 0..<numberOfSquares {
            for j in 0..<numberOfSquares {
                let squareFrame = CGRect(x: CGFloat(i) * squareWidth, y: CGFloat(j) * squareWidth, width: squareWidth, height: squareHeight)
                let squareView = UIView(frame: squareFrame)
                if (i + j) % 2 == 0 {
                    squareView.backgroundColor = UIColor(red: 0.9, green: 0.93, blue: 1.0, alpha: 1.0)
                } else {
                    squareView.backgroundColor = UIColor(red: 0.8, green: 0.85, blue: 1.0, alpha: 1.0)
                }
                addSubview(squareView)
            }
        }
    }
    
}

