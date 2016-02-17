//
//  ZFSliderAnimationView.m
//  ZFCityGuides
//
//  Created by macOne on 16/2/3.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "ZFSliderAnimationView.h"


static const CGFloat gapWidth = 10.0f;

@implementation ZFSliderAnimationItem

-(UIColor *)itemBackgroundColor{
    if (!_itemBackgroundColor) {
        _itemBackgroundColor = kSmallViewBgColor;
    }
    
    return _itemBackgroundColor;
}

-(void)setContent:(NSString *)content{
    _content = content;
    _tempContent = content;
}
@end


@interface ZFSliderAnimationView ()

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, strong) NSArray *items;
//自定义的views
@property (nonatomic, strong) NSArray *customViews;

@property (nonatomic, copy) UIView *itemView;

@property (nonatomic, copy) NSMutableArray *subItemViews;

@property (nonatomic, strong) NSString *animationKey;

@end

@implementation ZFSliderAnimationView


-(instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self initSubViewsWithStyle:ZFSliderStyleNormal];
    }
    
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame withStyle:(ZFSliderStyle)style customViews:(NSArray *)Views animationItems:(NSArray *)items{
 
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.customViews = Views;
        self.items = items;
        self.style = style;
        [self initSubViewsWithStyle:style];
    }
    
    return self;
}

-(void)initSubViewsWithStyle:(ZFSliderStyle)style{
    
    switch (style) {
            
        case ZFSliderStyleNormal:
            if (self.items) {
                [self addItemViewOnContentView:self.items[0] withCustomView:nil];
            }
    
        break;
        case ZFSliderStyleView:
            if (self.customViews && self.items) {
                UIView *customView = [UIView new];
                if (self.customViews.count > 0) {
                    customView = self.customViews[0];
                }
                
                [self addItemViewOnContentView:self.items[0] withCustomView:customView];
            }
            
            break;
        case ZFSliderStyleMultiple:
        {
            NSMutableArray *itemWidthArray = [self countWidthForItems:self.items];
            
            CGFloat orignX = 0;
            for (int i =0 ; i < self.items.count; i++) {
                
                orignX += i ?  [itemWidthArray[i -1] floatValue] + gapWidth : gapWidth;
                [self addItemOnContentViewAtIndex:i animationItem:self.items[i] orignX:orignX withItemWidth:[itemWidthArray[i] floatValue]];
                
            }
        }
        break;
        default:
            break;
    }
    
}

#pragma mark - 添加项目到视图

-(void)addItemViewOnContentView:(ZFSliderAnimationItem *)item withCustomView:(UIView *)customView{
    
    
//    NSLog(@"custom:%@",customView);
    UIView *contenView = [UIView new];
    contenView.layer.cornerRadius = 5;
    contenView.layer.borderWidth = 0.5;
    contenView.backgroundColor = item.itemBackgroundColor;
    contenView.frame = CGRectMake(gapWidth, 0, self.frame.size.width - gapWidth *2, self.frame.size.height);
    [self addSubview:contenView];
    
    UIButton *header = [UIButton new];
    header.frame = CGRectMake(0, 10, contenView.frame.size.width, 10);
    [header setTitle:item.headerTitle forState:UIControlStateNormal];
    [header setTitleColor:kTextlightGrayColor forState:UIControlStateNormal];
    header.titleLabel.font = [UIFont fontWithName:BodyFontName size:11.0f];
    [contenView addSubview:header];
    
    _animationKey = item.headerTitle;
    CGFloat footerOrignY = 0.0f;
    if (customView) {
        _customView = customView;
        _customView.frame = CGRectMake((self.frame.size.width - _customView.frame.size.width)/2, CGRectGetMaxY(header.frame) + 20, contenView.frame.size.width, _customView.frame.size.height);
        [contenView addSubview:_customView];
        footerOrignY = CGRectGetMaxY(_customView.frame) +10;
    }
    else{
        
        _contentLabel = [UILabel new];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.frame = CGRectMake(0, CGRectGetMaxY(header.frame) + 15, contenView.frame.size.width, 60);
        _contentLabel.font = [UIFont fontWithName:TitleFontName size:65.0];
        _contentLabel.textColor = kTextlightGrayColor;
        _contentLabel.text = @"0";
        [contenView addSubview:_contentLabel];
        footerOrignY = CGRectGetMaxY(_contentLabel.frame);
        
        CGFloat toValue = [item.content floatValue];

        if ([item.content rangeOfString:@"."].length >1) {
            [self animatedForLabel:_contentLabel forKey:_animationKey fromValue:0 toValue:toValue decimal:YES];
        }
        else{
            [self animatedForLabel:_contentLabel forKey:_animationKey fromValue:0 toValue:toValue decimal:NO];
        }
    }

    UILabel *footerLabel = [UILabel new];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.frame = CGRectMake(0, footerOrignY, contenView.frame.size.width, 30);
    footerLabel.font = [UIFont fontWithName:BodyFontName size:11.0];
    footerLabel.textColor = kTextlightGrayColor;
    footerLabel.text = item.footerTitle;
    [contenView addSubview:footerLabel];
    
    if (item.showDetail) {
        
        UIButton *detailBtn = [UIButton new];
        detailBtn.layer.cornerRadius = 25/2.0;
        detailBtn.layer.borderWidth = 0.2;
        detailBtn.backgroundColor = kUIColorFromRGB(0x2b3034);
        detailBtn.frame = CGRectMake(contenView.frame.size.width - 40, contenView.frame.size.height - 30, 25, 25);
        [detailBtn setTitle:@"i" forState:UIControlStateNormal];
        [detailBtn setTitleColor:kTextlightGrayColor forState:UIControlStateNormal];
        detailBtn.titleLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0f];
        [contenView addSubview:detailBtn];
    }

    
    
}

