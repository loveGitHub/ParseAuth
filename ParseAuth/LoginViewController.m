//
//  LoginViewController.m
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CommonHelper.h"
#import "SVProgressHUD.h"
#import "UserProfileViewController.h"
#import "Constants.h"
#import "InstagramAuthViewController.h"
#import "InstagramClient.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>

@interface LoginViewController ()
{
	NSArray *accounts;
	NSInteger selected;
}


@property(nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic, strong) NSDictionary *userInfo;
@property(nonatomic, strong) InstagramAuthViewController *instaAuthView;

@end

@implementation LoginViewController

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
    self.appDelegate = [UIApplication sharedApplication].delegate;
}

-(IBAction)btn_loginClicked:(id)sender
{
    NSString *email = edtEmail.text;
    NSString *password = edtPassword.text;
    NSRange productNameRange = NSMakeRange(0, email.length);

    if([email isEqual:@""])
    {
        [CommonHelper showTipWithTitle: @"Warning" msg: @"Please input your email."];
        return;
    }
    NSRange foundRange = [email rangeOfString: @"@" options: 0 range:productNameRange];
    if (foundRange.length > 0)
    {
        PFQuery *messageQuery = [PFQuery queryWithClassName:@"_User"];
        [messageQuery whereKey:@"email" equalTo: email];
        [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            PFUser *user = [objects objectAtIndex: 0];
            if(!error)
            {
                self.appDelegate.userEmail = user.email;
                self.appDelegate.userName = user.username;
                self.appDelegate.userFirstName = [user objectForKey: @"firstName"];
                self.appDelegate.userLastName = [user objectForKey: @"lastName"];
                self.appDelegate.userGender = [user objectForKey: @"userGender"];
                self.appDelegate.userProfileImage = nil;
                NSString *countryCode = [user objectForKey: @"countryCode"];
                
                NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
                NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
                
                self.appDelegate.countryName = country;
                
                PFFile *photo = [user objectForKey: @"userphoto"];
                NSString *url = photo.url;
                self.appDelegate.userProfileImageUrl = url;
                
                self.appDelegate.loginType = LOGIN_WITH_PARSE;
                UserProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier: @"profileView"];
                [self presentViewController: profileView animated: NO completion: nil];

            }
            else
            {
                [CommonHelper showTipWithTitle: @"Warning" msg: [error description]];

            }
        }];
    }
    else
    {
        [SVProgressHUD showWithStatus: @"Login..."];
        [PFUser logInWithUsernameInBackground: email
                                     password: password block:^(PFUser *user, NSError *error)
         
         {
             [SVProgressHUD dismiss];
             if (!error) {
                 
                 self.appDelegate.userEmail = user.email;
                 self.appDelegate.userName = user.username;
                 self.appDelegate.userFirstName = [user objectForKey: @"firstName"];
                 self.appDelegate.userLastName = [user objectForKey: @"lastName"];
                 self.appDelegate.userGender = [user objectForKey: @"userGender"];
                 self.appDelegate.userProfileImage = nil;
                 NSString *countryCode = [user objectForKey: @"countryCode"];
                 
                 
                 NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
                 NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
                 
                 self.appDelegate.countryName = country;
                 
                 PFFile *photo = [user objectForKey: @"userphoto"];
                 NSString *url = photo.url;
                 self.appDelegate.userProfileImageUrl = url;
                 
                 self.appDelegate.loginType = LOGIN_WITH_PARSE;
                 UserProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier: @"profileView"];
                 [self presentViewController: profileView animated: NO completion: nil];
             }
             else
                 [CommonHelper showTipWithTitle: @"Warning" msg: [error description]];
             
         }];

    }
    
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


-(IBAction)btn_backClicked:(id)sender
{
    [self dismissViewControllerAnimated: NO completion: nil];
}




- (IBAction)actionFacebook:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [SVProgressHUD showWithStatus: @"Login with Facebook..."];
    NSArray *permissions = @[@"public_profile"];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        
        if (!user)
        {
            [SVProgressHUD dismiss];
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            NSLog([error description]);
        }
        else if (user.isNew)
        {
            [SVProgressHUD dismiss];
            NSLog(@"User signed up and logged in through Facebook!");
            [CommonHelper showTipWithTitle: @"Warning" msg: @"No registered user found. Please signup to use the app."];
            [self.view setUserInteractionEnabled: false];
            [user deleteInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
                if(succeeded)
                {
                    [self.view setUserInteractionEnabled: true];
                }
                else
                {
                    [user deleteInBackground];
                    [self.view setUserInteractionEnabled: true];
                }
            }];
        }
        else
        {
            NSLog(@"User logged in through Facebook!");
            self.appDelegate.loginType = LOGIN_WITH_FACEBOOK;
            [self showProfilePage: user];
        }
    }];
    
}






