//
//  YGLSettingsViewController.m
//  YGLXMPP
//
//  Created by ygl10 on 13-11-18.
//  Copyright (c) 2013年 ygl10. All rights reserved.
//

#import "YGLSettingsViewController.h"

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

@interface YGLSettingsViewController ()

@end

@implementation YGLSettingsViewController

@synthesize jidField;
@synthesize passwordField;

#pragma mark - init/dealloc methods
- (void)awakeFromNib {
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

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
    // Do any additional setup after loading the view from its nib.
    
    jidField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    passwordField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
}

- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    
    if (field.text != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    
    [self setField:jidField forKey:kXMPPmyJID];
    [self setField:passwordField forKey:kXMPPmyPassword];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)hideKeyboard:(id)sender {
    
    [sender resignFirstResponder];
    [self done:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
