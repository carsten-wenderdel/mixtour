//
//  MIXViewController.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIXGameView.h"

@interface MIXViewController : UIViewController<MIXGameViewProtocol>

@property (nonatomic, strong) MIXModelBoard *board;
@property (nonatomic, strong) MIXGameView *gameView;

@end
