//
//  RegisterViewController.h
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UIViewController
{
    IBOutlet UITextField *edtFirstName;
    IBOutlet UITextField *edtLastName;
    IBOutlet UITextField *edtUserName;
    IBOutlet UIImageView *profileImgView;
    IBOutlet UIButton *btn_country;
    IBOutlet UIButton *btn_loadImg;
    IBOutlet UIButton *btn_male;
    IBOutlet UIButton *btn_female;
    IBOutlet UITextField *edtEmail;
    IBOutlet UITextField *edtPassword;
}

-(IBAction)btn_loadImageClicked:(id)sender;
-(IBAction)btn_maleClicked:(id)sender;
-(IBAction)btn_femaleClicked:(id)sender;
-(IBAction)btn_backCLicked:(id)sender;
-(IBAction)btn_nextClicked:(id)sender;
-(IBAction)btn_countryClicked:(id)sender;

@end
