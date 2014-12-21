//
//  GamePieceView.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 21/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

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
    }
}
