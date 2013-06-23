//
//  MIXGamePieceView.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-22.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXGamePieceView.h"



@interface MIXGamePieceView ()

@property (nonatomic, strong) UIColor *baseColor;

@end


@implementation MIXGamePieceView

- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color;
        self.baseColor = color;
        
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
