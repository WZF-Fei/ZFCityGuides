//
//  BaseViewController.h
//  ZFCityGuides
//
//  Created by macOne on 16/1/28.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    NavigationStyleNone,
    NavigationStyleLeft,
    NavigationStyleLeftAndMid,
    NavigationStyleLeftAndRight,
    NavigationStyleMidAndRight,
    NavigationStyleAll
    
} NavigationStyle;


@interface BaseViewController : UIViewController<UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) NSString   *navigationTitle;
@property (nonatomic,strong) UIImage    *leftItemImage;
@property (nonatomic,strong) UIImage    *midItemImage;
@property (nonatomic,strong) UIImage    *rightItemImage;

@property (nonatomic,strong) UIColor    *navigationTintColor;

@property (nonatomic,strong) UIView     *navigationBarView;


- (void) createNavigationBarWithStyle:(NavigationStyle)navigationStyle
                            leftImage:(UIImage *)leftImage
                             midImage:(UIImage *)midImage
                           rightImage:(UIImage *)rightImage;


-(void)pushNextViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
