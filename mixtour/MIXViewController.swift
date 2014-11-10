//
//  MIXViewController.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 09/11/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation
import UIKit

class MIXViewController: UIViewController, MIXGameViewProtocol {

    var gameView: MIXGameView?
    let board: MIXModelBoard
    
    required init(coder aDecoder: NSCoder) {
        self.board = MIXModelBoard()
        super.init(coder:aDecoder)
        self.board = self.boardForTryingOut()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let newGameView = MIXGameView(frame: self.view.frame)
        newGameView.delegate = self
        newGameView.setPiecesForBoard(self.board)
        self.view.addSubview(newGameView)
        self.gameView = newGameView
    }


    // MARK: Methods
    
    func boardForTryingOut() -> MIXModelBoard {
        
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
    

    // MARK: MIXGameViewProtocol

     func tryToDragPiecesFrom(from: MIXCoreSquare, to: MIXCoreSquare, withNumber numberOfDraggedPieces: UInt) -> Bool {

        NSLog("Try to drag %lu pieces from %d/%d to %d/%d", numberOfDraggedPieces, from.column, from.line, to.column, to.line)
        
        // if move not possible, .dragPieces(...) does nothing
        let movePossible = self.board.dragPiecesFrom(from, to: to, withNumber: numberOfDraggedPieces)
        if let gameView = self.gameView {
            gameView.clearBoard()
            gameView.setPiecesForBoard(self.board)
        }
        
        return movePossible
    }

}


