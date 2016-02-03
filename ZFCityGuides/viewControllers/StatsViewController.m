//
//  StatsViewController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/15.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "StatsViewController.h"

@implementation StatsViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kContentViewBgColor;
    
    self.navigationTitle = @"Stats";
    
    [self createNavigationBarWithStyle:NavigationStyleLeftAndMid
                             leftImage:[UIImage imageNamed:@"back"]
                              midImage:[UIImage imageNamed:@"essential_selected"]
                            rightImage:nil];
//
//    UIView *contentView = [UIView new];
//    contentView.backgroundColor = kViewBgColor;
//    contentView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200);
//    [self.view addSubview:contentView];
//    
//    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
//    gradientLayer.cornerRadius = 12.5;
//    [gradientLayer setLocations:@[@0,@0.2,@0.4,@0.6,@0.8,@1]];
////    [gradientLayer2 setLocations:@[@0,@0.5,@1]];
//    gradientLayer.frame = CGRectMake(50, 100, self.view.frame.size.width/2, 25);
//    
//    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[kUIColorFromRGB(0x6699FF) CGColor],(id)[kUIColorFromRGB(0x3366FF) CGColor],(id)[kUIColorFromRGB(0x6633FF) CGColor],(id)[kUIColorFromRGB(0xCC33FF) CGColor],(id)[kUIColorFromRGB(0xFF33CC) CGColor],(id)[kUIColorFromRGB(0xFF3366) CGColor], nil]];
//    
////    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[kUIColorFromRGB(0x6699FF) CGColor],(id)[kUIColorFromRGB(0x3366FF) CGColor],(id)[kUIColorFromRGB(0x6633FF) CGColor], nil]];
//    [gradientLayer setStartPoint:CGPointMake(0, 0)];
//    [gradientLayer setEndPoint:CGPointMake(1, 0)];
//    [self.view.layer addSublayer:gradientLayer];
    
//    UILabel *people = [UILabel new];
//    people.text = @"0";
//    people.font = [UIFont fontWithName:TitleFontName size:70.0];
//    people.textColor = kTextlightGrayColor;
//    people.frame = CGRectMake(100, 100, 100, 80);
//    [contentView addSubview:people];
//    
//    
//    UILabel *area = [UILabel new];
//    area.text = @"0";
//    area.font = [UIFont fontWithName:TitleFontName size:70.0];
//    area.textColor = kTextlightGrayColor;
//    area.frame = CGRectMake(100, 200, 200, 80);
//    [contentView addSubview:area];
//    
//    [self animatedForLabel:people forKey:@"people" fromValue:0 toValue:623];
//    [self animatedForLabel:area forKey:@"area" fromValue:0 toValue:8200053];
 
    
    UIImageView *view = [UIImageView new];
    view.image = [UIImage imageNamed:@"beijing.jpg"];
    view.frame = CGRectMake(0, 300, self.view.frame.size.width, 200);
    view.backgroundColor = [UIColor redColor];
    view.layer.anchorPoint = CGPointMake(0, 0.5);
    view.layer.position = CGPointMake(0 * self.view.frame.size.width, 400);
    [self.view addSubview:view];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0/1000;
    view.layer.transform = t;
    
    CATransform3D t1= CATransform3DMakeRotation(DEGREES_TO_RADIANS(50), 0, 1, 0);
    t1 = CATransform3DRotate(t1, DEGREES_TO_RADIANS(-5), 1, 0, 0);
    view.layer.transform = CATransform3DPerspect(t1, CGPointZero, 1000);
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
//    tap.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:tap];

}


-(void)animatedForLabel:(UILabel *)label forKey:(NSString *)key fromValue:(CGFloat)fromValue toValue:(CGFloat) toValue{
    
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:key initializer:^(POPMutableAnimatableProperty *prop) {
        
        prop.readBlock = ^(id obj, CGFloat values[]) {
            
        };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            
            NSLog(@"values:%f",values[0]);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:(int)values[0]]];
            
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

-(void)dealloc{
    

    NSLog(@"dealloc");
}
@end
