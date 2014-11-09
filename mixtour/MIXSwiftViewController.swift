//
//  MIXSwiftViewController.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 09/11/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation
import UIKit

class MIXSwiftViewController: MIXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let newGameView = MIXGameView(frame: self.view.frame)
        newGameView.delegate = self
        self.board = self.boardForTryingOut()
        newGameView.setPiecesForBoard(self.board)
        self.view.addSubview(newGameView)
        self.gameView = newGameView
    }

}


