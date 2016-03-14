//
//  NavigationAnimationViewController.m
//  ZFCityGuides
//
//  Created by macOne on 16/2/1.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "NavigationAnimationViewController.h"

@implementation NavigationAnimationViewController


//转场动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext; {
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [toVC beginAppearanceTransition:YES animated:YES];
    
    if(self.isPushed){
        [self pushViewControllerAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    } else {
        [self popViewControllerAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    
    [fromVC beginAppearanceTransition:YES animated:YES];
    
}

-(void)pushViewControllerAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    fromView.layer.anchorPoint = CGPointMake(0, 0.5);
    fromView.layer.position = CGPointMake(0, fromView.frame.origin.y +0.5 * fromView.frame.size.height);
    
    toView.layer.anchorPoint = CGPointMake(1, 0.5);
    toView.layer.position = CGPointMake(1 * toView.frame.size.width, toView.frame.origin.y + 0.5 * toView.frame.size.height);
    
    UIView* containerView = [transitionContext containerView];
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    
    [containerView addSubview:toView];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0/1000;
    fromView.layer.transform = t;

    CATransform3D t1= CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    //在y方向缩放
    t1 = CATransform3DScale(t1, 1, 0.8, 1);
    t1 = CATransform3DRotate(t1, DEGREES_TO_RADIANS(-2), 1, 0, 0);
    
    CATransform3D t2 = CATransform3DMakeRotation(-DEGREES_TO_RADIANS(80), 0, 1, 0);
    //沿x z轴平移
    t2 = CATransform3DTranslate(t2, frame.size.width, 0, -frame.size.width *0.7);
    t2 = CATransform3DScale(t2, 1, 1.5, 1);
    t2 = CATransform3DRotate(t2, DEGREES_TO_RADIANS(5), 1, 0, 0);

    
    toView.layer.transform = CATransform3DPerspect(t2, CGPointZero, 1000);
    
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
        fromView.layer.transform = CATransform3DPerspect(t1, CGPointZero, 1000);
        toView.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}


-(void)popViewControllerAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    fromView.layer.anchorPoint = CGPointMake(1, 0.5);
    fromView.layer.position = CGPointMake(1 * fromView.frame.size.width, fromView.frame.origin.y + 0.5 * fromView.frame.size.height);
    
    toView.layer.anchorPoint = CGPointMake(0, 0.5);
    toView.layer.position = CGPointMake(0, toView.frame.origin.y +0.5 * toView.frame.size.height);
    

    
    UIView* containerView = [transitionContext containerView];
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    
    [containerView addSubview:toView];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0/1000;
    fromView.layer.transform = t;
    
    CATransform3D t1= CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    //在y方向缩放
    t1 = CATransform3DScale(t1, 1, 0.8, 1);
    t1 = CATransform3DRotate(t1, DEGREES_TO_RADIANS(-2), 1, 0, 0);
    toView.layer.transform = CATransform3DPerspect(t1, CGPointZero, 1000);
    
    CATransform3D t2 = CATransform3DMakeRotation(-DEGREES_TO_RADIANS(80), 0, 1, 0);
    //沿x z轴平移
    t2 = CATransform3DTranslate(t2, frame.size.width, 0, 0);
    //放大
    t2 = CATransform3DScale(t2, 1, 1.5, 1);
    //旋转角度
    t2 = CATransform3DRotate(t2, DEGREES_TO_RADIANS(5), 1, 0, 0);
    
    
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        //执行动画t2
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.0f animations:^{
            fromView.layer.transform = CATransform3DPerspect(t2, CGPointZero, 1000);
            toView.layer.transform = CATransform3DIdentity;
        }];

        //执行动画t3
        [UIView addKeyframeWithRelativeStartTime:0.7f relativeDuration:0.3f animations:^{
            
            CATransform3D t3 = CATransform3DTranslate(t2, 0, 0, -frame.size.width *0.7);
            fromView.layer.transform = t3;

        }];
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
  
}
@end
