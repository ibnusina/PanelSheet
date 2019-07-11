//
//  PSTPanelSheetController.h
//  PanelSheet
//
//  Created by Ibnu Sina on 10/07/19.
//

#import <UIKit/UIKit.h>


@interface PSTPanelSheetController : UIViewController

- (void)setPanelContentWithViewOrViewController:(id)viewOrViewController;
- (void)setNavigationView:(UIView *)view;

- (void)setPanelContentHeight:(CGFloat)height;
- (void)setPanelNavigationHeight:(CGFloat)height;

- (void)setOverlayBackgroundColor:(UIColor *)color;

@end
