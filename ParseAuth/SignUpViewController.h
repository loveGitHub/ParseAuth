//
//  SignUpViewController.h
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InstagramAuthDelegate <NSObject>

- (void)instagramAuthLoadFailed:(NSError *)error;

- (void)instagramAuthSucceeded:(NSString *)token;

- (void)instagramAuthFailed:(NSString *)error
                errorReason:(NSString *)errorReason
           errorDescription:(NSString *)errorMessage;
@end


@interface SignUpViewController : UIViewController <InstagramAuthDelegate>
{
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnSignup;
    
}

-(IBAction)btn_SignupClicked:(id)sender;
-(IBAction)btn_BackClicked:(id)sender;


@end
