//
//  YGLRootViewController.h
//  YGLXMPP
//
//  Created by ygl10 on 13-11-18.
//  Copyright (c) 2013年 ygl10. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface YGLRootViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}

- (IBAction)settings:(id)sender;

@end
