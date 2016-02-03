//
//  PresentAnimationController.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/15.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentAnimationController : NSObject<UIViewControllerAnimatedTransitioning>


@property (nonatomic, getter=isDismissed,assign) BOOL dismiss;

@end