-(void)addItemOnContentViewAtIndex:(NSInteger)index animationItem:(ZFSliderAnimationItem *)item orignX:(CGFloat)orignX withItemWidth:(CGFloat)itemWidth{
    
    
    UIView *contenView = [UIView new];
    contenView.layer.cornerRadius = 5;
    contenView.layer.borderWidth = 0.5;
    contenView.backgroundColor = item.itemBackgroundColor;
    contenView.frame = CGRectMake(orignX, 0, itemWidth, self.frame.size.height);
    [self addSubview:contenView];
    
    UIButton *header = [UIButton new];
    header.frame = CGRectMake(0, 10, contenView.frame.size.width, 10);
    [header setTitle:item.headerTitle forState:UIControlStateNormal];
    [header setTitleColor:kTextlightGrayColor forState:UIControlStateNormal];
    header.titleLabel.font = [UIFont fontWithName:BodyFontName size:11.0f];
    [contenView addSubview:header];
    
    _contentLabel = [UILabel new];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.frame = CGRectMake(0, CGRectGetMaxY(header.frame) + 15, contenView.frame.size.width, 60);
    _contentLabel.font = [UIFont fontWithName:TitleFontName size:65.0];
    _contentLabel.textColor = kTextlightGrayColor;
    _contentLabel.text = @"0";
    _contentLabel.tag = index;
    [contenView addSubview:_contentLabel];
    
    //关键key
    _animationKey = item.headerTitle;
    CGFloat toValue = [item.content floatValue];
    if ([item.content rangeOfString:@"."].length >0) {
        [self animatedForLabel:_contentLabel forKey:_animationKey fromValue:0 toValue:toValue decimal:YES];
    }
    else{
        [self animatedForLabel:_contentLabel forKey:_animationKey fromValue:0 toValue:toValue decimal:NO];
    }
    
    //为什么要用button 而不是label ,方法取subview时，区分开contenlabel
    UIButton *footerLabel = [UIButton new];
    footerLabel.frame = CGRectMake(0,CGRectGetMaxY(_contentLabel.frame) , contenView.frame.size.width, 30);
    [footerLabel setTitle:item.footerTitle forState:UIControlStateNormal];
    [footerLabel setTitleColor:kTextlightGrayColor forState:UIControlStateNormal];
    footerLabel.titleLabel.font = [UIFont fontWithName:BodyFontName size:11.0f];
    [contenView addSubview:footerLabel];
    
    if (item.showDetail) {
        UIButton *detailBtn = [UIButton new];
        detailBtn.layer.cornerRadius = 25/2.0;
        detailBtn.layer.borderWidth = 0.2;
        detailBtn.backgroundColor = kUIColorFromRGB(0x2b3034);
        detailBtn.frame = CGRectMake(contenView.frame.size.width - 40, contenView.frame.size.height - 30, 25, 25);
        [detailBtn setTitle:@"i" forState:UIControlStateNormal];
        [detailBtn setTitleColor:kTextlightGrayColor forState:UIControlStateNormal];
        detailBtn.titleLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:14.0f];
        [contenView addSubview:detailBtn];
    }

    [self.subItemViews addObject:contenView];
}

