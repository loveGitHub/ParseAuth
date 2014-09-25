//
//  AppDelegate.h
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userFirstName;
@property (strong, nonatomic) NSString *userLastName;
@property (strong, nonatomic) NSString *userGender;
@property (strong, nonatomic) UIImage *userProfileImage;
@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString *userProfileImageUrl;
@property (assign, nonatomic) int       registerType;
@property (assign, nonatomic) int       loginType;

@end
