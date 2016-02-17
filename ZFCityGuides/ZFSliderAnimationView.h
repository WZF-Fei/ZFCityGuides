//
//  ZFSliderAnimationView.h
//  ZFCityGuides
//
//  Created by macOne on 16/2/3.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFSliderStyle) {

    //一般类型 包括headTitle content footer detail
    ZFSliderStyleNormal,
    //可自定义的视图
    ZFSliderStyleView,
    //多个normal组成
    ZFSliderStyleMultiple,
    //多个customView组成
    ZFSliderStyleMultipleView,
};

typedef NS_ENUM(NSInteger, ZFSliderItemAnimation) {
    
    ZFSliderItemAnimationLeft,
    ZFSliderItemAnimationRight,
    ZFSliderItemAnimationBoth

};

typedef NS_ENUM(NSInteger, ZFScrollPosition) {
    
    ZFScrollPositionUp,
    ZFScrollPositionDown
    
};
typedef NS_OPTIONS(NSUInteger, ZFItemTypeOption) {
    ZFItemTypeOptionNone        = 0,
    ZFItemTypeOptionNoHeader    = 1 << 0,
    ZFItemTypeOptionNoFooter    = 1 << 1,
    ZFItemTypeOptionNoTip       = 1 << 2
};

@interface ZFSliderAnimationItem : NSObject

@property (nonatomic,strong) NSString *headerTitle;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *tempContent; //用于临时存放变量

@property (nonatomic,strong) NSString *footerTitle;

@property (nonatomic,strong) NSString *detailContent;

@property (nonatomic,strong) UIColor *itemBackgroundColor;

@property (nonatomic,assign) BOOL showDetail;

@property (nonatomic,assign) BOOL animated;


@end

@interface ZFSliderAnimationView : UIView


@property (nonatomic,assign) ZFItemTypeOption itemType;

@property (nonatomic,strong) UIColor *viewBackgroundColor;

@property (nonatomic,assign) NSInteger viewTag;

@property (nonatomic,assign) ZFSliderItemAnimation animation;

@property (nonatomic,strong) UIView *customView;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,assign) ZFSliderStyle style;



-(instancetype)initWithFrame:(CGRect)frame withStyle:(ZFSliderStyle)style customViews:(NSArray *)Views animationItems:(NSArray *)item;

-(void)updateAnimationView:(CGFloat)percent scrollPosition:(ZFScrollPosition)position;

@end


