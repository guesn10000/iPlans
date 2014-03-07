//
//  JCSideMenuViewController.m
//  JuliaCoreFramework
//
//  Created by Jymn_Chen on 14-3-6.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "JCSideMenuViewController.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#if 1
#define iOS7_BACKGROUND_SIDE_VIEW
#endif

#ifndef iOS7_BACKGROUND_SIDE_VIEW
    static CGFloat const kZoomScale = 1.0;
#else
    static CGFloat const kZoomScale = 0.5;
#endif

static CGFloat const kHorizontaliPhoneOffset = 18.0f;
static CGFloat const kHorizontaliPadOffset   = -40.0f;

static CGFloat const kOpenMenuAnimationDuration  = 0.4;
static CGFloat const kOpenMenuAnimationDelay     = 0.0;
static CGFloat const kCloseMenuAnimationDuration = 0.4;
static CGFloat const kCloseMenuAnimationDelay    = 0.0;
static CGFloat const kRotationAnimationDuration  = 0.2;

@interface JCSideMenuViewController ()

@property (strong, nonatomic) UIButton *_closeOverlayButton;

@property (strong, nonatomic) UISwipeGestureRecognizer *_swipeRightGesture;

@property (strong, nonatomic) UISwipeGestureRecognizer *_swipeLeftGesture;

@end

@implementation JCSideMenuViewController
@synthesize _closeOverlayButton;
@synthesize _swipeRightGesture;
@synthesize _swipeLeftGesture;

#pragma mark - Initialization

- (instancetype)initWithLeftMenuViewController:(UIViewController *)lMenuViewController
                            MainViewController:(UIViewController *)aMainViewController
                       RightMenuViewController:(UIViewController *)rMenuViewController
{
    self = [super init];
    
    if (self) {
        self.leftMenuViewController  = lMenuViewController;
        self.rightMenuViewController = rMenuViewController;
        self.mainViewController      = aMainViewController;
    }
    
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化基本参数
    self.zoomScale   = kZoomScale;
    self.openingSide = kMiddleSide;
    self.edgeOffset  = (UIOffset) {
        .horizontal = (IS_IPHONE ? kHorizontaliPhoneOffset : kHorizontaliPadOffset),
        .vertical = 0.0
    };
    
    // 添加左边的菜单视图控制器
    if (self.leftMenuViewController) {
        [self addChildViewController:self.leftMenuViewController];
        [self.view addSubview:self.leftMenuViewController.view];
        [self.leftMenuViewController didMoveToParentViewController:self];
        self.leftMenuViewController.sideMenuViewController = self;
        self.leftMenuViewController.view.hidden = YES;
    }
    
    // 添加右边的菜单视图控制器
    if (self.rightMenuViewController) {
        [self addChildViewController:self.rightMenuViewController];
        [self.view addSubview:self.rightMenuViewController.view];
        [self.rightMenuViewController didMoveToParentViewController:self];
        self.rightMenuViewController.sideMenuViewController = self;
        self.rightMenuViewController.view.hidden = YES;
    }
    
    // 添加主视图控制器
    if (self.mainViewController) {
        [self addChildViewController:self.mainViewController];
        [self.view addSubview:self.mainViewController.view];
        [self.mainViewController didMoveToParentViewController:self];
        self.mainViewController.sideMenuViewController = self;
    }
    
    // 添加左右轻扫手势，用于关闭菜单
    _swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    _swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeRightGesture];
    
    _swipeLeftGesture  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    _swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:_swipeLeftGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Menu Management

