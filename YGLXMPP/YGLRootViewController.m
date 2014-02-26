//
//  YGLRootViewController.m
//  YGLXMPP
//
//  Created by ygl10 on 13-11-18.
//  Copyright (c) 2013年 ygl10. All rights reserved.
//

#import "YGLRootViewController.h"
#import "YGLAppDelegate.h"
#import "YGLSettingsViewController.h"

#import "XMPPFramework.h"
#import "DDLog.h"

@interface YGLRootViewController ()

@end

// Log levels: off, error, warn, info, verbose

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@implementation YGLRootViewController

#pragma mark - YGLAppDelegate Accessors

- (YGLAppDelegate *)appDelegate
{
	return (YGLAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - RootViewController viewWillAppear 做登陆
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([[self appDelegate] connect]) {
        
        titleLabel.text = [self appDelegate].xmppStream.myJID.bare;
        
    } else {
        
        titleLabel.text = @"No JID";
    }
    
    self.navigationItem.titleView = titleLabel;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[self appDelegate] disconnect];
    [[self appDelegate].xmppvCardTempModule removeDelegate:self];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController == nil) {
        
        NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
        
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"sectionNum"
                                                                                  cacheName:nil];
        
        [fetchedResultsController setDelegate:self];
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error]) {
            DDLogError(@"Error performing fetch: %@", error);
        }
    }
    
    return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [[self tableView] reloadData];
}

#pragma mark - UITableViewCell helpers

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user {
    
    // Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
    
    if (user.photo != nil) {
        cell.imageView.image = user.photo;
    }
    else {
        
        NSData *photoData = [[self appDelegate].xmppvCardAvatarModule photoDataForJID:user.jid];
        
        if (photoData != nil) {
            cell.imageView.image = [UIImage imageWithData:photoData];
        } else
            cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self fetchedResultsController] sections].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *sectionsArray = [self fetchedResultsController].sections;
    
    if (section < sectionsArray.count)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sectionsArray objectAtIndex:section];
        
        int section = [sectionInfo.name intValue];
        
        switch (section) {
            case 0  : return @"Available";
            case 1  : return @"Away";
            default : return @"Offline";
        }
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    NSArray *sections = [[self fetchedResultsController] sections];
    
    if (section < [sections count]) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        
        return sectionInfo.numberOfObjects;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    cell.textLabel.text = user.displayName;
    [self configurePhotoForCell:cell user:user];
    
    return cell;
}

- (IBAction)settings:(id)sender {
    
    [self.navigationController presentViewController:[[self appDelegate] settingsViewController] animated:YES completion:NULL];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
