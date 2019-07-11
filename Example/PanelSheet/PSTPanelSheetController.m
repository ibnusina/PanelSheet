//
//  PSTPanelSheetController.m
//  PanelSheet
//
//  Created by Ibnu Sina on 10/07/19.
//

#import "PSTPanelSheetController.h"

const CGFloat defaultOverlayAlpha = 0.6;

@interface PSTPanelSheetController ()
@property (weak, nonatomic) IBOutlet UIView *panelContainerView;
@property (weak, nonatomic) IBOutlet UIView *panelNavigationView;
@property (weak, nonatomic) IBOutlet UIView *panelContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelContentBottomContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelNavigationHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelContentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelContainerBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *freeSpaceView;

@end

@implementation PSTPanelSheetController

- (instancetype)init
{
//    NSBundle *bundle = [NSBundle bundleForClass:[PSTPanelSheetController class]];
//    self = [super initWithNibName:@"PSTPanelSheetController" bundle:bundle];
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [self defaultOverlayBackgroudColor:defaultOverlayAlpha];
    self.view.alpha = 0;
    [self addTapToDismissGesture:self.freeSpaceView];
    [self setupContentContainer];
    [self setupPanGesture];
}

#pragma mark - setup views

- (void)setupContentContainer
{
    self.panelContentBottomContraint.constant = [self getSafeAreaBottomInset];
    self.panelContainerBottomConstraint.constant = [self getPanelContainerMinimumBottomConstraint];
    [self performSelector:@selector(presentPanelFromBottom) withObject:nil afterDelay:0.1];
}

- (void)removeAllSubviews:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)addSubview:(UIView *)subview to:(UIView *)superView
{
    [superView addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraints = @[
                             [subview.topAnchor constraintEqualToAnchor:subview.topAnchor],
                             [subview.rightAnchor constraintEqualToAnchor:subview.rightAnchor],
                             [subview.leftAnchor constraintEqualToAnchor:subview.leftAnchor],
                             [subview.bottomAnchor constraintEqualToAnchor:subview.bottomAnchor],
                             ];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (UIColor *)defaultOverlayBackgroudColor:(CGFloat)alpha
{
    return [UIColor colorWithWhite:0.15 alpha:alpha];
}



- (CGFloat)getSafeAreaBottomInset
{
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        return bottomPadding;
    }
    return 0;
}

- (CGFloat)getPanelContainerMaximumBottomConstraint
{
    return 0;
}

- (CGFloat)getPanelContainerMinimumBottomConstraint
{
    return -(self.panelNavigationHeightConstraint.constant + self.panelContentHeightConstraint.constant);
}

- (CGFloat)getPanelContainerHeight
{
    return self.panelContentHeightConstraint.constant + self.panelNavigationHeightConstraint.constant + [self getSafeAreaBottomInset];
}

#pragma mark - public functions for modifying views

- (void)setContentController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self removeAllSubviews:self.panelContentView];
    [self addSubview:viewController.view to:self.panelContentView];
    [viewController didMoveToParentViewController:self];
}

- (void)setNavigationView:(UIView *)view
{
    [self removeAllSubviews:self.panelNavigationView];
    [self addSubview:view to:self.panelNavigationView];
}

#pragma mark - gesture and animation

- (void)addTapToDismissGesture:(UIView *)view
{
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePanelToBottomAndDismiss)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tapGesture];
}


- (void)presentPanelFromBottom
{
    [self animatePanelWithBottomConstraint:0 alpha:1 completion:nil];
}

- (void)hidePanelToBottomAndDismiss
{
    __weak PSTPanelSheetController *weakSelf = self;
    [self animatePanelWithBottomConstraint:[self getPanelContainerMinimumBottomConstraint] alpha:0 completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
}


- (void)animatePanelWithBottomConstraint:(CGFloat)bottomConstraint
                                   alpha:(CGFloat)alpha
                              completion:(void (^)(BOOL finished))completion
{
    __weak PSTPanelSheetController *weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf setPanelBottomContraint:bottomConstraint alpha:alpha];
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)setPanelBottomContraint:(CGFloat)bottomConstraint
                          alpha:(CGFloat)alpha
{
    self.view.alpha = alpha;
    self.panelContainerBottomConstraint.constant = bottomConstraint;
}

- (void)setupPanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.panelContainerView addGestureRecognizer:panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateChanged: {
            CGFloat movingDistance = [gestureRecognizer translationInView:self.panelContainerView].y;
            if (movingDistance > 0) {
                CGFloat newTransparancy = ([self getPanelContainerHeight] - movingDistance)/[self getPanelContainerHeight];
                NSLog(@"%f", newTransparancy);
                self.view.alpha = newTransparancy;
                self.panelContainerBottomConstraint.constant = -movingDistance;
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat movingDistance = [gestureRecognizer translationInView:self.panelContainerView].y;
            CGFloat halfContainerHeight = [self getPanelContainerHeight]/2;
            if (movingDistance > halfContainerHeight) {
                [self hidePanelToBottomAndDismiss];
            } else {
                [self presentPanelFromBottom];
            }
            break;
        }
        default:
            break;
    }
}

@end
