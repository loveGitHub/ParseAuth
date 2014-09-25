//
//  SignUpViewController.m
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "CommonHelper.h"
#import "AppDelegate.h"
#import "InstagramAuthViewController.h"
#import "RegisterViewController.h"
#import "UserProfileViewController.h"
#import "RegisterViewController.h"
#import "SVProgressHUD.h"
#import "Constants.h"
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface SignUpViewController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    NSArray *accounts;
	NSInteger selected;
}

@property(nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) NSData *selectedImageData;
@property(nonatomic, strong) InstagramAuthViewController *instaAuthView;
@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    FBLoginView *fblogin = [[FBLoginView alloc] init];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(IBAction)btn_SignupClicked:(id)sender
{
    self.appDelegate.registerType = REGISTER_WITH_PARSE;
    RegisterViewController *regView = [self.storyboard instantiateViewControllerWithIdentifier: @"registerView"];
    [self presentViewController: regView animated: NO completion: nil];
}

-(IBAction)btn_BackClicked:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self viewMoveUp: textField];
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self viewMoveDown: textField];
    return true;
}


-(void)viewMoveUp:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.view cache:YES];
    [self.view setFrame: CGRectMake(0, -100, self.view.frame.size.width,self.view.frame.size.height)];
    [UIView commitAnimations];
}

-(void)viewMoveDown:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    [self.view setFrame: CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return (UIInterfaceOrientationMaskPortrait);
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}




- (IBAction)actionFacebook:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *permissions = @[@"public_profile"];
    [SVProgressHUD showWithStatus: @"Signup with Facebook..."];
    [self.view setUserInteractionEnabled: false];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user)
        {
            [SVProgressHUD dismiss];
            [self.view setUserInteractionEnabled: true];
            [CommonHelper showTipWithTitle: @"Warning" msg: @"Failed in Signup with Twitter."];
        }
        else if (user.isNew)
        {
            NSLog(@"User signed up and logged in through Facebook!");
            self.appDelegate.registerType = REGISTER_WITH_FACEBOOK;
            [self showRegistrationPage: user];
        }
        else
        {
            [SVProgressHUD dismiss];
            [self.view setUserInteractionEnabled: true];
            [CommonHelper showTipWithTitle: @"Warning" msg: @"You have already signup with Facebook."];
            
        }
    }];

}






- (IBAction)actionTwitter:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [SVProgressHUD showWithStatus: @"Signup with Twitter..."];
    [self.view setUserInteractionEnabled: false];

    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user)
        {
            [SVProgressHUD dismiss];
            [self.view setUserInteractionEnabled: true];
            [CommonHelper showTipWithTitle: @"Warning" msg: @"Failed in Signup with Twitter."];
        }
        else if (user.isNew)
        {
            NSLog(@"User signed up and logged in through Twitter!");
            self.appDelegate.registerType = REGISTER_WITH_TWITTER;
            [self showRegistrationPage: user];
        }
        else
        {
            [SVProgressHUD dismiss];
            [self.view setUserInteractionEnabled: true];
            [CommonHelper showTipWithTitle: @"Warning" msg: @"You have already signup with Twitter."];
        }
    }];
    
}



- (IBAction)actionInstagram:(id)sender
{
    [SVProgressHUD showWithStatus: @"Signup with Instagram..."];
    self.instaAuthView = [[InstagramAuthViewController alloc] init];
    self.instaAuthView.instagramAuthDelegate = self;
    [self.instaAuthView.view setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self presentViewController: self.instaAuthView animated: NO completion: nil];

}




