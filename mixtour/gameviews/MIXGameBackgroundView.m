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
        
        CGFloat boardLength = MIN(frame.size.height, frame.size.width);
        CGPoint upperLeftPoint;
        if (frame.size.height > frame.size.width) {
            // portrait view
            CGFloat emptyVerticalSpace = (frame.size.height - boardLength) / 2.0f;
            upperLeftPoint = CGPointMake(0, emptyVerticalSpace);
        } else {
            // landscape view
            CGFloat emptyHorizontalSpace = (frame.size.width - boardLength) / 2.0f;
            upperLeftPoint = CGPointMake(emptyHorizontalSpace, 0);
        }
        CGFloat squareLength = boardLength / (CGFloat)numberOfSquares;
        
        for (int i = 0; i < numberOfSquares; i++) {
            for (int j = 0; j < numberOfSquares; j++) {
                CGRect squareFrame = CGRectMake(upperLeftPoint.x + i * squareLength,
                                                upperLeftPoint.y + j * squareLength,
                                                squareLength,
                                                squareLength);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
