//
//  MIXViewController.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXViewController.h"

#import "MIXGameView.h"
#import "MIXGamePieceView.h"


@interface MIXViewController ()

@end

@implementation MIXViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    MIXGameView *gameBackgroundView = [[MIXGameView alloc] initWithFrame:self.view.frame];
    gameBackgroundView.delegate = self;
	[self.view addSubview:gameBackgroundView];
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
    
    return YES;
}

@end