- (void)showRegistrationPage:(PFUser*)user
{
    
    if(self.appDelegate.registerType == REGISTER_WITH_FACEBOOK)
    {
        self.appDelegate.userEmail = user.email;
        self.appDelegate.userName = user.username;
        
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                
                NSLog(@"request did load successfully....");
                
                if ([result isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary* json = result;
                    NSLog(@"email id is %@",[json valueForKey:@"email"]);
                    NSLog(@"json is %@",json);
                    
                    NSString *uid = [json objectForKey: @"id"];
                    NSString *first_name = [json objectForKey:@"first_name"];
                    NSString *last_name = [json objectForKey:@"last_name"];
                    NSString *email = [json objectForKey:@"email"];
                    NSString *gender = [json objectForKey: @"gender"];
                    NSString *locale = [json objectForKey: @"locale"];
                    
                    NSArray *locations = [locale componentsSeparatedByString: @"_"];
                    NSString *location;
                    if(locations.count > 1)
                    {
                        location = [locations objectAtIndex: 1];
                    }
                    else
                        location = [locations objectAtIndex: 0];
                    
                    NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: location forKey: NSLocaleCountryCode]];
                    NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
                    
                    self.appDelegate.countryName = country;
                    self.appDelegate.userProfileImage = nil;
                    self.appDelegate.userEmail = email;
                    self.appDelegate.userFirstName = first_name;
                    self.appDelegate.userLastName = last_name;
                    self.appDelegate.userGender = gender;
                    
                    NSString *url = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?type=large", uid];
                    self.appDelegate.userProfileImageUrl = url;
                    
                    [self.view setUserInteractionEnabled: false];

                    [user setUsername: self.appDelegate.userName];
                    [user setPassword: self.appDelegate.userPassword];
                    [user setEmail: self.appDelegate.userEmail];
                    [user setObject: self.appDelegate.userGender forKey: @"userGender"];
                    [user setObject: location forKey: @"countryCode"];
                    [user setObject: self.appDelegate.userFirstName forKey: @"firstName"];
                    [user setObject: self.appDelegate.userLastName forKey: @"lastName"];
                    [user setObject: [NSString stringWithFormat: @"%@ %@", self.appDelegate.userFirstName, self.appDelegate.userLastName] forKey: @"fullName"];
                    
                    self.selectedImageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: self.appDelegate.userProfileImageUrl]];
                    
                    self.selectedImageData = nil;
                    if(self.selectedImageData == nil)
                    {
                        self.selectedImageData = UIImageJPEGRepresentation([UIImage imageNamed: @"profile_placeholder.png"],1.0);
                    }
                    
                    PFFile *imageFile = [PFFile fileWithName: @"profileImg.png" data: self.selectedImageData];
                    [user setObject: imageFile forKey: @"userphoto"];
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded)
                        {
                            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                [SVProgressHUD dismiss];
                                [self.view setUserInteractionEnabled: true];
                                if(!error)
                                {
                                    [CommonHelper showTipWithTitle: @"ParseAuth" msg: @"Your user info has been successfully uploaded. Thanks for your registration."];
                                    UserProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier: @"profileView"];
                                    [self presentViewController: profileView animated: NO completion: nil];
                                }
                                else
                                {
                                    [CommonHelper showTipWithTitle: @"Warning" msg: [error description]];
                                }
                                
                            }];

                        }
                    }];

                }
            }
            else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
                [CommonHelper showTipWithTitle: @"Warning" msg: @"Facebook Authentication Failed."];
            }
            else
            {
                NSLog(@"Some other error: %@", error);
                [CommonHelper showTipWithTitle: @"Warning" msg: @"Facebook Authentication Failed."];
            }
        }];

    }
    else if(self.appDelegate.registerType == REGISTER_WITH_TWITTER)
    {
        [SVProgressHUD dismiss];
        
        self.appDelegate.userName = user.username;
        
        RegisterViewController *regView = [self.storyboard instantiateViewControllerWithIdentifier: @"registerView"];
        [self presentViewController: regView animated: NO completion: nil];

    }

}


- (void)instagramAuthLoadFailed:(NSError *)error
{
    [SVProgressHUD dismiss];
    [CommonHelper showTipWithTitle: @"Warning" msg: @"Failed in Signup with Instagram."];
    [self.instaAuthView dismissViewControllerAnimated: NO completion: nil];

}


- (void)instagramAuthSucceeded:(NSString *)token
{
    [SVProgressHUD dismiss];
    [self.instaAuthView dismissViewControllerAnimated: NO completion: nil];
    self.appDelegate.registerType = REGISTER_WITH_INSTAGRAM;
    self.appDelegate.userName = token;
    RegisterViewController *regView = [self.storyboard instantiateViewControllerWithIdentifier: @"registerView"];
    [self presentViewController: regView animated: NO completion: nil];
}

//- (void)showRegView
//{
//    RegisterViewController *regView = [self.storyboard instantiateViewControllerWithIdentifier: @"registerView"];
//    [self presentViewController: regView animated: NO completion: nil];
//}
- (void)instagramAuthFailed:(NSString *)error
                errorReason:(NSString *)errorReason
           errorDescription:(NSString *)errorMessage
{
    [SVProgressHUD dismiss];
    [CommonHelper showTipWithTitle: @"Warning" msg: @"Failed in Signup with Instagram."];
    [self.instaAuthView dismissViewControllerAnimated: NO completion: nil];

}

@end
