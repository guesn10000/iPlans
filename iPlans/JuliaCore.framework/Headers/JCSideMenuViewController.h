//
//  JCSideMenuViewController.h
//  JuliaCoreFramework
//
//  Created by Jymn_Chen on 14-3-6.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@class JCSideMenuViewController;

@protocol JCSideMenuViewControllerDelegate <NSObject>
@optional
- (void)sideMenuViewControllerWillOpenMenu :(JCSideMenuViewController *)aSideMenuViewController;
- (void)sideMenuViewControllerDidOpenMenu  :(JCSideMenuViewController *)aSideMenuViewController;
- (void)sideMenuViewControllerWillCloseMenu:(JCSideMenuViewController *)aSideMenuViewController;
- (void)sideMenuViewControllerDidCloseMenu :(JCSideMenuViewController *)aSideMenuViewController;
@end

typedef NS_ENUM(NSInteger, JCSide) {
    kJCRightSide  = -1,
    kJCMiddleSide =  0,
    kJCLeftSide   =  1
};

@interface JCSideMenuViewController : UIViewController

/* 判断当前菜单是否处于打开状态 */
@property (assign, nonatomic, getter = isOpen) BOOL open;

/* 当菜单打开时，main view controller的视图的偏移位置 */
@property (assign, nonatomic) UIOffset edgeOffset;

/* main view controller缩放后的尺寸 */
@property (assign, nonatomic) CGFloat zoomScale;

/* 判断当前打开的是哪一边的菜单 */
@property (assign, nonatomic) JCSide openingSide;

/* 委托 */
@property (weak, nonatomic) id<JCSideMenuViewControllerDelegate> delegate;

/* 左边的菜单视图控制器 */
@property (strong, nonatomic) UIViewController *leftMenuViewController;

/* 主视图控制器 */
@property (strong, nonatomic) UIViewController *mainViewController;

/* 右边的菜单视图控制器 */
@property (strong, nonatomic) UIViewController *rightMenuViewController;

/* 通过两边的菜单视图控制器和主视图控制器初始化 */
- (instancetype)initWithLeftMenuViewController:(UIViewController *)lMenuViewController
                            MainViewController:(UIViewController *)aMainViewController
                       RightMenuViewController:(UIViewController *)rMenuViewController;

@end


@interface JCSideMenuViewController (MenuToggle)

- (void)openMenuInSide:(JCSide)aSide Animated:(BOOL)animated Completion:(void (^)(BOOL finished))completion;

- (void)closeMenuAnimated:(BOOL)animated Completion:(void (^)(BOOL finished))completion;

@end


@interface UIViewController (SideMenu)

@property (weak, nonatomic) JCSideMenuViewController *sideMenuViewController;

- (void)addBackgroundImage:(UIImage *)image;

- (void)addBackgroundImageView:(UIImageView *)imageView;

@end
