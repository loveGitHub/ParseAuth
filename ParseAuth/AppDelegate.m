//
//  AppDelegate.m
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"QHnXEXk4Xiypm8v04YbwgCIhsfIUq935KRQoRLSZ"
                  clientKey:@"mm8bGx60Rcs6DqzR5m8pUWQobxkp1u8DJjrCx9Qc"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];

    [PFTwitterUtils initializeWithConsumerKey:@"C4vNCYG4d3oNRMUP0U8wuoY4F"
                               consumerSecret:@"1A0PnIs9mZjKYbbWMh6olA7EFxZtRAhsglb1oxafGpjLWic5O0"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}


@end
