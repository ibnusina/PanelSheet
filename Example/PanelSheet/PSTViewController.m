//
//  PSTViewController.m
//  PanelSheet
//
//  Created by ibnusina on 07/10/2019.
//  Copyright (c) 2019 ibnusina. All rights reserved.
//

#import "PSTViewController.h"
#import "PSTPanelSheetController.h"

@interface PSTViewController ()

@end

@implementation PSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupButton];
}

- (void)setupButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 20, 100, 40);
    [self.view addSubview:button];
    [button setTitle:@"Show panel" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPanel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showPanel
{
    PSTPanelSheetController *controller = [[PSTPanelSheetController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
