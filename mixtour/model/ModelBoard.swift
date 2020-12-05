//
//  ModelBoard.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 24/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation
import Core

let numberOfSquares = 5


class ModelBoard {
    
    var coreBoard = MIXCoreBoard()
    
    init() {
        resetCoreBoard(&coreBoard)
    }
    
    init(board: ModelBoard) {
        coreBoard = board.coreBoard
    }
    
    
    func isGameOver() -> Bool {
        return Core.isGameOver(&coreBoard)
    }
    
    
    func winner() -> ModelPlayer {
        let corePlayer = Core.winner(&coreBoard)
        return mixtour.ModelPlayer(corePlayer: corePlayer)
    }
    
    
    func playerOnTurn() -> ModelPlayer {
        let corePlayer = Core.playerOnTurn(&coreBoard)
        return mixtour.ModelPlayer(corePlayer: corePlayer)
    }
    
    
    func numberOfPiecesForPlayer(_ player: ModelPlayer) -> Int {
        return Int(Core.numberOfPiecesForPlayer(&coreBoard, player.corePlayer()))
    }
    
    
    func isSquareEmpty(_ square: ModelSquare) -> Bool {
        return Core.isSquareEmpty(&coreBoard, square.coreSquare())
    }
    
    
    func heightOfSquare(_ square: ModelSquare) -> Int {
        return Int(Core.heightOfSquare(&coreBoard, square.coreSquare()))
    }
    
    
    func colorOfSquare(_ square: ModelSquare, atPosition position: Int) -> ModelPlayer{
        let corePlayer = colorOfSquareAtPosition(&coreBoard, square.coreSquare(), UInt8(position))
        return mixtour.ModelPlayer(corePlayer: corePlayer)
    }
    
    
    /**
    If this is a legal move, it returns YES.
    If it's an illegal move, the move is not made and NO is returned. The model is still fine.
    */
    @discardableResult func setPiece(_ square: ModelSquare) -> Bool {
        let move = ModelMove(setPieceTo: square)
        return makeMoveIfLegal(move)
    }
    

    @discardableResult func dragPiecesFrom(_ from: ModelSquare, to: ModelSquare, withNumber numberODraggedPieces: Int) -> Bool {
        let modelMove = ModelMove(from: from, to: to, numberOfPieces: numberODraggedPieces)
        return makeMoveIfLegal(modelMove)
    }
    
    
    @discardableResult func makeMoveIfLegal(_ move: ModelMove) -> Bool {
        if isMoveLegal(move) {
            Core.makeMove(&coreBoard, move.coreMove())
            return true
        } else {
            return false
        }
    }
    

    func isMoveLegal(_ move: ModelMove) -> Bool {
        return Core.isMoveLegal(&coreBoard, move.coreMove())
    }

    
    func isSettingPossible() -> Bool {
        return Core.isSettingPossible(&coreBoard)
    }
    
    
    func isDraggingPossible() -> Bool {
        return Core.isDraggingPossible(&coreBoard)
    }
    
    
    func isSettingOrDraggingPossbile() -> Bool {
        return true
    }
    

    func allLegalMoves() -> [ModelMove] {
        var swiftMoves = [ModelMove]()
        let cMoves = Core.arrayOfLegalMoves(&coreBoard)
        for i in 0..<cMoves.n {
            let coreMove = cMoves.a[i]
            swiftMoves.append(ModelMove(coreMove: coreMove))
        }
        Core.destroyMoveArray(cMoves)
        return swiftMoves
    }
    
    
    func bestMove() -> ModelMove? {
        let move = Core.bestMove(&coreBoard)
        if Core.isMoveANoMove(move) {
            return nil
        } else {
            return ModelMove(coreMove: move)
        }
    }
    
    func printDescription() -> Void {
        printBoardDescription(&coreBoard);
    }
}
