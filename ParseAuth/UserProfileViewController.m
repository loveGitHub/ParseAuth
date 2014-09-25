//
//  UserProfileViewController.m
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AppDelegate.h"

@interface UserProfileViewController ()

@property(nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation UserProfileViewController

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
    if(self.appDelegate.userProfileImageUrl == nil)
        [imgProfile setImage: self.appDelegate.userProfileImage];
    else
    {
        imgProfile.imageURL = [NSURL URLWithString: self.appDelegate.userProfileImageUrl];
    }
    [txtFullName setText: [NSString stringWithFormat: @"%@ %@", self.appDelegate.userFirstName, self.appDelegate.userLastName]];
    [txtUserName setText: self.appDelegate.userName];
    [txtCountry setText: self.appDelegate.countryName];
    [txtGender setText: self.appDelegate.userGender];
    [txtEmail setText: self.appDelegate.userEmail];
    
    imgProfile.layer.cornerRadius = imgProfile.frame.size.height /2;
    imgProfile.layer.masksToBounds = YES;
    imgProfile.layer.borderWidth = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)btn_backClicked:(id)sender
{
    [self dismissViewControllerAnimated: NO completion: nil];
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
