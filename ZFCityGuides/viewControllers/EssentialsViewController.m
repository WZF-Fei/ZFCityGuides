//
//  EssentialsViewController.m
//  ZFCityGuides
//
//  Created by macOne on 16/1/28.
//  Copyright © 2016年 WZF. All rights reserved.
//

#import "EssentialsViewController.h"
#import "StatsViewController.h"
#import "ZFNavInteractiveTransition.h"

@interface EssentialsViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property (assign, nonatomic) CGFloat cellHeight;

@property (copy, nonatomic) NSArray *dataArray;

@end

@implementation EssentialsViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kContentViewBgColor;
    
    self.navigationTitle = @"Essentials";
    
    [self createNavigationBarWithStyle:NavigationStyleLeftAndMid
                             leftImage:nil
                              midImage:[UIImage imageNamed:@"essential_selected"]
                            rightImage:nil];
    
    [self initViews];
    
}

-(void)initViews{
    
    CGFloat width = (self.view.bounds.size.width - 3 *10) / 2;
    
    UIView *smallLeftView = [UIView new];
    smallLeftView.layer.cornerRadius = 5;
    smallLeftView.layer.borderWidth = 0.5;
    smallLeftView.backgroundColor = kSmallViewBgColor;
    smallLeftView.frame = CGRectMake(10, CGRectGetMaxY(self.navigationBarView.frame), width, 200);
    smallLeftView.userInteractionEnabled = YES;
    [self.view addSubview:smallLeftView];
    
    UITapGestureRecognizer *tapLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionLeftView:)];
    [smallLeftView addGestureRecognizer:tapLeftGesture];
    
    UIImageView *leftImageView = [UIImageView new];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"essential" ofType:@"jpg"];
    UIImage *image =[UIImage imageWithContentsOfFile:strPath];
    leftImageView.image = image;
    leftImageView.frame = CGRectMake(0, 40, width, 90);
    [smallLeftView addSubview:leftImageView];

    
    
    UIButton *leftBtn = [UIButton new];
    leftBtn.layer.cornerRadius = 5;
    leftBtn.layer.masksToBounds = YES;
    [leftBtn setTitle:@"STATISTICS" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont fontWithName:BodyFontName size:12.0] ;
    leftBtn.backgroundColor = [UIColor blackColor];
    leftBtn.frame = CGRectMake(10, CGRectGetMaxY(leftImageView.frame) + 20, CGRectGetWidth(smallLeftView.frame) - 10*2, 40);
    leftBtn.userInteractionEnabled = NO;
    [smallLeftView addSubview:leftBtn];
    
    
    UIView *smallRightView = [UIView new];
    smallRightView.layer.cornerRadius = 5;
    smallRightView.layer.borderWidth = 0.5;
    smallRightView.backgroundColor = kSmallViewBgColor;
    smallRightView.frame = CGRectMake(CGRectGetMaxX(smallLeftView.frame) + 10, CGRectGetMaxY(self.navigationBarView.frame), width, 200);
    [self.view addSubview:smallRightView];
    
    UITapGestureRecognizer *tapRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionRightView:)];
    
    [smallRightView addGestureRecognizer:tapRightGesture];
    
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.frame = CGRectMake(0, 40, width, 90);
    rightLabel.text = @"1=0.107";
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = [UIFont fontWithName:TitleFontName size:70.0];
    rightLabel.textColor = kTextlightGrayColor;
    [smallRightView addSubview:rightLabel];
    
    
    UIButton *RightBtn = [UIButton new];
    RightBtn.layer.cornerRadius = 5;
    RightBtn.layer.masksToBounds = YES;
    [RightBtn setTitle:@"CONVERSIONS" forState:UIControlStateNormal];
    [RightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RightBtn.titleLabel.font = [UIFont fontWithName:BodyFontName size:12.0] ;
    RightBtn.backgroundColor = [UIColor blackColor];
    RightBtn.userInteractionEnabled = NO;
    RightBtn.frame = CGRectMake(10, CGRectGetMaxY(rightLabel.frame) + 20, CGRectGetWidth(smallRightView.frame) - 10*2, 40);
    [smallRightView addSubview:RightBtn];
    
    UITableView *tableView = [UITableView new];
    tableView.backgroundColor = kTableViewCellBgColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.frame = CGRectMake(0, CGRectGetMaxY(smallRightView.frame) + 10 , self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(smallRightView.frame) -10);
    [self.view addSubview:tableView];
    
    _cellHeight = CGRectGetHeight(tableView.frame) /3.0;
    
}

-(NSArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    
    _dataArray = @[@"Travel Info",@"News",@"About"];
    
    return _dataArray;
}

#pragma mark -UIView 点击事件

-(void)ActionLeftView:(UITapGestureRecognizer *)recognizer{

    
    StatsViewController *statsVC = [StatsViewController new];

//    //自定义交互手势
//    MainNavigationController *navigation = (MainNavigationController *)self.navigationController;
//    navigation.interactionViewController = [ZFNavInteractiveTransition new];
    
    [self.navigationController pushViewController:statsVC animated:YES];
    
    
}
-(void)ActionRightView:(UITapGestureRecognizer *)recognizer{
    
     NSLog(@"RightView");
}


#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
}


#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"essentialCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.textColor = kSmallViewBgColor;
    cell.textLabel.font = [UIFont fontWithName:BodyFontName size:20.0];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}



@end
