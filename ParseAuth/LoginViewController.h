//
//  LoginViewController.h
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

@interface LoginViewController : UIViewController <InstagramAuthDelegate>
{
    IBOutlet UITextField *edtEmail;
    IBOutlet UITextField *edtPassword;
}

-(IBAction)btn_loginClicked:(id)sender;
-(IBAction)btn_backClicked:(id)sender;

- (IBAction)actionFacebook:(id)sender;

- (IBAction)actionTwitter:(id)sender;

- (IBAction)actionInstagram:(id)sender;



@end
