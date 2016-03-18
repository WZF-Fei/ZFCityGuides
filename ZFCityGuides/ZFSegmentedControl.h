//
//  ZFSegmentedControl.h
//  ZFCityGuides
//
//  Created by macOne on 16/3/18.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFSegmentedControl : UIView

@property (nonatomic,strong) UIColor *tintColor;

-(instancetype)initWithItems:(NSArray *)items;

//-(void)setImage:(UIImage *)image forSegmentAtIndex:(NSInteger)index;

- (void)setTitleTextAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state;

@end
