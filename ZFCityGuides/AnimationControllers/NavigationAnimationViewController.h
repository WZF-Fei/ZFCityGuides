//
//  NavigationAnimationViewController.h
//  ZFCityGuides
//
//  Created by macOne on 16/2/1.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationAnimationViewController : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, getter=isPushed,assign) BOOL bPush;

@end
