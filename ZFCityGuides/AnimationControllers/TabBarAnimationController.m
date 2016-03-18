//
//  TabBarAnimationController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/27.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "TabBarAnimationController.h"

@implementation TabBarAnimationController

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    

    UIView* containerView = [transitionContext containerView];
    
    
    [toVC beginAppearanceTransition:YES animated:YES];
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.y = -offScreenFrame.size.height;
    toView.frame = offScreenFrame;
    
    CGRect fromViewFrame = frame;
    fromViewFrame.origin.y = fromViewFrame.size.height;
    
    [containerView addSubview:toView];
    
    //toView初始状态
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-500;
    //x顺时针 转60度
    t1 = CATransform3DRotate(t1, DEGREES_TO_RADIANS(60), 1, 0, 0);
    //x y 方向缩放
    t1 = CATransform3DScale(t1,0.2, 0.2, 1);
    //动画加入到toView
    toView.layer.transform = t1;

    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //fromView 下移消失
        fromView.frame = fromViewFrame;
        //toView 下移出现
        toView.frame = frame;
        //还原3d
        toView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    [fromVC beginAppearanceTransition:NO animated:YES];
}

@end
