//
//  View.h
//  test
//
//  Created by zhangyun on 16/7/6.
//  Copyright © 2016年 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface View : UIScrollView
- (void)update;
@end
