//
//  RegisterViewController.m
//  ParseAuth
//
//  Created by Guoyang on 9/23/14.
//  Copyright (c) 2014 3wmedia. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "CommonHelper.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "UserProfileViewController.h"
#import "DropDownListView.h"

@interface RegisterViewController () <UINavigationBarDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property(nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic, strong) NSData *selectedImageData;
@property(nonatomic, strong) DropDownListView * dropObj;
@property(nonatomic, strong) NSArray *countryCodes;
@property(nonatomic, strong) NSMutableArray *countryNames;

@end

@implementation RegisterViewController

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
    

    [btn_male setImage: [UIImage imageNamed: @"off_radio_button.png"] forState: UIControlStateNormal];
    [btn_male setImage: [UIImage imageNamed: @"on_radio_button.png"] forState: UIControlStateSelected];
    [btn_female setImage: [UIImage imageNamed: @"off_radio_button.png"] forState: UIControlStateNormal];
    [btn_female setImage: [UIImage imageNamed: @"on_radio_button.png"] forState: UIControlStateSelected];
    
    [btn_male setSelected: true];
    [btn_female setSelected: false];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    self.countryCodes = [NSArray array];
    self.countryNames = [NSMutableArray array];
    
    self.countryCodes = [NSLocale ISOCountryCodes];

    for (NSString *countryCode in self.countryCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        [self.countryNames addObject: country];
    }
    
    if(self.appDelegate.registerType == REGISTER_WITH_TWITTER)
    {
        [edtUserName setText: self.appDelegate.userName];
        [edtUserName setUserInteractionEnabled: false];
    }
    else if(self.appDelegate.registerType == REGISTER_WITH_INSTAGRAM)
    {
        [edtUserName setText: self.appDelegate.userName];
        [edtUserName setUserInteractionEnabled: false];
    }
    else if(self.appDelegate.registerType == REGISTER_WITH_PARSE)
    {
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(IBAction)btn_loadImageClicked:(id)sender
{
    [self showActionSheet];
}

-(IBAction)btn_maleClicked:(id)sender
{
    [btn_male setSelected: true];
    [btn_female setSelected: false];
}

-(IBAction)btn_femaleClicked:(id)sender
{
    [btn_male setSelected: false];
    [btn_female setSelected: true];
}

-(IBAction)btn_backCLicked:(id)sender
{
    [self dismissViewControllerAnimated: NO completion: nil];
}

-(IBAction)btn_nextClicked:(id)sender
{
    if([edtFirstName.text isEqual: @""])
    {
        [CommonHelper showTipWithTitle: @"Warning" msg: @"Please input the first name field."];
        return;
    }
    if([edtLastName.text isEqual: @""])
    {
        [CommonHelper showTipWithTitle: @"Warning" msg: @"Please input the last name field."];
        return;
    }
    if([edtUserName.text isEqual: @""])
    {
        [CommonHelper showTipWithTitle: @"Warning" msg: @"Please input your user name."];
        return;
    }
    if([[btn_country titleLabel].text isEqual: @"Country"])
    {
        [CommonHelper showTipWithTitle: @"Warning" msg: @"Please select your country."];
        return;
    }
    
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
        NSString *str = [email substringFromIndex: foundRange.location];
        if([str isEqual: @""])
        {
            [CommonHelper showTipWithTitle: @"VPNPro" msg: @"Please input the valid email address."];
            return;
        }
        else
        {
            if(![password isEqual: @""])
            {
                self.appDelegate.userEmail = email;
                self.appDelegate.userPassword = password;
            }
            else
            {
                [CommonHelper showTipWithTitle: @"VPNPro" msg: @"Please input your password."];
                return;
            }
        }
    }
    else
    {
        [CommonHelper showTipWithTitle: @"VPNPro" msg: @"Please input the valid email address."];
        return;
    }
    
    self.appDelegate.userFirstName = edtFirstName.text;
    self.appDelegate.userLastName = edtLastName.text;
    self.appDelegate.userName = edtUserName.text;
    if(btn_male.isSelected)
        self.appDelegate.userGender = @"male";
    else
        self.appDelegate.userGender = @"female";
    self.appDelegate.userProfileImage = profileImgView.image;
    self.appDelegate.countryName = [btn_country titleLabel].text;
    self.appDelegate.userProfileImageUrl = nil;
    
    NSString *countryCode = [self.countryCodes objectAtIndex: [self.countryNames indexOfObject: [btn_country titleLabel].text]];
    
    PFUser *userObject;

    if((self.appDelegate.registerType == REGISTER_WITH_PARSE)||(self.appDelegate.registerType == REGISTER_WITH_INSTAGRAM))
    {
        userObject = [PFUser user];
        [userObject setUsername: self.appDelegate.userName];
        [userObject setPassword: self.appDelegate.userPassword];
        [userObject setEmail: self.appDelegate.userEmail];
        [userObject setObject: self.appDelegate.userGender forKey: @"userGender"];
        [userObject setObject: countryCode forKey: @"countryCode"];
        [userObject setObject: self.appDelegate.userFirstName forKey: @"firstName"];
        [userObject setObject: self.appDelegate.userLastName forKey: @"lastName"];
        [userObject setObject: [NSString stringWithFormat: @"%@ %@", edtFirstName.text, edtLastName.text] forKey: @"fullName"];
        
        if(self.selectedImageData == nil)
        {
            self.selectedImageData = UIImageJPEGRepresentation([UIImage imageNamed: @"profile_placeholder.png"],1.0);
        }
        PFFile *imageFile = [PFFile fileWithName: @"profileImg.png" data: self.selectedImageData];
        [userObject setObject: imageFile forKey: @"userphoto"];
        [SVProgressHUD showWithStatus: @"Registering user info..."];
        [userObject signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error)
         {
             [SVProgressHUD dismiss];
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
    else if(self.appDelegate.registerType == REGISTER_WITH_TWITTER)
    {
        userObject = [PFUser currentUser];
        [userObject setUsername: self.appDelegate.userName];
        [userObject setPassword: self.appDelegate.userPassword];
        [userObject setEmail: self.appDelegate.userEmail];
        [userObject setObject: self.appDelegate.userGender forKey: @"userGender"];
        [userObject setObject: countryCode forKey: @"countryCode"];
        [userObject setObject: self.appDelegate.userFirstName forKey: @"firstName"];
        [userObject setObject: self.appDelegate.userLastName forKey: @"lastName"];
        [userObject setObject: [NSString stringWithFormat: @"%@ %@", edtFirstName.text, edtLastName.text] forKey: @"fullName"];
        
        if(self.selectedImageData == nil)
        {
            self.selectedImageData = UIImageJPEGRepresentation([UIImage imageNamed: @"profile_placeholder.png"],1.0);
        }
        PFFile *imageFile = [PFFile fileWithName: @"profileImg.png" data: self.selectedImageData];
        [userObject setObject: imageFile forKey: @"userphoto"];
        [SVProgressHUD showWithStatus: @"Registering user info..."];
        [userObject saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error)
         {
             [SVProgressHUD dismiss];
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
    

}

-(IBAction)btn_countryClicked:(id)sender
{
    [edtFirstName resignFirstResponder];
    [edtLastName resignFirstResponder];
    [edtUserName resignFirstResponder];
    
    [self.dropObj fadeOut];

    [self showPopUpWithTitle:@"Country" withOption:self.countryNames xy:CGPointMake(btn_country.frame.origin.x, btn_country.frame.origin.y) size:CGSizeMake(btn_country.frame.size.width, 280) isMultiple:NO];

}

-(void)showActionSheet
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Take Photo",@"Import from Library",nil];
    
    [actionSheet showFromRect: CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width,200) inView: self.view animated: YES];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            //Cancel button, Do nothing
            break;
        }
        case 1:
        {
            [self takePhoto];
            break;
        }
        case 2:
        {
            [self selectPhoto];
            break;
        }
            break;
    }
    
}


