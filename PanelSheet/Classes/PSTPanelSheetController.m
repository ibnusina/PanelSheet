//
//  PSTPanelSheetController.m
//  PanelSheet
//
//  Created by Ibnu Sina on 10/07/19.
//

#import "PSTPanelSheetController.h"
#import "PSTPanelNavigationView.h"

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
@property (strong, nonatomic) id panelContentViewOrViewController;
@property (strong, nonatomic) UIView *panelNavigationContentView;
@property (assign, nonatomic) CGFloat panelNavigationCustomHeight;
@property (assign, nonatomic) CGFloat panelContentCustomHeight;

@end

@implementation PSTPanelSheetController

- (instancetype)init
{
    NSBundle *bundle = [NSBundle bundleForClass:[PSTPanelSheetController class]];
    self = [super initWithNibName:@"PSTPanelSheetController" bundle:bundle];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.panelNavigationCustomHeight = -1;
        self.panelContentCustomHeight = -1;
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
    [self setupPanelContent];
    [self setupPanelNavigation];
}

#pragma mark - setup views

- (void)setupPanelContent
{
    if (self.panelContentViewOrViewController) {
        [self setPanelContentWithViewOrViewController:self.panelContentViewOrViewController];
    }
    if (self.panelContentCustomHeight > 0) {
        [self setPanelContentHeight:self.panelContentCustomHeight];
    }
}

- (void)setupPanelNavigation
{
    UIView *navigationView;
    if (self.panelNavigationContentView) {
        navigationView = self.panelContentView;
    } else {
        navigationView = [[PSTPanelNavigationView alloc] initWithTopCornerRadius:6
                                                                       holeWidth:50
                                                                      holeHeight:5
                                                                   holeTopMargin:10];
    }
    [self setNavigationView:navigationView];
    if (self.panelNavigationCustomHeight > 0) {
        [self setPanelNavigationHeight:self.panelNavigationCustomHeight];
    }
}

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
                             [subview.topAnchor constraintEqualToAnchor:superView.topAnchor],
                             [subview.rightAnchor constraintEqualToAnchor:superView.rightAnchor],
                             [subview.leftAnchor constraintEqualToAnchor:superView.leftAnchor],
                             [subview.bottomAnchor constraintEqualToAnchor:superView.bottomAnchor],
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

- (void)setPanelContentWithViewOrViewController:(id)viewOrViewController
{
    self.panelContentViewOrViewController = viewOrViewController;
    if ([self isViewLoaded]) {
        if ([viewOrViewController isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)viewOrViewController;
            [self removeAllSubviews:self.panelContentView];
            [self addSubview:view to:self.panelContentView];
            self.panelContentView.backgroundColor = view.backgroundColor;
        } else if ([viewOrViewController isKindOfClass:[UIViewController class]]) {
            UIViewController *viewController = (UIViewController *)viewOrViewController;
            [self addChildViewController:viewController];
            [self removeAllSubviews:self.panelContentView];
            [self addSubview:viewController.view to:self.panelContentView];
            [viewController didMoveToParentViewController:self];
            self.panelContentView.backgroundColor = viewController.view.backgroundColor;
        }
    }
}

- (void)setNavigationView:(UIView *)view
{
    self.panelNavigationContentView = view;
    if (self.isViewLoaded) {
        [self removeAllSubviews:self.panelNavigationView];
        [self addSubview:self.panelNavigationContentView to:self.panelNavigationView];
    }
}


- (void)setPanelContentHeight:(CGFloat)height
{
    self.panelContentCustomHeight = height;
    if (self.isViewLoaded) {
        self.panelContentHeightConstraint.constant = height;
    }
}

- (void)setPanelNavigationHeight:(CGFloat)height
{
    self.panelNavigationCustomHeight = height;
    if (self.isViewLoaded) {
        self.panelNavigationHeightConstraint.constant = height;
    }
}

- (void)setOverlayBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
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
