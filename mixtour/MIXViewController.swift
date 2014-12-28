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
        for i in 0..<5 {
            for j in 0..<5 {
                board.setPiece(ModelSquare(column: i, line: j))
            }
        }
        for i in 1...2 {
            for j in 0...3 {
                board.dragPiecesFrom(ModelSquare(column: i, line: j),
                        to: ModelSquare(column: i, line: j+1),
                        withNumber: j+1)
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
        let movePossible = self.board.dragPiecesFrom(ModelSquare(coreSquare: from), to: ModelSquare(coreSquare: to), withNumber: numberOfDraggedPieces)
        
        // display new state. If move not possible, this also moves the dragged piece to the old correct position
        gameView.clearBoard()
        gameView.setPiecesForBoard(self.board)
        
        return movePossible
    }

}


