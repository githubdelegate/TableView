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
    UIImage *newImage =  [ViewController imageWithImage:[UIImage imageNamed:@"60"] scaledToSizeWithSameAspectRatio:CGSizeMake(500, 300)];
    imageView.image = [ViewController coreBlurImage:newImage withBlurNumber:10];
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

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
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