- (void)selectPhoto
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //picker.navigationBar.barStyle = UIBarStyleDefault;
    //picker.navigationBar.tintColor = [UIColor blackColor];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)takePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImageData = [[NSData alloc] init];
    
    if ([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.selectedImageData = UIImageJPEGRepresentation(chosenImage,1.0);

//        self.selectedImageData = UIImagePNGRepresentation([self imageByScalingProportionallyToSize: CGSizeMake(400, 400) withOriginalImage:chosenImage]);
//        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//            [edt_filename setText: @"Snapshot.jpg"];
//        else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
//            [edt_filename setText:[NSString stringWithFormat:@"%@",[info valueForKey:@"UIImagePickerControllerReferenceURL"]]];

        [profileImgView setImage:chosenImage];

    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize withOriginalImage:(UIImage *)origin {
    
    UIImage *sourceImage = origin;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [self viewMoveUp: textField];
    [self.dropObj fadeOut];
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [self viewMoveDown: textField];
    return true;
}



-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    

    self.dropObj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    self.dropObj.delegate = self;
    [self.dropObj showInView:self.view animated:YES];
    [self.dropObj SetBackGroundDropDwon_R:45.0 G:45.0 B:45.0 alpha:0.70];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex
{
    [btn_country setTitle:[self.countryNames objectAtIndex:anIndex] forState:UIControlStateNormal];
}

- (void)DropDownListViewDidCancel{
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [self.dropObj fadeOut];
    }
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