- (CGAffineTransform)enlargeTransformForMenuView {
    
#ifdef iOS7_BACKGROUND_SIDE_VIEW
    if (self.openingSide == kLeftSide) { // 如果是左边的菜单视图，那么先扩大，再向左平移一定距离
        CGFloat scaleSize = 1.0f / self.zoomScale;
        CGAffineTransform scaleTransform = CGAffineTransformScale(self.leftMenuViewController.view.transform,
                                                                  scaleSize,
                                                                  scaleSize);
        return CGAffineTransformTranslate(scaleTransform,
                                          -self.openingSide * (self.view.frame.size.width / scaleSize),
                                          0.0);
    }
    else if (self.openingSide == kRightSide) { // 如果是右边的菜单视图，那么直接放大
        return CGAffineTransformScale(self.rightMenuViewController.view.transform, 2.5f, 2.5f);
    }
    
    return CGAffineTransformIdentity;
#else
    if (self.openingSide == kLeftSide) {
        return CGAffineTransformTranslate(self.leftMenuViewController.view.transform,
                                          -self.openingSide * (self.view.frame.size.width / 2),
                                          0.0);
    }
    else if (self.openingSide == kRightSide) {
        return CGAffineTransformTranslate(self.rightMenuViewController.view.transform,
                                          -self.openingSide * (self.view.frame.size.width / 2),
                                          0.0);
    }
    
    return CGAffineTransformIdentity;
#endif
    
}

- (void)makeEnlargeTransformForMenuView {
    if (self.openingSide == kLeftSide) {
        self.leftMenuViewController.view.transform = [self enlargeTransformForMenuView];
    }
    else if (self.openingSide == kRightSide) {
        self.rightMenuViewController.view.transform = [self enlargeTransformForMenuView];
    }
}

- (void)makeRestoreTransformForMenuView {
    if (self.openingSide == kLeftSide) {
        self.leftMenuViewController.view.transform = CGAffineTransformIdentity;
    }
    else if (self.openingSide == kRightSide) {
        self.rightMenuViewController.view.transform = CGAffineTransformIdentity;
    }
}

- (void)showCurrentMenuView {
    if (self.openingSide == kLeftSide) {
        self.leftMenuViewController.view.hidden = NO;
    }
    else if (self.openingSide == kRightSide) {
        self.rightMenuViewController.view.hidden = NO;
    }
}

- (void)hideCurrentMenuView {
    if (self.openingSide == kLeftSide) {
        self.leftMenuViewController.view.hidden = YES;
    }
    else if (self.openingSide == kRightSide) {
        self.rightMenuViewController.view.hidden = YES;
    }
}

- (CGAffineTransform)openTransformForView:(UIView *)view {
    CGFloat transformSize = self.zoomScale;
    CGAffineTransform curTransform = CGAffineTransformTranslate(view.transform,
                                                                self.openingSide *\
                                                                (CGRectGetMidX(view.bounds) + self.edgeOffset.horizontal),
                                                                self.openingSide *\
                                                                self.edgeOffset.vertical);
    return CGAffineTransformScale(curTransform, transformSize, transformSize);
}

- (void)openMenuInSide:(JCSide)aSide Animated:(BOOL)animated Completion:(void (^)(BOOL))completion {
    if (self.open) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerWillOpenMenu:)]) {
        [self.delegate sideMenuViewControllerWillOpenMenu:self];
    }
    
    self.open = YES;
    
    self.openingSide = aSide;
    
    [self makeEnlargeTransformForMenuView];
    [self showCurrentMenuView];
    
    
    void (^openMenuBlock)(void) = ^{
        [self makeRestoreTransformForMenuView];
        self.mainViewController.view.transform = [self openTransformForView:self.mainViewController.view];
    };
    
    void (^openCompleteBlock)(BOOL) = ^(BOOL finished) {
        if (finished) {
            [self addOverlayButtonToScaleViewController];
            
            [self updateStatusBarStyle];
        }
        
        if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerDidOpenMenu:)]) {
	        [self.delegate sideMenuViewControllerDidOpenMenu:self];
        }
        
        if (completion) {
            completion(finished);
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:kOpenMenuAnimationDuration
                              delay:kOpenMenuAnimationDelay
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:openMenuBlock
                         completion:openCompleteBlock];
    }
    else {
        openMenuBlock();
        openCompleteBlock(YES);
    }
}

