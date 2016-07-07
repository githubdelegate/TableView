//
//  View.m
//  test
//
//  Created by zhangyun on 16/7/6.
//  Copyright © 2016年 USC. All rights reserved.
//

#import "View.h"


#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface View()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView  *imageView;
@property (nonatomic,strong) UIView  *centerView;
@property (nonatomic,strong) UITableView  *tableView;
@end

@implementation View


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        _imageView.image = [UIImage imageNamed:@"60"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor redColor];
    }
    return _centerView;
}

- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView.frame = CGRectMake(0, 0, W, 100);
        [self addSubview:self.imageView];
        
        self.centerView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), W, 100);
        [self addSubview:self.centerView];
        
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.centerView.frame), W, 300);
        [self addSubview:self.tableView];
        
        self.contentSize = CGSizeMake(0, H+500);
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = NO;
    }
    return self;
}

- (void)update{
    CGFloat height = self.imageView.bounds.size.height;
    CGFloat h = 100;
    
//    var headerRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: HeaderHeight)
    if (self.contentOffset.y < 0) {
        CGRect newRect = CGRectMake(0, self.contentOffset.y, W, h - self.contentOffset.y);
        self.imageView.frame = newRect;
        NSLog(@" imagev frame = %@",NSStringFromCGRect(self.imageView.frame));
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
        cell.textLabel.text = @"1212";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22;
}
@end
