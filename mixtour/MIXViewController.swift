//
//  MIXViewController.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 09/11/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation
import UIKit
import MixModel

class MIXViewController: UIViewController, GameViewDelegate {

    lazy var board: ModelBoard = ModelBoard()
    var gameView: GameView!
    var boardBeforeMove: ModelBoard?
    var undoButton: UIButton?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView = GameView(frame: self.view.frame)
        gameView.delegate = self
        gameView.setPiecesForBoard(self.board)
        self.view.addSubview(gameView)
        
        let theUndoButton = UIButton(type: .system)
        theUndoButton.frame = CGRect(x: 0, y: 30, width: 50, height: 15)
        theUndoButton.setTitle("Undo", for: UIControl.State())
        theUndoButton.addTarget(self, action: #selector(undoMove), for: .touchUpInside)
        theUndoButton.isEnabled = (nil != boardBeforeMove)
        self.view.addSubview(theUndoButton);
        self.undoButton = theUndoButton;
        
        let restartButton = UIButton(type: .system)
        restartButton.frame = CGRect(x: 70, y: 30, width: 50, height: 15)
        restartButton.setTitle("New", for: UIControl.State())
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        self.view.addSubview(restartButton);
    }
    
    
    @objc func undoMove() {
        if let undoBoard = boardBeforeMove {
            boardBeforeMove = nil;
            undoButton?.isEnabled = false
            board = undoBoard
        }
        gameView.setPiecesForBoard(board)
    }
    
    @objc func restartGame() {
        self.board = ModelBoard()
        self.gameView .setPiecesForBoard(self.board)
        self.undoButton?.isEnabled = false
    }
    
    private func calculateNextMoveForGameView(_ gameView: GameView) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: { [weak self] in
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
        
        let oldBoard = ModelBoard(board: board)
        let movePossible = board.makeMoveIfLegal(move)
        
        // display new state. If move not possible, this also moves the dragged piece to the old correct position
        gameView.setPiecesForBoard(self.board)
        
        if (movePossible) {
            boardBeforeMove = oldBoard
            undoButton?.isEnabled = (nil != boardBeforeMove)
            calculateNextMoveForGameView(gameView)
        }
        
        return movePossible
    }

}


