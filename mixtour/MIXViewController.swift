//
//  MIXViewController.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 09/11/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation
import UIKit

class MIXViewController: UIViewController, GameViewDelegate {

    lazy var board: ModelBoard = {
        let board = ModelBoard()
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
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        let newGameView = GameView(frame: self.view.frame)
        newGameView.delegate = self
        newGameView.setPiecesForBoard(self.board)
        newGameView.setPiecesForBoard(self.board)
        self.view.addSubview(newGameView)
    }
    

    // MARK: GameViewDelegate

    func gameView(gameView : GameView, tryToDragPieces numberOfDraggedPieces: Int, from: MIXCoreSquare, to: MIXCoreSquare) -> Bool {
        
        println("Try to drag \(numberOfDraggedPieces) pieces from \(from.column)/\(from.line) to \(to.column)/\(to.line)")
        
        // if move not possible, .dragPieces(...) does nothing
        let movePossible = self.board.dragPiecesFrom(from, to: to, withNumber: UInt(numberOfDraggedPieces))
        
        // display new state. If move not possible, this also moves the dragged piece to the old correct position
        gameView.clearBoard()
        gameView.setPiecesForBoard(self.board)
        
        return movePossible
    }

}


