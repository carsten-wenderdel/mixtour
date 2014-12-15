//
//  MIXGameView.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-23.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIXCore.h"

@class MIXModelBoard;


@protocol MIXGameViewProtocol
- (BOOL)tryToDragPiecesFrom:(MIXCoreSquare)from
                         to:(MIXCoreSquare)to
                 withNumber:(NSUInteger)numberOfDraggedPieces;
@end


@interface MIXGameView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<MIXGameViewProtocol> delegate;

- (void)setPieceWithColor:(UIColor *)color
                 onSquare:(MIXCoreSquare)square
             atUIPosition:(NSUInteger)uiPosition;
- (void)clearBoard;

@end