- (void)closeMenuAnimated:(BOOL)animated Completion:(void (^)(BOOL))completion {
    if (!self.open) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerWillCloseMenu:)]) {
        [self.delegate sideMenuViewControllerWillCloseMenu:self];
    }
    
    self.open = NO;
    
    [self removeOverlayButtonFromScaleViewController];
    
    void (^closeMenuBlock)(void) = ^{
        self.mainViewController.view.transform = CGAffineTransformIdentity;
        [self makeEnlargeTransformForMenuView];
    };
    
    void (^closeCompleteBlock)(BOOL) = ^(BOOL finished) {
        if (finished) {
            [self updateStatusBarStyle];
        }
        [self makeRestoreTransformForMenuView];
        [self hideCurrentMenuView];
        
        self.openingSide = kMiddleSide;
        
        if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerDidCloseMenu:)]) {
            [self.delegate sideMenuViewControllerDidCloseMenu:self];
        }
        
        if (completion) {
            completion(finished);
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:kCloseMenuAnimationDuration
                              delay:kCloseMenuAnimationDelay
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:closeMenuBlock
                         completion:closeCompleteBlock];
    }
    else {
        closeMenuBlock();
        closeCompleteBlock(YES);
    }
}

#pragma mark - Gesture Actions

- (void)swipeRight:(UISwipeGestureRecognizer *)sender {
    if (self.openingSide == kRightSide) {
        [self closeMenuAnimated:YES Completion:nil];
    }
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)sender {
    if (self.openingSide == kLeftSide) {
        [self closeMenuAnimated:YES Completion:nil];
    }
}

#pragma mark - Overlay button management

- (void)addOverlayButtonToScaleViewController {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.accessibilityLabel = nil;
    button.accessibilityHint  = nil;
    button.backgroundColor = [UIColor clearColor];
    button.opaque = NO;
    button.frame = self.mainViewController.view.frame;
    
    [button addTarget:self action:@selector(closeButtonTouchUpInside)  forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(closeButtonTouchedDown)    forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(closeButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.view addSubview:button];
    _closeOverlayButton = button;
}

- (void)removeOverlayButtonFromScaleViewController {
    [_closeOverlayButton removeFromSuperview];
}

- (void)closeButtonTouchUpInside {
    [self closeMenuAnimated:YES Completion:nil];
}

- (void)closeButtonTouchedDown {
    _closeOverlayButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
}

- (void)closeButtonTouchUpOutside {
    _closeOverlayButton.backgroundColor = [UIColor clearColor];
}

#pragma mark - Status Bar management

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (!self.isOpen) {
        return self.mainViewController;
    }
    else {
        return (self.openingSide == kLeftSide) ? self.leftMenuViewController : self.rightMenuViewController;
    }
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (!self.isOpen) {
        return self.mainViewController;
    }
    else {
        return (self.openingSide == kLeftSide) ? self.leftMenuViewController : self.rightMenuViewController;
    }
}

- (void)updateStatusBarStyle {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (self.open) {
        [self removeOverlayButtonFromScaleViewController];
        
        [UIView animateWithDuration:kRotationAnimationDuration animations:^{
            [self makeEnlargeTransformForMenuView];
            self.mainViewController.view.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (self.open) {
        [UIView animateWithDuration:kRotationAnimationDuration animations:^{
            [self makeRestoreTransformForMenuView];
            self.mainViewController.view.transform = [self openTransformForView:self.mainViewController.view];
        } completion:^(BOOL finished) {
            [self addOverlayButtonToScaleViewController];
        }];
    }
}

@end

#pragma mark - UIViewController SideMenu Category

@implementation UIViewController (SideMenu)

- (void)setSideMenuViewController:(JCSideMenuViewController *)sideMenuViewController {
    objc_setAssociatedObject(self, @selector(sideMenuViewController), sideMenuViewController, OBJC_ASSOCIATION_ASSIGN);
    
}

- (JCSideMenuViewController *)sideMenuViewController {
    JCSideMenuViewController *aSideMenuViewController = objc_getAssociatedObject(self, @selector(sideMenuViewController));
    if (!aSideMenuViewController) {
        aSideMenuViewController = self.parentViewController.sideMenuViewController;
    }
    return aSideMenuViewController;
    
}

- (void)addBackgroundImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addBackgroundImageView:imageView];
}

- (void)addBackgroundImageView:(UIImageView *)imageView {
    [imageView removeFromSuperview];
    imageView.frame = [[UIScreen mainScreen] bounds];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    // 不允许将AutoresizingMask转换成Autolayout
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view insertSubview:imageView atIndex:0];
}

@end
