//
//  StatsViewController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/15.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "StatsViewController.h"
#import "ZFSliderAnimationView.h"
#import "ZFRainDropView.h"

@interface StatsViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *subViewsArray;

@end

@implementation StatsViewController

-(void)dealloc{
    
    
    NSLog(@"dealloc");
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kContentViewBgColor;
    
    self.navigationTitle = @"Stats";
    
    [self createNavigationBarWithStyle:NavigationStyleLeftAndMid
                             leftImage:[UIImage imageNamed:@"back"]
                              midImage:[UIImage imageNamed:@"main-menu-iphone-essentials-selected@2x"]
                            rightImage:nil];

    
    [self addSubViewOnScrollView];
    


}

-(void)addSubViewOnScrollView{
    
    _subViewsArray = [NSMutableArray array];
    CGRect frame = self.view.frame;
    UIScrollView *scrollView = [UIScrollView new];
    frame.origin.y = CGRectGetMaxY(self.navigationBarView.frame) + 10;
//    frame.size.height =self.view.frame.size.height - frame.origin.y;
    scrollView.frame = frame;
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    
    CGFloat height = frame.origin.y;
    
    //==========================animationView1
    ZFSliderAnimationItem *item1 = [ZFSliderAnimationItem new];
    item1.headerTitle = @"FOUNDED";
    item1.content = @"43";
    item1.footerTitle = @"AD";
    item1.showDetail = YES;
    
    ZFSliderAnimationItem *item2 = [ZFSliderAnimationItem new];
    item2.headerTitle = @"ELEVATION";
    item2.content = @"200";
    item2.footerTitle = @"FEET";
    
    
    ZFSliderAnimationView *animationView1 = [self createAnimationView:120.0
                                                               style:ZFSliderStyleMultiple
                                                         customViews:nil
                                                      animationItems:@[item1,item2]];
    animationView1.animation = ZFSliderItemAnimationBoth;
    animationView1.frame = CGRectMake(0, 0, self.view.frame.size.width, 120);
    
    height += animationView1.frame.size.height + 10;
    
    //==========================animationView2
    ZFSliderAnimationItem *item3 = [ZFSliderAnimationItem new];
    item3.headerTitle = @"AVG TEMPERATURE ( °F )";
    
    UIView *CustomView = [self CreatGradientView];
    
    ZFSliderAnimationView *animationView2 = [self createAnimationView:90.0
                                                                style:ZFSliderStyleView
                                                          customViews:@[CustomView]
                                                       animationItems:@[item3]];
    
    animationView2.animation = ZFSliderItemAnimationLeft;
    animationView2.frame = CGRectMake(0, CGRectGetMaxY(animationView1.frame) + 10, self.view.frame.size.width, 90);
    height += animationView2.frame.size.height + 10;
    
    //=========================animationView3
    ZFSliderAnimationItem *item4 = [ZFSliderAnimationItem new];
    item4.headerTitle = @"AVG. PRECIPITATION ( in )";

    
    ZFRainDropView *rainDropView = [[ZFRainDropView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    ZFSliderAnimationView *animationView3 = [self createAnimationView:150.0
                                                                style:ZFSliderStyleView
                                                          customViews:@[rainDropView]
                                                       animationItems:@[item4]];
    
    animationView3.animation = ZFSliderItemAnimationRight;
    animationView3.frame = CGRectMake(0, CGRectGetMaxY(animationView2.frame) + 10, self.view.frame.size.width, 150);
    height += animationView3.frame.size.height + 10;
    
    //=========================animationView4
    ZFSliderAnimationItem *item5 = [ZFSliderAnimationItem new];
    item5.headerTitle = @"AREA";
    item5.content = @"659";
    item5.footerTitle = @"SQ MI";
    
    ZFSliderAnimationItem *item6 = [ZFSliderAnimationItem new];
    item6.headerTitle = @"CITY POP.";
    item6.content = @"7927008";
    item6.showDetail = YES;
    
    
    ZFSliderAnimationView *animationView4 = [self createAnimationView:120.0
                                                                style:ZFSliderStyleMultiple
                                                          customViews:nil
                                                       animationItems:@[item5,item6]];
    animationView4.animation = ZFSliderItemAnimationBoth;
    animationView4.frame = CGRectMake(0, CGRectGetMaxY(animationView3.frame) + 10, self.view.frame.size.width, 120);
    height += animationView4.frame.size.height + 10;
    
    //=========================animationView5
    ZFSliderAnimationItem *item7 = [ZFSliderAnimationItem new];
    item7.headerTitle = @"GROWTH RATE";
    item7.content = @"0.14";
    item7.footerTitle = @"%";
    
    ZFSliderAnimationItem *item8 = [ZFSliderAnimationItem new];
    item8.headerTitle = @"POP.DENSITY";
    item8.content = @"12036";
    item8.footerTitle = @"PER SQ MILE";
    item8.showDetail = YES;
    
    
    ZFSliderAnimationView *animationView5 = [self createAnimationView:120.0
                                                                style:ZFSliderStyleMultiple
                                                          customViews:nil
                                                       animationItems:@[item7,item8]];
    animationView5.animation = ZFSliderItemAnimationBoth;
    animationView5.frame = CGRectMake(0, CGRectGetMaxY(animationView4.frame) + 10, self.view.frame.size.width, 120);
    height += animationView5.frame.size.height +10;
    
    //=========================animationView6
    ZFSliderAnimationItem *item9 = [ZFSliderAnimationItem new];
    item9.headerTitle = @"TOTAL COUNTRY POP.";
    item9.content = @"63395580";
    
    ZFSliderAnimationView *animationView6 = [self createAnimationView:120.0
                                                                style:ZFSliderStyleNormal
                                                          customViews:nil
                                                       animationItems:@[item9]];
    animationView6.animation = ZFSliderItemAnimationLeft;
    animationView6.frame = CGRectMake(0, CGRectGetMaxY(animationView5.frame) + 10, self.view.frame.size.width, 120);
    height += animationView6.frame.size.height + 10;
    
    //=========================animationView7
    ZFSliderAnimationItem *item10 = [ZFSliderAnimationItem new];
    item10.headerTitle = @"CITY POP.AS A % OF TOTAL COUNTRY";
    
    ZFRainDropView *rainDropView2 = [[ZFRainDropView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//    UIView *CustomView2 = [UIView new];
//    CustomView2.backgroundColor = [UIColor orangeColor];
//    CustomView2.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    ZFSliderAnimationView *animationView7 = [self createAnimationView:150.0
                                                                style:ZFSliderStyleView
                                                          customViews:@[rainDropView2]
                                                       animationItems:@[item10]];
    animationView7.viewTag = 7;
    animationView7.animation = ZFSliderItemAnimationRight;
    animationView7.frame = CGRectMake(0, CGRectGetMaxY(animationView6.frame) + 10, self.view.frame.size.width, 150);
    height += animationView7.frame.size.height + 10;
    
    [scrollView addSubview:animationView1];
    [scrollView addSubview:animationView2];
    [scrollView addSubview:animationView3];
    [scrollView addSubview:animationView4];
    [scrollView addSubview:animationView5];
    [scrollView addSubview:animationView6];
    [scrollView addSubview:animationView7];
    [_subViewsArray addObject:animationView1];
    [_subViewsArray addObject:animationView2];
    [_subViewsArray addObject:animationView3];
    [_subViewsArray addObject:animationView4];
    [_subViewsArray addObject:animationView5];
    [_subViewsArray addObject:animationView6];
    [_subViewsArray addObject:animationView7];
    

    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, height)];
    
}

-(ZFSliderAnimationView *)createAnimationView:(CGFloat)height style:(ZFSliderStyle)style customViews:(NSArray *)views animationItems:(NSArray *)items{
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    ZFSliderAnimationView *animationView = [[ZFSliderAnimationView alloc] initWithFrame:frame//CGRectMake(0, 130* i, self.view.frame.size.width, 120)
                                                                              withStyle:style
                                                                            customViews:views
                                                                         animationItems:items];
    
    return animationView;

}

-(UIView *)CreatGradientView{
    
    
    UIView *gradientView = [UIView new];
    gradientView.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 25);

    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.cornerRadius = 12.5;
    [gradientLayer setLocations:@[@0,@0.2,@0.4,@0.6,@0.8,@1]];
    gradientLayer.frame = CGRectMake(0, 0, gradientView.frame.size.width, gradientView.frame.size.height);

    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[kUIColorFromRGB(0x6699FF) CGColor],(id)[kUIColorFromRGB(0x3366FF) CGColor],(id)[kUIColorFromRGB(0x6633FF) CGColor],(id)[kUIColorFromRGB(0xCC33FF) CGColor],(id)[kUIColorFromRGB(0xFF33CC) CGColor],(id)[kUIColorFromRGB(0xFF3366) CGColor], nil]];

    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    [gradientView.layer addSublayer:gradientLayer];

    return gradientView;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    for (UIView *subView in _subViewsArray) {
        
        BOOL bContainedTopView = CGRectContainsPoint(subView.frame,scrollView.contentOffset);
        CGPoint point = scrollView.contentOffset;
        point.y += (self.view.frame.size.height - CGRectGetMaxY(self.navigationBarView.frame) -10);
        
//        NSLog(@"point:%@",NSStringFromCGPoint(point));
//        NSLog(@"subview.frame:%@",NSStringFromCGRect(subView.frame));
//        NSLog(@"superview.subview.frame:%@",NSStringFromCGRect([subView convertRect:subView.frame toView:self.view]));
        
        BOOL bContainedBottomView = CGRectContainsPoint(subView.frame,point);

        
        ZFSliderAnimationView *sliderView = (ZFSliderAnimationView *)subView;
        
        UIView *middleView = nil;
        
        //自定义的view
        if (sliderView.style == ZFSliderStyleView || sliderView.style == ZFSliderStyleMultipleView) {
            middleView = sliderView.customView;
        }
        else{
            
            middleView = sliderView.contentLabel;
        }

        if (bContainedTopView) {
            
            CGFloat percent = (scrollView.contentOffset.y - subView.frame.origin.y - middleView.frame.origin.y) /middleView.frame.size.height;

            if (percent <0) {
                percent = 0;
            }
            [sliderView updateAnimationView:percent];

            
        }
        else if (bContainedBottomView){

            CGFloat percent = (point.y - subView.frame.origin.y - middleView.frame.origin.y) /middleView.frame.size.height;

            if (percent >1) {
                percent =1;
            }
            [sliderView updateAnimationView:1- percent];
//             NSLog(@"percent:%f,tag:%d",percent,sliderView.viewTag);
        }
        else{
            [sliderView updateAnimationView:0.0];
        }
       
    }
}



@end
