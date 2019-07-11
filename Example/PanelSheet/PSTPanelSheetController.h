//
//  PSTPanelSheetController.h
//  PanelSheet
//
//  Created by Ibnu Sina on 10/07/19.
//

#import <UIKit/UIKit.h>


@interface PSTPanelSheetController : UIViewController

- (void)setContentController:(UIViewController *)viewController;
- (void)setNavigationView:(UIView *)view;


- (void)setOverlayBackgroundColor:(UIColor *)color;
- (void)setContentBackgroundColor:(UIColor *)color;
- (void)setNavigationBackgroundColor:(UIColor *)color;

@end
