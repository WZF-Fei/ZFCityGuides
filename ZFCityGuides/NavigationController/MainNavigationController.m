//
//  MainNavigationController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/27.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()<UINavigationControllerDelegate>

@end

@implementation MainNavigationController


+(void)initialize{
    //配置全局的navigation bar
    
    [[UINavigationBar appearance] setBarTintColor:kContentViewBgColor];
    //取消半透明
    [UINavigationBar appearance].translucent = NO;    
    //去掉横线
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    

}


-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    self.interactivePopGestureRecognizer.delegate =(id)self;

    self.interactivePopGestureRecognizer.enabled = YES;
  
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    

    if (_interactionViewController) {
        _interactionViewController.interactionOperationPop = (operation == UINavigationControllerOperationPop);
        [_interactionViewController interactionForViewController:toVC];
    }

    
    NavigationAnimationViewController *navigationAnimation = [NavigationAnimationViewController new];
    navigationAnimation.bPush = (operation == UINavigationControllerOperationPush);

    return navigationAnimation;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
 
    return _interactionViewController.interactionInProgress ? _interactionViewController: nil;
}


@end
