//
//  PSTPanelNavigationView.m
//  PanelSheet_Example
//
//  Created by Ibnu Sina on 11/07/19.
//  Copyright © 2019 ibnusina. All rights reserved.
//

#import "PSTPanelNavigationView.h"

@interface PSTPanelNavigationView()

@property (nonatomic, assign) CGFloat outlineRadius;
@property (nonatomic, assign) CGFloat innerHoleWidth;
@property (nonatomic, assign) CGFloat innerHoleHeight;
@property (nonatomic, assign) CGFloat innerHoleTopMargin;

@end

@implementation PSTPanelNavigationView

- (instancetype)initWithTopCornerRadius:(CGFloat)radius
                              holeWidth:(CGFloat)holeWidth
                             holeHeight:(CGFloat)holeHeight
                          holeTopMargin:(CGFloat)holeTopMargin
{
    self = [super init];
    if (self) {
        self.outlineRadius = radius;
        self.innerHoleWidth = holeWidth;
        self.innerHoleHeight = holeHeight;
        self.innerHoleTopMargin = holeTopMargin;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.mask = [self createRoundedCornerWithHollowRectangleMask];
    self.backgroundColor = UIColor.whiteColor;
}

- (CAShapeLayer *)createRoundedCornerWithHollowRectangleMask
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [self createRoundedTopCornerPathWithRadius:self.outlineRadius];
    UIBezierPath *holePath = [self createHolePathWithWidth:self.innerHoleWidth height:self.innerHoleHeight topMargin:self.innerHoleTopMargin];
    [path appendPath:holePath];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    return maskLayer;
}

- (UIBezierPath *)createRoundedTopCornerPathWithRadius:(CGFloat)radius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    return path;
}

- (UIBezierPath *)createHolePathWithWidth:(CGFloat)width height:(CGFloat)height topMargin:(CGFloat)topMargin
{
    CGFloat xOrigin = (self.bounds.size.width - width)/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(xOrigin, topMargin, width, height) cornerRadius:height/2];
    return path;
}



@end
