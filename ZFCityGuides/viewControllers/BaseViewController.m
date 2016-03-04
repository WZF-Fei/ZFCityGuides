//
//  BaseViewController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/28.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigationAnimationViewController.h"
#import "PresentAnimationController.h"
#import "ZFMainTabBarController.h"
#import "ZFInteractiveTransition.h"


@interface BaseViewController ()


@property (nonatomic,strong) UIView *topWindow;

@property (strong,nonatomic) ZFInteractiveTransition *interactionViewController;

@property (assign,nonatomic) CGRect topViewFrame;

@end

@implementation BaseViewController

-(void)dealloc{
    
    NSLog(@"%@--dealloc",self);
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showTopWindow" object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationTintColor = [UIColor whiteColor];
    //自定义navigationbar 先隐藏原来的
    self.navigationController.navigationBarHidden = YES;
    
    //自定义navigationBar
    _navigationBarView = [UIView new];
    _navigationBarView.backgroundColor = kContentViewBgColor;
    _navigationBarView.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [self.view addSubview:_navigationBarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTopWindow:) name:@"showTopWindow" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!self.topWindow) {
        _topWindow = [UIView new];
        _topWindow.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height -60, 50, 40);
        _topWindow.layer.cornerRadius = 5;
        _topWindow.layer.masksToBounds = YES;
        
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.image = [UIImage imageNamed:@"main-menu-toggle-arrow-iphone@2x"];
        self.topViewFrame = CGRectMake(0, 0, 50, 40);
        imageView.frame = self.topViewFrame;
        imageView.contentMode = UIViewContentModeCenter;
        [_topWindow addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopWindow:)];
        
        [_topWindow addGestureRecognizer:tap];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_topWindow];

    }
   
}

-(void)showTopWindow:(NSNotification *)notification{
    
    [self.topWindow removeFromSuperview];
    self.topWindow = nil;
    
    NSLog(@"执行一次");
    
    _topWindow = [UIView new];
    _topWindow.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height -60, 50, 40);
    _topWindow.layer.cornerRadius = 5;
    _topWindow.layer.masksToBounds = YES;
    
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.image = [UIImage imageNamed:@"main-menu-toggle-arrow-iphone@2x"];
    self.topViewFrame = CGRectMake(0, 0, 50, 40);
    imageView.frame = self.topViewFrame;
    imageView.contentMode = UIViewContentModeCenter;
    [_topWindow addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopWindow:)];
    
    [_topWindow addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_topWindow];
    

}

-(void)tapTopWindow:(UITapGestureRecognizer *)recognizer{
    

    ZFMainTabBarController *mainTabBarVC = [[ZFMainTabBarController alloc] init];
    mainTabBarVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    mainTabBarVC.transitioningDelegate = self;

    self.interactionViewController = [ZFInteractiveTransition new];
    [self presentViewController:mainTabBarVC animated:YES completion:^{

    }];

 
}

#pragma mark - setter and getter方法


-(void)setNavigationTitle:(NSString *)navigationTitle{
    _navigationTitle = navigationTitle;
    self.navigationItem.title = navigationTitle;
}

-(void)setNavigationTintColor:(UIColor *)navigationTintColor{
    if (navigationTintColor) {
        NSDictionary * dict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f], NSForegroundColorAttributeName: navigationTintColor};
        
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
    else
    {
        //默认是黑色字体
        NSDictionary * dict = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor blackColor]};
        
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
}

-(void) setLeftItemImage:(UIImage *)leftItemImage{
    if (leftItemImage) {
        _leftItemImage = leftItemImage;
    }
    else{
        _leftItemImage = nil;
    }
}

-(void) setMidItemImage:(UIImage *)midItemImage{
    
    if (midItemImage) {
        _midItemImage = midItemImage;
    }
    else{
        _midItemImage = nil;
    }
}
-(void) setRightItemImage:(UIImage *)rightItemImage{
    if (rightItemImage) {
        _rightItemImage = rightItemImage;
    }
    else{
        _rightItemImage = nil;
    }
}

#pragma mark - 创建navigationBar 样式

- (void) createNavigationBarWithStyle:(NavigationStyle)navigationStyle
                            leftImage:(UIImage *)leftImage
                             midImage:(UIImage *)midImage
                           rightImage:(UIImage *)rightImage
{
    self.leftItemImage = leftImage;
    self.midItemImage = midImage;
    self.rightItemImage = rightImage;
    

    switch (navigationStyle) {
        case NavigationStyleLeft:
            
            [self setUpLeftNaviagtionBarItem];
            
            break;
            
        case NavigationStyleLeftAndMid:
            
            [self setUpLeftNaviagtionBarItem];
            [self setUpMidNaviagtionBarItem];
            
            break;
            
        case NavigationStyleMidAndRight:
            
            [self setUpMidNaviagtionBarItem];
            [self setUpRightNaviagtionBarItem];
            
            break;
        case NavigationStyleLeftAndRight:
            
            [self setUpLeftNaviagtionBarItem];
            [self setUpRightNaviagtionBarItem];
            
            break;
        case NavigationStyleAll:
            
            [self setUpLeftNaviagtionBarItem];
            [self setUpMidNaviagtionBarItem];
            [self setUpRightNaviagtionBarItem];
            
            break;
            
        default:
            break;
    }

}

- (void)setUpLeftNaviagtionBarItem{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.leftItemImage) {
        [backBtn setFrame:CGRectMake(20, (self.navigationBarView.frame.size.height - self.leftItemImage.size.height) /2 , self.leftItemImage.size.width , self.leftItemImage.size.height)];
    }
    
    UIImage * backImage = [self.leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
    [_navigationBarView addSubview:backBtn];

}

- (void)setUpMidNaviagtionBarItem
{
    //rightButton
    
    UIButton *midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    midBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [midBtn setTitle:self.navigationTitle forState:UIControlStateNormal];
    [midBtn setFrame:CGRectMake(150/2, 0 ,  _navigationBarView.frame.size.width - 150 , _navigationBarView.frame.size.height)];
    
    UIImage * midImage = [self.midItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    midImage.size = midImage.size;
    [midBtn setImage:midImage forState:UIControlStateNormal];
    
    if (self.navigationTitle) {
        midBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 15);
    }

    [_navigationBarView addSubview:midBtn];
}


- (void)setUpRightNaviagtionBarItem
{
    //rightButton
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.rightItemImage) {
        [moreBtn setFrame:CGRectMake(0, 0 , self.rightItemImage.size.width , self.rightItemImage.size.height)];
    }
    
    UIImage * moreImage = [self.rightItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [moreBtn setImage:moreImage forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];

    [_navigationBarView addSubview:moreBtn];
}


#pragma mark -返回
-(void)back:(UIButton *)sender
{
    [self.topWindow removeFromSuperview];
    self.topWindow = nil;
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)more:(UIButton *)sender{
    
    NSLog(@"more");
}


-(void)pushNextViewController:(UIViewController *)viewController animated:(BOOL)animated{

    [self.topWindow removeFromSuperview];
    self.topWindow = nil;
    
    
    [self.navigationController pushViewController:viewController animated:animated];
    
}
#pragma mark -UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    
    [_interactionViewController interactionForViewController:presented];
    
    PresentAnimationController *presentAnimation = [PresentAnimationController new];
    presentAnimation.dismiss = NO;
    return presentAnimation;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    PresentAnimationController *presentAnimation = [PresentAnimationController new];
    presentAnimation.dismiss = YES;
    return presentAnimation;
}


- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    
    return _interactionViewController.interactionInProgress ? _interactionViewController: nil;
}

@end
