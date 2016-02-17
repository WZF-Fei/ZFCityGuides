//
//  ZFRainDropView.m
//  ZFCityGuides
//
//  Created by macOne on 16/2/15.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "ZFRainDropView.h"

@interface ZFRainDropView ()


@property (nonatomic, strong) NSMutableArray *firstRainDropIcons;

@property (nonatomic, strong) NSMutableArray *secondRainDropIcons;

@property (nonatomic, strong) UILabel *firstAvgRainDropLabel;

@property (nonatomic, strong) UILabel *secondAvgRainDropLabel;

@end

@implementation ZFRainDropView

-(instancetype)init{
    
    self = [super init];
    if (self) {
        

        
    }
    
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
    }
    
    return self;
}


-(void)initSubViews{
    
    _firstAvgRainDropLabel = [UILabel new];
    _firstAvgRainDropLabel.text = @"0";
    _firstAvgRainDropLabel.textAlignment = NSTextAlignmentCenter;
    _firstAvgRainDropLabel.font = [UIFont fontWithName:BodyFontName size:30.0];
    _firstAvgRainDropLabel.textColor = kUIColorFromRGB(0xb1e4fe);
    _firstAvgRainDropLabel.frame = CGRectMake(0, 0, 90, 30);
    [self addSubview:_firstAvgRainDropLabel];
    
    NSString *item = @"2.1";
    CGFloat toValue = 2.1;
    if ([item rangeOfString:@"."].length >0) {
        [self animatedForLabel:_firstAvgRainDropLabel forKey:@"first" fromValue:0 toValue:toValue decimal:YES];
    }
    else{
        [self animatedForLabel:_firstAvgRainDropLabel forKey:@"first" fromValue:0 toValue:toValue decimal:NO];
    }
    
    UILabel *firstMonthLabel = [UILabel new];
    firstMonthLabel.text = @"1月";
    firstMonthLabel.textAlignment = NSTextAlignmentCenter;
    firstMonthLabel.font = [UIFont fontWithName:BodyFontName size:10.0];
    firstMonthLabel.textColor = [UIColor grayColor];
    firstMonthLabel.frame = CGRectMake(0, CGRectGetMaxY(_firstAvgRainDropLabel.frame), 90, 10);
    [self addSubview:firstMonthLabel];
    
    _secondAvgRainDropLabel = [UILabel new];
    _secondAvgRainDropLabel.text = @"0";
    _secondAvgRainDropLabel.textAlignment = NSTextAlignmentCenter;
    _secondAvgRainDropLabel.font = [UIFont fontWithName:BodyFontName size:30.0];
    _secondAvgRainDropLabel.textColor = kUIColorFromRGB(0xfed1be);
    _secondAvgRainDropLabel.frame = CGRectMake(0, CGRectGetMaxY(_firstAvgRainDropLabel.frame) + 30, 90, 30);
    [self addSubview:_secondAvgRainDropLabel];
    
    toValue = 4.1;
    item = @"4.1";
    if ([item rangeOfString:@"."].length >0) {
        [self animatedForLabel:_secondAvgRainDropLabel forKey:@"second" fromValue:0 toValue:toValue decimal:YES];
    }
    else{
        [self animatedForLabel:_secondAvgRainDropLabel forKey:@"second" fromValue:0 toValue:toValue decimal:NO];
    }
    
    
    UILabel *secondMonthLabel = [UILabel new];
    secondMonthLabel.text = @"7月";
    secondMonthLabel.textAlignment = NSTextAlignmentCenter;
    secondMonthLabel.font = [UIFont fontWithName:BodyFontName size:10.0];
    secondMonthLabel.textColor = [UIColor grayColor];
    secondMonthLabel.frame = CGRectMake(0, CGRectGetMaxY(_secondAvgRainDropLabel.frame), 90, 10);
    [self addSubview:secondMonthLabel];
    

    
    //9个降雨量图标 blue
    
    for (int i = 0; i < 9; i++) {
        UIButton *rainDrop = [UIButton new];
        rainDrop.userInteractionEnabled = NO;
        UIImage * image = [UIImage imageNamed:@"statistics-raindrop-blue@2x"];
        [rainDrop setImage:image forState:UIControlStateNormal];
        rainDrop.tag = i;
        rainDrop.enabled = NO;
        rainDrop.frame = CGRectMake(25 * i + CGRectGetMaxX(_firstAvgRainDropLabel.frame), 0, 35 , 35);
        [self.firstRainDropIcons addObject:rainDrop];
        [self addSubview:rainDrop];
        
    }
    
    //9个降雨量图标 yellow
    for (int i = 0; i < 9; i++) {
        UIButton *rainDrop = [UIButton new];
        rainDrop.userInteractionEnabled = NO;
        [rainDrop setImage:[UIImage imageNamed:@"statistics-raindrop-yellow@2x"] forState:UIControlStateNormal];
        rainDrop.tag = i;
        rainDrop.enabled = NO;
        rainDrop.frame = CGRectMake(25 * i + CGRectGetMaxX(_secondAvgRainDropLabel.frame), CGRectGetMaxY(_firstAvgRainDropLabel.frame) + 30, 35 , 35);
        [self.secondRainDropIcons addObject:rainDrop];
        [self addSubview:rainDrop];
    }
    
}

-(NSMutableArray *)firstRainDropIcons{
    
    if (!_firstRainDropIcons) {
        _firstRainDropIcons = [NSMutableArray new];
    }
    
    return _firstRainDropIcons;
}

-(NSMutableArray *)secondRainDropIcons{
    
    if (!_secondRainDropIcons) {
        _secondRainDropIcons = [NSMutableArray new];
    }
    
    return _secondRainDropIcons;
}


-(void)animatedForLabel:(UILabel *)label forKey:(NSString *)key fromValue:(CGFloat)fromValue toValue:(CGFloat) toValue decimal:(BOOL)decimal{
    
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:key initializer:^(POPMutableAnimatableProperty *prop) {
        
        prop.readBlock = ^(id obj, CGFloat values[]) {
            
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *string = nil;
            if (decimal) {
                string = [NSString stringWithFormat:@"%.1f",values[0]];
            }
            else{
                string = [formatter stringFromNumber:[NSNumber numberWithInt:(int)values[0]]];
            }
            
            if ([key isEqualToString:@"first"]) {
                int number = (int)roundf(values[0]);
                for (int i = 0; i < number; i++) {
                    UIButton *button = [self.firstRainDropIcons objectAtIndex:i];
                    button.enabled = YES;
                }
            }
            else if ([key isEqualToString:@"second"]){
                int number = (int)roundf(values[0]);
                for (int i = 0; i < number; i++) {
                    UIButton *button = [self.secondRainDropIcons objectAtIndex:i];
                    button.enabled = YES;
                }
            }

            
            label.text = string;
        };
        
//            prop.threshold = 0.1;
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
