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
    
    private func calculateNextMoveForGameView(gameView: GameView) {
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { [weak self] _ in
            let move = self?.board.bestMove()
            
            if let bestMove = move {
                dispatch_async(dispatch_get_main_queue(), {
                    // TODO: self.board could be changed by user during AI calculation - freeze parts of the UI or make a deep copy of the board
                    // Also the ownership of gameView and board is not thought through
                    guard let this = self else {return}
                    this.board.makeMoveIfLegal(bestMove)
                    gameView.clearBoard()
                    gameView.setPiecesForBoard(this.board)
                })
            }
        })
    }
    

    // MARK: GameViewDelegate

    func gameView(gameView : GameView, tryToDragPieces numberOfDraggedPieces: Int, from: ModelSquare, to: ModelSquare) -> Bool {
        
        print("Try to drag \(numberOfDraggedPieces) pieces from \(from.column)/\(from.line) to \(to.column)/\(to.line)")
        
        let move = ModelMove(from: from, to: to, numberOfPieces: numberOfDraggedPieces)
        return self.gameView(gameView, tryToMakeMove: move)
    }
    
    func gameView(gameView : GameView, tryToSetPieceTo to: ModelSquare) -> Bool {
        
        print("Try to set piece to \(to.column)/\(to.line)")
        
        let move = ModelMove(setPieceTo: to)
        return self.gameView(gameView, tryToMakeMove: move)
    }
    
    func gameView(gameView : GameView, tryToMakeMove move: ModelMove) -> Bool {
        
        let movePossible = board.makeMoveIfLegal(move)
        
        // display new state. If move not possible, this also moves the dragged piece to the old correct position
        gameView.clearBoard()
        gameView.setPiecesForBoard(self.board)
        
        calculateNextMoveForGameView(gameView)
        
        return movePossible
    }

}


