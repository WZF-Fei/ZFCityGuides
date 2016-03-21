//
//  ZFSegmentedControl.h
//  ZFCityGuides
//
//  Created by macOne on 16/3/18.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZFSegmentedControlDelegate <NSObject>

- (void)clickSegmentedControlAtIndex:(NSInteger)index;

@end


@interface ZFSegmentedControl : UIView

@property (nonatomic,strong) UIColor *tintColor;

@property (nonatomic,weak) id <ZFSegmentedControlDelegate> delegate;



-(instancetype)initWithItems:(NSArray *)items;

-(void)setNormalImage:(UIImage *)image forSegmentAtIndex:(NSInteger)index;

-(void)setSelectedImage:(UIImage *)image forSegmentAtIndex:(NSInteger)index;

-(void)setTitleTextAttributes:(NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state;

@end
