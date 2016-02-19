//
//  ZFRainDropView.h
//  ZFCityGuides
//
//  Created by macOne on 16/2/15.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFRainDropView : UIView

@property (nonatomic,strong) NSString *pastMonthRainDrop;

@property (nonatomic,strong) NSString *nearstMonthRainDrop;

@property (nonatomic,assign) BOOL digitAnimated;

-(instancetype)initWithFrame:(CGRect)frame;

-(void)increaseNumber:(BOOL)bIncreased animated:(BOOL)animated;

@end