#pragma mark -计算items宽度
-(NSMutableArray *)countWidthForItems:(NSArray *)items{
    
//    NSInteger fontSize = 55.0f;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (ZFSliderAnimationItem *item in items) {

        CGSize contentSize = [item.content sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:TitleFontName size:60.0]}];

        CGSize titleSize = [item.headerTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:BodyFontName size:11.0f]}];


        CGFloat itemWidth = contentSize.width > titleSize.width ? contentSize.width : titleSize.width;

        
        CGFloat avgWitdth = (self.frame.size.width - (items.count +1) * gapWidth) /items.count ;
        itemWidth = (itemWidth + gapWidth * 2) > avgWitdth ? (itemWidth + gapWidth * 2) : avgWitdth;
        
        CGFloat totalWidth = gapWidth;
        for (int i =0; i < array.count; i++) {
            totalWidth += ([array[i] floatValue] + gapWidth);
        }
        if ((totalWidth + itemWidth + gapWidth) >= self.frame.size.width) {
            itemWidth = self.frame.size.width - totalWidth -gapWidth;
        }
        //前后有10像素距离
        [array addObject:@(itemWidth)];
    }
    
    return array;
    
}

-(void)updateAnimationView:(CGFloat)percent scrollPosition:(ZFScrollPosition)position{

    if (self.animation == ZFSliderItemAnimationLeft) {

        [self showItemAnimationAtPosition:position percent:percent];
        
        if (percent < 0) {
            percent = 0;
        }
        if (percent >1) {
            percent =1;
        }
        
        UIView *contentView = self.subviews[0];
        CGRect frame = contentView.frame;
        //向左移动
        frame.origin.x = (gapWidth - contentView.frame.size.width * percent);
        contentView.frame = frame;
    }
    else if (self.animation == ZFSliderItemAnimationRight){
        
        [self showItemAnimationAtPosition:position percent:percent];
        
        if (percent < 0) {
            percent = 0;
        }
        if (percent >1) {
            percent =1;
        }
        
        UIView *contentView = self.subviews[0];
        CGRect frame = contentView.frame;
        //向左移动
        frame.origin.x = (gapWidth + contentView.frame.size.width * percent);
        contentView.frame = frame;
    }
    else if (self.animation == ZFSliderItemAnimationBoth){


        [self showItemAnimationAtPosition:position percent:percent];
        NSAssert(self.items.count > 1, @"Count can't less than two");
        
        //此处只演示2个items
        
        if (percent < 0) {
            percent = 0;
        }
        if (percent >1) {
            percent =1;
        }

        CGRect leftFrame = self.subviews[0].frame;
        CGRect rightFrame = self.subviews[1].frame;
        //左侧item 向左移动
        leftFrame.origin.x = (gapWidth - self.subviews[0].frame.size.width * percent);
        self.subviews[0].frame = leftFrame;
        //右侧item 向右移动
        rightFrame.origin.x = (self.subviews[0].frame.size.width  + gapWidth *2 + self.subviews[1].frame.size.width * percent);
        self.subviews[1].frame = rightFrame;
    }
    //改变透明度
    self.alpha = 1 - percent *1.5;
}


