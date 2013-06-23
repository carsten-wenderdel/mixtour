//
//  MIXGameBackgroundView.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-23.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXGameBackgroundView.h"

#define numberOfSquares 5

@implementation MIXGameBackgroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat squareHeight = frame.size.height / (CGFloat)numberOfSquares;
        CGFloat squareWidth = frame.size.width / (CGFloat)numberOfSquares;
        
        for (int i = 0; i < numberOfSquares; i++) {
            for (int j = 0; j < numberOfSquares; j++) {
                CGRect squareFrame = CGRectMake(i * squareWidth,
                                                j * squareHeight,
                                                squareWidth,
                                                squareHeight);
                UIView *squareView = [[UIView alloc] initWithFrame:squareFrame];
                if ((i + j) % 2 == 0) {
                    squareView.backgroundColor = [UIColor colorWithRed:0.9f green:0.93f blue:1.0f alpha:1.0];
                } else {
                    squareView.backgroundColor = [UIColor colorWithRed:0.8f green:0.85f blue:1.0f alpha:1.0];
                }
                [self addSubview:squareView];
            }
        }
    }
    return self;
}


@end
