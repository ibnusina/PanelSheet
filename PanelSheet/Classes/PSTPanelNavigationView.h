//
//  PSTPanelNavigationView.h
//  PanelSheet_Example
//
//  Created by Ibnu Sina on 11/07/19.
//  Copyright © 2019 ibnusina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PSTPanelNavigationView : UIView

- (instancetype)initWithTopCornerRadius:(CGFloat)radius
                              holeWidth:(CGFloat)holeWidth
                             holeHeight:(CGFloat)holeHeight
                          holeTopMargin:(CGFloat)holeTopMargin;

@end

NS_ASSUME_NONNULL_END
