//
//  PSTViewController.m
//  PanelSheet
//
//  Created by ibnusina on 07/10/2019.
//  Copyright (c) 2019 ibnusina. All rights reserved.
//

#import "PSTViewController.h"
#import <PanelSheet/PanelSheet.h>

@interface PSTViewController ()

@end

@implementation PSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTopButton];
    [self setupBottomButton];
}

- (void)setupTopButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 60, 300, 40);
    [self.view addSubview:button];
    [button setTitle:@"Show panel With UIViewController content" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPanelWithUIViewControllerContent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBottomButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 120, 300, 40);
    [self.view addSubview:button];
    [button setTitle:@"Show panel With UIView content" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showPanelWithIUIViewContent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showPanelWithUIViewControllerContent
{
    PSTPanelSheetController *panelController = [[PSTPanelSheetController alloc] init];
    PSTPanelNavigationView *navigationView = [[PSTPanelNavigationView alloc] initWithTopCornerRadius:20
        holeWidth:80
       holeHeight:5
                                                                                       holeTopMargin:10];
    [panelController setNavigationView:navigationView];
    [panelController setPanelNavigationHeight:30];
    [panelController setPanelContentHeight:200];
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = UIColor.redColor;
    [panelController setPanelContentWithViewOrViewController:viewController];
    [self presentViewController:panelController animated:NO completion:nil];
}

- (void)showPanelWithIUIViewContent
{
    PSTPanelSheetController *panelController = [[PSTPanelSheetController alloc] init];
    [panelController setPanelNavigationHeight:50];
    [panelController setPanelContentHeight:100];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.blueColor;
    [panelController setPanelContentWithViewOrViewController:view];
    [self presentViewController:panelController animated:NO completion:nil];
}

@end
