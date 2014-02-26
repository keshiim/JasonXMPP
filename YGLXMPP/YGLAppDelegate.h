//
//  YGLAppDelegate.h
//  YGLXMPP
//
//  Created by ygl10 on 13-11-18.
//  Copyright (c) 2013年 ygl10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"

@class YGLSettingsViewController;

@interface YGLAppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate, XMPPStreamDelegate> {
    
    XMPPStream          *xmoppStream;
    XMPPReconnect       *xmppReconnect;
    XMPPRoster          *xmppRoster; // 花名片--好友列表
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    
    XMPPvCardCoreDataStorage *xmppvCardStorage; //名片格式的标准文档
    XMPPvCardAvatarModule    *xmppvCardAvatarModule;
    XMPPvCardTempModule      *xmppvCardTempModule;
    
    XMPPCapabilities         *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage; //XEP-0115 实体性能 -- XEP 0030的一个通过即时出席的定制，可以实时改变交变广告功能。
    
    ////////
    NSString    *passworld;
    
    BOOL    allowSelfSignedCertificates;
    BOOL    allowSSLHostNameMismatch;
    BOOL    isXmppConnected;
    
    UIWindow    *window;
    UINavigationController      *navigationController;
    YGLSettingsViewController   *loginViewController;
    
    UIBarButtonItem *loginButton;
}

@property (nonatomic, strong, readonly) XMPPStream      *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect   *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster      *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage   *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule         *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule       *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities            *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

//////////////////////////////////////
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) IBOutlet YGLSettingsViewController *settingsViewController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;

@end
