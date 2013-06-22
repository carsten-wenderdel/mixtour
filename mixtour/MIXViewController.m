//
//  MIXViewController.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXViewController.h"

#import "MIXGameBackgroundView.h"


@interface MIXViewController ()

@end

@implementation MIXViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIView *gameBackgroundView = [[MIXGameBackgroundView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:gameBackgroundView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
