//
//  PSTPanelSheetController.m
//  PanelSheet
//
//  Created by Ibnu Sina on 10/07/19.
//

#import "PSTPanelSheetController.h"
#import "PSTPanelNavigationView.h"

const CGFloat defaultOverlayAlpha = 0.6;

@interface PSTPanelSheetController ()<UIViewControllerTransitioningDelegate>
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
@property (assign, nonatomic) BOOL isKeyboardShown;

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
    self.view.backgroundColor = [self defaultOverlayBackgroudColor:0];
    [self addTapToDismissGesture:self.freeSpaceView];
    [self addTapToDismissKeyboardGesture:self.panelContainerView];
    [self setupContentContainer];
    [self setupPanGesture];
    [self setupPanelContent];
    [self setupPanelNavigation];
    [self setupKeyboardObserver];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
        navigationView = self.panelNavigationContentView;
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

- (void)addSubview:(UIView *)subview
                to:(UIView *)superView
{
    [self addSubview:subview to:superView addBottomSafeAreaPadding:false];
}

- (void)addSubview:(UIView *)subview
                to:(UIView *)superView
addBottomSafeAreaPadding:(BOOL)addBottomPadding
{
    [superView addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        bottomPadding = window.safeAreaInsets.bottom;
    }

    NSArray *constraints = @[
                             [subview.topAnchor constraintEqualToAnchor:superView.topAnchor],
                             [subview.rightAnchor constraintEqualToAnchor:superView.rightAnchor],
                             [subview.leftAnchor constraintEqualToAnchor:superView.leftAnchor],
                             [subview.bottomAnchor constraintEqualToAnchor:superView.bottomAnchor constant:bottomPadding],
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
            [self addSubview:view to:self.panelContentView addBottomSafeAreaPadding:YES];
            self.panelContentView.backgroundColor = view.backgroundColor;
        } else if ([viewOrViewController isKindOfClass:[UIViewController class]]) {
            UIViewController *viewController = (UIViewController *)viewOrViewController;
            [self addChildViewController:viewController];
            [self removeAllSubviews:self.panelContentView];
            [self addSubview:viewController.view to:self.panelContentView addBottomSafeAreaPadding:YES];
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
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardOrDismissPanel)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tapGesture];
}

- (void)addTapToDismissKeyboardGesture:(UIView *)view
{
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tapGesture];
}


- (void)presentPanelFromBottom
{
    [self animatePanelWithBottomConstraint:0 alpha:1 completion:nil];
}

- (void)dismissKeyboardOrDismissPanel {
    if (self.isKeyboardShown) {
        [self dismissKeyboard];
    } else {
        [self hidePanelToBottomAndDismissWithCompletion:nil];
    }
}

- (void)hidePanelToBottomAndDismissWithCompletion:(void (^)(void))completion
{
    [self removeKeyboardObserver];
    __weak PSTPanelSheetController *weakSelf = self;
    [self animatePanelWithBottomConstraint:[self getPanelContainerMinimumBottomConstraint] alpha:0 completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:completion];
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
    self.view.backgroundColor = [self defaultOverlayBackgroudColor:defaultOverlayAlpha * alpha];
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
                [self setPanelBottomContraint:-movingDistance alpha:newTransparancy];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat movingDistance = [gestureRecognizer translationInView:self.panelContainerView].y;
            CGFloat halfContainerHeight = [self getPanelContainerHeight]/2;
            if (movingDistance > halfContainerHeight) {
                [self hidePanelToBottomAndDismissWithCompletion:nil];
            } else {
                [self presentPanelFromBottom];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - keyboard handler

- (void)setupKeyboardObserver {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(moveUpPanel:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setKeyboardAppear) name:UIKeyboardDidShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(moveDownPanel:) name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setKeyboardDisappear) name:UIKeyboardDidHideNotification object:nil];
}

- (void)setKeyboardAppear {
    self.isKeyboardShown = YES;
}

- (void)setKeyboardDisappear {
    self.isKeyboardShown = NO;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)removeKeyboardObserver {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)moveUpPanel:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = [self appropriateKeyboardHeightFromRect:rect];
    NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.panelContentBottomContraint.constant = keyboardHeight;
    [self runAnimationWithCurve:curve duration:duration];
}

- (CGFloat)appropriateKeyboardHeightFromRect:(CGRect)rect
{
    CGRect keyboardRect = [self.view convertRect:rect fromView:nil];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat keyboardMinY = CGRectGetMinY(keyboardRect);
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        keyboardMinY += bottomPadding;
    }
    
    
    CGFloat keyboardDefaultHeight = MAX(0.0, viewHeight - keyboardMinY);
    return keyboardDefaultHeight;
}


- (void)moveDownPanel:(NSNotification *)notification {
    NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.panelContentBottomContraint.constant = 0;
    [self runAnimationWithCurve:curve duration:duration];
}

- (void)runAnimationWithCurve:(NSInteger)curve duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
         delay:0.0
       options:(curve<<16)|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState
    animations:^{
        [self.view layoutIfNeeded];
    }
    completion:nil];
}


@end
