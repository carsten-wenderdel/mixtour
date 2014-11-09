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


    // MARK: Methods
    
    func boardForTryingOut() -> MIXModelBoard! {
        
        let board = MIXModelBoard()
        for i:UInt8 in 0..<5 {
            for j:UInt8 in 0..<5 {
                board.setPiece(MIXCoreSquareMake(i, j))
            }
        }
        for i:UInt8 in 1...2 {
            for j:UInt8 in 0...3 {
                board.dragPiecesFrom(MIXCoreSquareMake(i, j),
                        to: MIXCoreSquareMake(i, j+1),
                        withNumber: UInt(j) + 1)
            }
        }
        return board
    }
    
}