-(void)showItemAnimationAtPosition:(ZFScrollPosition)position percent:(CGFloat)percent{
    
    if (percent > 0 && percent < 1 && position == ZFScrollPositionUp) {
        
        for (int i = 0; i < self.subItemViews.count; i++) {
            
            NSArray *subViews = ((UIView *)self.subItemViews[i]).subviews;
            
            for (UIView *subView in subViews) {
                
                if ([subView isKindOfClass:[UILabel class]]) {
                    
                    //无法用key 区分，根据子视图上的UILabel实现
                    ZFSliderAnimationItem *item = self.items[i];
                    if (item.animated) {
                        continue;
                    }

                    if ([item.content rangeOfString:@"."].length >1) {
                        [self animatedForLabel:(UILabel *)subView forKey:self.animationKey fromValue:[item.content floatValue]  toValue:0 decimal:YES];
                    }
                    else{
                        [self animatedForLabel:(UILabel *)subView forKey:self.animationKey fromValue:[item.content floatValue]  toValue:0 decimal:NO];
                    }
                    
                    item.tempContent = @"0";
                    item.animated = YES;
                    
                }
            }
        }
        
    }
    else if(percent < 0){
        

//        NSLog(@"percent:%f",percent);
        for (int i = 0; i < self.subItemViews.count; i++) {
            
            NSArray *subViews = ((UIView *)self.subItemViews[i]).subviews;
            
            for (UIView *subView in subViews) {
                
                if ([subView isKindOfClass:[UILabel class]]) {
                    
                    UILabel *contentLabel = (UILabel *)subView;
                    //无法用key 区分，根据子视图上的UILabel实现
                    ZFSliderAnimationItem *item = self.items[i];


                    if (position == ZFScrollPositionUp || (position == ZFScrollPositionDown && [item.tempContent isEqualToString:@"0"])) {
                        item.animated = NO;
                    }

                    if (item.animated) {

                        continue;
                    }

                    if (percent != 0.0 && [item.tempContent isEqualToString:@"0"]) {
                        if ([item.content rangeOfString:@"."].length >1) {
                            [self animatedForLabel:contentLabel forKey:self.animationKey fromValue:0 toValue:[item.content floatValue] decimal:YES];
                        }
                        else{
                            [self animatedForLabel:contentLabel forKey:self.animationKey fromValue:0 toValue:[item.content floatValue] decimal:NO];
                        }
                        item.animated = YES;
                        item.tempContent = item.content;

                    }
                    
                }
            }
        }
        
        
    }
    else if(percent == 0){
        
        for (int i = 0; i < self.subItemViews.count; i++) {
            
            NSArray *subViews = ((UIView *)self.subItemViews[i]).subviews;
            
            for (UIView *subView in subViews) {
                
                if ([subView isKindOfClass:[UILabel class]]) {
                    
                    //无法用key 区分，根据子视图上的UILabel实现
                    ZFSliderAnimationItem *item = self.items[i];

                    if ([item.content rangeOfString:@"."].length >1) {
                        [self animatedForLabel:(UILabel *)subView forKey:self.animationKey fromValue:0  toValue:[item.content floatValue] decimal:YES];
                    }
                    else{
                        [self animatedForLabel:(UILabel *)subView forKey:self.animationKey fromValue:0  toValue:[item.content floatValue] decimal:NO];
                    }
             
                }
            }
        }

    }

    
}
#pragma mark - setter and getter

-(NSMutableArray *)subItemViews{
    
    if (!_subItemViews) {
        _subItemViews = [NSMutableArray new];
    }
    
    return _subItemViews;
}

-(NSArray *)items{
    
    if (!_items) {
        _items = [NSArray new];
    }
    
    return _items;
}

-(NSArray *)customViews{
    
    if (!_customViews) {
        _customViews = [NSArray new];
    }
    
    return _customViews;
}
-(void)setViewBackgroundColor:(UIColor *)viewBackgroundColor{
    
    _viewBackgroundColor = viewBackgroundColor;
    self.backgroundColor = viewBackgroundColor;
}

#pragma mark -animation

-(void)animatedForLabel:(UILabel *)label forKey:(NSString *)key fromValue:(CGFloat)fromValue toValue:(CGFloat) toValue decimal:(BOOL)decimal{
    
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:key initializer:^(POPMutableAnimatableProperty *prop) {
        
        prop.readBlock = ^(id obj, CGFloat values[]) {
            
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *string = nil;
            if (decimal) {
                string = [formatter stringFromNumber:[NSNumber numberWithFloat:values[0]]];
            }
            else{
                string = [formatter stringFromNumber:[NSNumber numberWithInt:(int)values[0]]];
            }
            
            if (fromValue > toValue) {
                label.alpha = 0.5;
            }
            else{
                label.alpha = 1.0;
            }
            label.text = string;
        };
        
        //        prop.threshold = 1;
    }];
    
    POPBasicAnimation *anBasic = [POPBasicAnimation easeInEaseOutAnimation];   //动画属性
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(fromValue);   //从0开始
    anBasic.toValue = @(toValue);  //
    anBasic.duration = 1;    //持续时间
    anBasic.beginTime = CACurrentMediaTime() + 1.0f;    //延迟1秒开始
    [label pop_addAnimation:anBasic forKey:key];
}

@end


