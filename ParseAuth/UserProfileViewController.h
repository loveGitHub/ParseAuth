//
//  UserProfileViewController.h
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface UserProfileViewController : UIViewController
{
    IBOutlet UIImageView *imgLogo;
    IBOutlet AsyncImageView *imgProfile;
    IBOutlet UITextField *txtFullName;
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtCountry;
    IBOutlet UITextField *txtGender;
    IBOutlet UITextField *txtEmail;
}

-(IBAction)btn_backClicked:(id)sender;

@end
