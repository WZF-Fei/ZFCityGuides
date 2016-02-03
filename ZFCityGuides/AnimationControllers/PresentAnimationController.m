//
//  PresentAnimationController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/15.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "PresentAnimationController.h"


@interface PresentAnimationController ()

@property (nonatomic,strong) UIViewController *toVC;

@end

@implementation PresentAnimationController


//转场动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext; {
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    _toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = _toVC.view;
    UIView *fromView = fromVC.view;
    

    if(self.isDismissed){
        [self RunDismissAnimation:transitionContext fromVC:fromVC toVC:_toVC fromView:fromView toView:toView];
    } else {
        [self RunPresentAnimation:transitionContext fromVC:fromVC toVC:_toVC fromView:fromView toView:toView];
    }
//    // 调用viewWillDisappear
//    [_toVC beginAppearanceTransition:NO animated:YES];
    //调用toVC的viewWillAppear
//    [_toVC beginAppearanceTransition:YES animated:YES];
    
}

#pragma mark - presentAnimation

-(void)RunPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    
    UIView* containerView = [transitionContext containerView];
    
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.y = offScreenFrame.size.height;
    toView.frame = offScreenFrame;
    
    [containerView insertSubview:toView aboveSubview:fromView];
    
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-1000;
    t1 = CATransform3DRotate(t1, DEGREES_TO_RADIANS(-10), 1, 0, 0);

    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = 1.0/-1000;
    //沿Y方向向上移动
    t2 = CATransform3DTranslate(t2, 0, -fromView.frame.size.height*0.4, 0);
    //在x y方向各缩放比例为0.8
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        //执行动画t1
        [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.2f animations:^{
            fromView.layer.transform = t1;
            fromView.alpha = 0.6;
        }];
        //执行动画t2
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.3f animations:^{
            fromView.layer.transform = t2;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.4f animations:^{
            toView.frame = frame;
        }];
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

    
}
#pragma mark - dismissAnimation
-(void)RunDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    

    
    UIView* containerView = [transitionContext containerView];

    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    toView.frame = frame;

    [containerView insertSubview:toView belowSubview:fromView];
    
    CGRect frameOffScreen = frame;
    frameOffScreen.origin.y = frame.size.height ;

    //dismiss前的初始状态
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0/1000;
    t = CATransform3DTranslate(t, 0, -fromView.frame.size.height*0.4, 0);
    t = CATransform3DScale(t, 0.8, 0.8, 1);
    toView.layer.transform = t;
    
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-1000;
    t1 = CATransform3DRotate(t1, DEGREES_TO_RADIANS(0), 1, 0, 0);
    
    [UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        //先旋转角度
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.8f animations:^{
            //旋转-10度
            CATransform3D t2 = CATransform3DRotate(t, DEGREES_TO_RADIANS(-10), 1, 0, 0);
            //以（0，60）作为相机点
            toView.layer.transform = CATransform3DPerspect(t2, CGPointMake(0, 60), 500);
        }];
        
        //下移fromView
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.0f animations:^{
            fromView.frame = frameOffScreen;

        }];
        //角度变小
        [UIView addKeyframeWithRelativeStartTime:0.1f relativeDuration:0.6f animations:^{
            toView.layer.transform = t1;

        }];
        //还原3D状态
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.4f animations:^{
            toView.layer.transform = CATransform3DIdentity;
            toView.alpha = 1.0;
        }];
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            //如果取消，触发viewWillDisappear
//            [_toVC beginAppearanceTransition:NO animated:YES];
        }
        else{
            
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        //解决背景变黑
        [[[UIApplication sharedApplication] keyWindow] addSubview:containerView];
    }];

    

}


-(void)animationEnded:(BOOL)transitionCompleted{
    if (transitionCompleted) {
        //相应的触发viewDidAppear或viewDisappear
//        [_toVC endAppearanceTransition];
    }
}

@end
