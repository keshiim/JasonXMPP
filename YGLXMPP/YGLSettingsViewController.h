//
//  YGLSettingsViewController.h
//  YGLXMPP
//
//  Created by ygl10 on 13-11-18.
//  Copyright (c) 2013年 ygl10. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kXMPPmyJID;
extern NSString * const kXMPPmyPassword;

@interface YGLSettingsViewController : UIViewController
{
    UITextField *jidField;
    UITextField *passwordField;
}

@property (nonatomic, strong) IBOutlet UITextField *jidField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

- (IBAction)done:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
