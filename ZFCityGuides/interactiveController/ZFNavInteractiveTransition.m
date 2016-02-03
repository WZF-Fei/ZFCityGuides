//
//  ZFNavInteractiveTransition.m
//  ZFCityGuides
//
//  Created by macOne on 16/2/2.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "ZFNavInteractiveTransition.h"

@interface ZFNavInteractiveTransition ()

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIViewController *viewController;
@property (assign, nonatomic) BOOL shouldCompleteTransition;

@end

@implementation ZFNavInteractiveTransition

-(void)dealloc {
    [_panGesture.view removeGestureRecognizer:_panGesture];
}

-(void)interactionForViewController:(UIViewController *)viewController{
    
    _viewController = viewController;

    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    

    //    NSLog(@"self frame:%@",NSStringFromCGRect(view.frame));
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:_panGesture];

}

-(void)handleGesture:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:[_viewController.view superview]];

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:

            if (translation.x >=0) {

                self.interactionInProgress = YES;
                [_viewController.navigationController popViewControllerAnimated:YES];

            }

            
            break;
        case UIGestureRecognizerStateChanged:
            if (self.interactionInProgress) {
                
                if (translation.x < 0) {
                    return;
                }
                //
                CGFloat fraction = fabs(translation.x / ([UIScreen mainScreen].bounds.size.width *0.7) );
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                
                _shouldCompleteTransition = (fraction > 0.4);
                if (fraction >= 1.0)
                    fraction = 0.99;

//                NSLog(@"trasnlation:%@,fraction:%f",NSStringFromCGPoint(translation),fraction);
                [self updateInteractiveTransition:fraction];
                
                
            }
            
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            
            
            if (self.interactionInProgress) {
                
                self.interactionInProgress = NO;
                if (!_shouldCompleteTransition || recognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }
    
}


- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}


@end
