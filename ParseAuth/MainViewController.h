//
//  MainViewController.h
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    IBOutlet UIImageView *logoImage;
    IBOutlet UIButton *btnSignup;
    IBOutlet UIButton *btnLogin;
}

-(IBAction)btnSignup_clicked:(id)sender;
-(IBAction)btnLogin_clicked:(id)sender;

@end