- (IBAction)actionTwitter:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [SVProgressHUD showWithStatus: @"Login with Twitter..."];
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
            NSLog(@"User signed up and logged in through Facebook!");
            [CommonHelper showTipWithTitle: @"Warning" msg: @"No registered user found. Please signup to use the app."];
            [self.view setUserInteractionEnabled: false];
            [user deleteInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
                if(succeeded)
                {
                    [self.view setUserInteractionEnabled: true];
                }
                else
                {
                    [user deleteInBackground];
                    [self.view setUserInteractionEnabled: true];
                }
            }];
        }
        else
        {
            [SVProgressHUD dismiss];
            [self.view setUserInteractionEnabled: true];
            self.appDelegate.loginType = LOGIN_WITH_TWITTER;
            [self showProfilePage: user];
        }
    }];
    
//    NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
//    NSError *error;
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
//    [[PFTwitterUtils twitter] signRequest:request];
//    NSURLResponse *response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:&response
//                                                     error:&error];
//
}


- (IBAction)actionInstagram:(id)sender
{
    [SVProgressHUD showWithStatus: @"Login with Instagram..."];
    self.instaAuthView = [[InstagramAuthViewController alloc] init];
    self.instaAuthView.instagramAuthDelegate = self;
    [self.instaAuthView.view setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self presentViewController: self.instaAuthView animated: NO completion: nil];
}




- (void)showProfilePage:(PFUser*)user
{
    
    self.appDelegate.userEmail = user.email;
    self.appDelegate.userName = user.username;

    if(self.appDelegate.loginType == LOGIN_WITH_FACEBOOK)
    {
//        FBRequest *request = [FBRequest requestForMe];
//        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//            if (!error) {
//                
//                NSLog(@"request did load successfully....");
//                
//                if ([result isKindOfClass:[NSDictionary class]]) {
//                    
//                    NSDictionary* json = result;
//                    NSLog(@"email id is %@",[json valueForKey:@"email"]);
//                    NSLog(@"json is %@",json);
//                    
//                    NSString *uid = [json objectForKey: @"id"];
//                    NSString *first_name = [json objectForKey:@"first_name"];
//                    NSString *last_name = [json objectForKey:@"last_name"];
//                    NSString *email = [json objectForKey:@"email"];
//                    NSString *gender = [json objectForKey: @"gender"];
//                    NSString *locale = [json objectForKey: @"locale"];
//                    
//                    NSArray *locations = [locale componentsSeparatedByString: @"_"];
//                    NSString *location;
//                    if(locations.count > 1)
//                    {
//                        location = [locations objectAtIndex: 1];
//                    }
//                    else
//                        location = [locations objectAtIndex: 0];
//                    
//                    NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: location forKey: NSLocaleCountryCode]];
//                    NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
//
//                    self.appDelegate.countryName = country;
//                    self.appDelegate.userProfileImage = nil;
//                    self.appDelegate.userEmail = email;
//                    self.appDelegate.userFirstName = first_name;
//                    self.appDelegate.userLastName = last_name;
//                    self.appDelegate.userGender = gender;
//                    
//                    NSString *url = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?type=large", uid];
//                    self.appDelegate.userProfileImageUrl = url;
//                    [SVProgressHUD dismiss];
//                    
//                    UserProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier: @"profileView"];
//                    [self presentViewController: profileView animated: NO completion: nil];
//
//                }
//            }
//            else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
//                NSLog(@"The facebook session was invalidated");
//            }
//            else
//            {
//                NSLog(@"Some other error: %@", error);
//            }
//        }];
        
        self.appDelegate.userFirstName = [user objectForKey: @"firstName"];
        self.appDelegate.userLastName = [user objectForKey: @"lastName"];
        self.appDelegate.userGender = [user objectForKey: @"userGender"];
        self.appDelegate.userProfileImage = nil;
        NSString *countryCode = [user objectForKey: @"countryCode"];
        
        
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        
        self.appDelegate.countryName = country;
        
        PFFile *photo = [user objectForKey: @"userphoto"];
        NSString *url = photo.url;
        self.appDelegate.userProfileImageUrl = url;
        
        [SVProgressHUD dismiss];
        UserProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier: @"profileView"];
        [self presentViewController: profileView animated: NO completion: nil];

    }
    else if(self.appDelegate.loginType == LOGIN_WITH_TWITTER)
    {
        self.appDelegate.userEmail = user.email;
        self.appDelegate.userName = user.username;
        
        self.appDelegate.userFirstName = [user objectForKey: @"firstName"];
        self.appDelegate.userLastName = [user objectForKey: @"lastName"];
        self.appDelegate.userGender = [user objectForKey: @"userGender"];
        self.appDelegate.userProfileImage = nil;
        NSString *countryCode = [user objectForKey: @"countryCode"];
        
        
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        
        self.appDelegate.countryName = country;
        
        PFFile *photo = [user objectForKey: @"userphoto"];
        NSString *url = photo.url;
        self.appDelegate.userProfileImageUrl = url;
        
        UserProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier: @"profileView"];
        [self presentViewController: profileView animated: NO completion: nil];
        

    }
    

}







