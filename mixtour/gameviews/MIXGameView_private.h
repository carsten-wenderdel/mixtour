//
//  MIXGameView_protected.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2014-12-09.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

@class MIXGamePieceView;

@interface MIXGameView()

- (NSMutableArray *)pieceArrayForView:(MIXGamePieceView *)view;
- (NSMutableArray *)pieceViewArrayForSquare:(MIXCoreSquare)square;

@end
