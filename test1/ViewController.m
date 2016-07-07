//
//  ViewController.m
//  test1
//
//  Created by zhangyun on 16/7/6.
//  Copyright © 2016年 USC. All rights reserved.
//

#import "ViewController.h"
#import "View.h"

const CGFloat NYTopViewH = 244;

@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) View  *v;
@property (nonatomic,strong) UITableView  *tb;
@property (nonatomic,strong) UIImageView  *imageView;
@property (nonatomic,strong) UIToolbar  *toolbar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor clearColor];
//    View *v = [[View alloc] initWithFrame:self.view.bounds];
//    v.delegate = self;
//    self.v = v;
//    [self.view addSubview:v];
    
    self.tb = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tb.contentInset = UIEdgeInsetsMake(36, 0, 0, 0);
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tb];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -36, W, NYTopViewH)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.image = [UIImage imageNamed:@"60"];
    imageView.image = [ViewController coreBlurImage:[UIImage imageNamed:@"60"] withBlurNumber:10];
//    self.tb.tableHeaderView = imageView;
    [self.tb insertSubview:imageView atIndex:0];
    self.imageView = imageView;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    image.center = CGPointMake(W/2,image.center.y);
    image.image = [UIImage imageNamed:@"60"];
//    image.backgroundColor = [UIColor redColor];
    image.contentMode = UIViewContentModeScaleAspectFit;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 208)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:image];
    self.tb.tableHeaderView = view;
    
    
//    image.backgroundColor = [UIColor purpleColor];
//    self.tb.tableHeaderView = image;
}

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.v update];
    // 向下拽了多少距离
    NSLog(@" scrollview offset frame = %@",NSStringFromCGPoint(self.tb.contentOffset));
    if (self.tb.contentOffset.y > -36) {
        return;
    }
    
    CGRect rect = self.imageView.frame;
    rect.size.height = 208-self.tb.contentOffset.y;
    rect.origin.y = self.tb.contentOffset.y;
    self.imageView.frame = rect;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
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
    return 50;
}

@end