- (void)instagramAuthLoadFailed:(NSError *)error
{
    [SVProgressHUD dismiss];
    [self.instaAuthView dismissViewControllerAnimated: NO completion: nil];
    [CommonHelper showTipWithTitle: @"Warning" msg: @"Failed to authorize with Instagram."];
}

- (void)instagramAuthSucceeded:(NSString *)token
{
    [self.instaAuthView dismissViewControllerAnimated: NO completion: nil];
    [SVProgressHUD dismiss];
    PFQuery *messageQuery = [PFQuery queryWithClassName:@"_User"];
    [messageQuery whereKey:@"username" equalTo: token];
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(!error)
        {
            if([objects count] > 0)
            {
                PFUser *user = [objects objectAtIndex: 0];
                self.appDelegate.userEmail = user.email;
                self.appDelegate.userName = user.username;
                self.appDelegate.userFirstName = [user objectForKey: @"firstName"];
                self.appDelegate.userLastName = [user objectForKey: @"lastName"];
                self.appDelegate.userGender = [user objectForKey: @"userGender"];
                self.appDelegate.userProfileImage = nil;
                NSString *countryCode = [user objectForKey: @"countryCode"];
                
                NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
                NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
                
                self.appDelegate.countryName = country;
                
                PFFile *photo = [user objectForKey: @"userphoto"];
                NSString *url = photo.url;
                self.appDelegate.userProfileImageUrl = url;
                
                self.appDelegate.loginType = LOGIN_WITH_PARSE;
                UserProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier: @"profileView"];
                [self presentViewController: profileView animated: NO completion: nil];
            }
            else
            {
                [CommonHelper showTipWithTitle: @"Warning" msg: @"No registered user found."];
            }
            
        }
        else
        {
            [CommonHelper showTipWithTitle: @"Warning" msg: [error description]];
            
        }
    }];

    
//    InstagramClient *client = [InstagramClient clientWithToken: token];
//    [client getUser:@"b9305c3be93c42ad810beb256cbc8e3a"
//            success:^(InstagramUser* user) {
//                NSLog(@"Got user : %@ (%@)", user.fullname, user.username);
//                
////                @property(readonly) NSString *identifier;
////                @property(readonly) NSString *fullname;
////                @property(readonly) NSString *username;
////                @property(readonly) NSString *bio;
////                @property(readonly) NSString *website;
////                @property(readonly) NSString *profilePictureUrl;
////                @property(readonly) NSInteger followedByCount;
////                @property(readonly) NSInteger followersCount;
////                @property(readonly) NSInteger mediaCount;
//                
//                self.appDelegate.loginType = LOGIN_WITH_INSTAGRAM;
//                UserProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier: @"profileView"];
//                [self presentViewController: profileView animated: NO completion: nil];
//            }
//            failure:^(NSError *error, NSInteger statusCode) {
//                NSLog(@"Error fetching user %ld - %@", (long)statusCode, [error localizedDescription]);
//            }
//     ];
}

- (void)instagramAuthFailed:(NSString *)error
                errorReason:(NSString *)errorReason
           errorDescription:(NSString *)errorMessage
{
    [SVProgressHUD dismiss];
    [self.instaAuthView dismissViewControllerAnimated: NO completion: nil];
    [CommonHelper showTipWithTitle: @"Warning" msg: @"Failed to authorize with Instagram."];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
