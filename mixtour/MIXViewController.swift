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

    lazy var board: ModelBoard = ModelBoard()
    var gameView: GameView!
    var boardBeforeMove: ModelBoard?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView = GameView(frame: self.view.frame)
        gameView.delegate = self
        gameView.setPiecesForBoard(self.board)
        self.view.addSubview(gameView)
        
        let undoButton = UIButton(type: .system)
        undoButton.frame = CGRect(x: 0, y: 30, width: 50, height: 15)
        undoButton.setTitle("Undo", for: UIControlState())
        undoButton.addTarget(self, action: #selector(undoMove), for: .touchUpInside)
        self.view.addSubview(undoButton);
    }
    
    
    func undoMove() {
        if let undoBoard = boardBeforeMove {
            board = undoBoard
        }
        gameView.setPiecesForBoard(board)
    }
    
    private func calculateNextMoveForGameView(_ gameView: GameView) {
        
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosBackground).async(execute: { [weak self] _ in
            let move = self?.board.bestMove()
            
            if let bestMove = move {
                DispatchQueue.main.async(execute: {
                    // TODO: self.board could be changed by user during AI calculation - freeze parts of the UI or make a deep copy of the board
                    // Also the ownership of gameView and board is not thought through
                    guard let this = self else {return}
                    this.board.makeMoveIfLegal(bestMove)
                    gameView.setPiecesForBoard(this.board)
                })
            }
        })
    }
    

    // MARK: GameViewDelegate

    func gameView(_ gameView : GameView, tryToDragPieces numberOfDraggedPieces: Int, from: ModelSquare, to: ModelSquare) -> Bool {
        
        print("Try to drag \(numberOfDraggedPieces) pieces from \(from.column)/\(from.line) to \(to.column)/\(to.line)")
        
        let move = ModelMove(from: from, to: to, numberOfPieces: numberOfDraggedPieces)
        return self.gameView(gameView, tryToMakeMove: move)
    }
    
    func gameView(_ gameView : GameView, tryToSetPieceTo to: ModelSquare) -> Bool {
        
        print("Try to set piece to \(to.column)/\(to.line)")
        
        let move = ModelMove(setPieceTo: to)
        return self.gameView(gameView, tryToMakeMove: move)
    }
    
    func gameView(_ gameView : GameView, tryToMakeMove move: ModelMove) -> Bool {
        
        boardBeforeMove = ModelBoard(board: board)
        let movePossible = board.makeMoveIfLegal(move)
        
        // display new state. If move not possible, this also moves the dragged piece to the old correct position
        gameView.setPiecesForBoard(self.board)
        
        if (movePossible) {
            calculateNextMoveForGameView(gameView)
        }
        
        return movePossible
    }

}


