//
//  CommonHelper.m
//  tiantiansanguoba
//
//  Created by yaowan on 13-11-3.
//  Copyright (c) 2013年 bobo. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper
+ (void)showTipWithTitle:(NSString *)title msg:(NSString *)msg{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

+ (UIActivityIndicatorView *)createdIndicatorAddToSubViewCenterBySubView:(UIView *)subView{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect screenFrame = [ UIScreen mainScreen ].applicationFrame;
    indicator.frame = CGRectMake(screenFrame.size.width / 2 - indicator.frame.size.width / 2 ,
                                  screenFrame.size.height / 2 - indicator.frame.size.height / 2,
                                  indicator.frame.size.width / 2,
                                  indicator.frame.size.height / 2);
    [subView addSubview:indicator];
    return indicator;
}
@end
