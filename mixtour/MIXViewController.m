//
//  MIXViewController.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXViewController.h"

#import "MIXGameView.h"
#import "MIXModelBoard.h"


@interface MIXViewController ()

@property (nonatomic, strong) MIXModelBoard *board;
@property (nonatomic, strong) MIXGameView *gameView;

@end

@implementation MIXViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.gameView removeFromSuperview];
    MIXGameView *newGameView = [[MIXGameView alloc] initWithFrame:self.view.frame];
    newGameView.delegate = self;
    self.board = [self boardForTryingOut];
    [newGameView setPiecesForBoard:self.board];
	[self.view addSubview:newGameView];
    self.gameView = newGameView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark MIXGameViewProtocol

- (BOOL)tryToDragPiecesFrom:(MIXCoreSquare)from
                         to:(MIXCoreSquare)to
                 withNumber:(NSUInteger)numberOfDraggedPieces {
    
    NSLog(@"Try to drag %d pieces from %d/%d to %d/%d", numberOfDraggedPieces,
          from.column, from.line, to.column, to.line);
    
    // if move not possible, [dragPieces...] does nothing
    BOOL movePossible = [self.board dragPiecesFrom:from to:to withNumber:numberOfDraggedPieces];
    [self.gameView clearBoard];
    [self.gameView setPiecesForBoard:self.board];
    
    return movePossible;
}

#pragma mark Methods

- (MIXModelBoard *)boardForTryingOut
{
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            [board setPiece:MIXCoreSquareMake(i, j)];
        }
    }
    
    for (int i = 1; i <=2; i++) {
        for (int j = 0; j <= 3; j++) {
            [board dragPiecesFrom:MIXCoreSquareMake(i, j)
                               to:MIXCoreSquareMake(i, j+1)
                       withNumber:j+1];
        }
    }
    return board;
}

@end
