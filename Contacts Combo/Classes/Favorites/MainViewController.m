//
//  MainViewController.m
//  Quick Dial
//
//  Created by Kalai Chelvan on 5/7/13.
//  Copyright (c) 2013 Kalai Chelvan. All rights reserved.

//

#import "MainViewController.h"
#import "AddItemViewController.h"
#import <QuartzCore/QuartzCore.h>



@interface MainViewController ()

@end

#import "QuicklistItem.h"


@implementation MainViewController {
    
    ///create nsmutablearray
    
    NSMutableArray *items;
    
}

///synthesize the declared property
@synthesize Segment;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
      

   ///set the tableview background programmatically with uiimage
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    
    
 ///initiate  pull to refresh control
    
    [self.refreshControl
     addTarget:self
     action:@selector(refresh)
     forControlEvents:UIControlEventValueChanged
     ];

    
        
}




///This Documents directory allows you to store files and subdirectories your app creates or may need.
///To access files in the Library directory of your apps sandbox use (in place of pathsabove):


- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

///save as plist

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"QuickDial.plist"];
}


///method to save the plist

- (void)saveChecklistItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:items forKey:@"QuicklistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}


///method to load the plist

- (void)loadChecklistItems
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        items = [unarchiver decodeObjectForKey:@"QuicklistItems"];
        [unarchiver finishDecoding];
    }
    else
    {
        items = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self loadChecklistItems];
    }
    return self;
}





///define number of rows in tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(                                                                       NSInteger)section
{
    return [items count];
}


///configure tableviewcell with reuseidentifier

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuicklistItem"];
    QuicklistItem *item = [items objectAtIndex:indexPath.row];
    [self configureTextForCell:cell withChecklistItem:item];
     
    return cell;
}





///customize uitablevoewcell with uiimage  and add uitableviewcell seperator

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-element.png"]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


///set the uitableviewcell height programmatically. this overrides settings in storyboard

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  return 53;
    
}



///following method allows the name and telephone number to configure in uitableviewcell

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(QuicklistItem *)item
{
   
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1000];
    nameLabel.text = item.name;

    
    UILabel *phoneLabel = (UILabel *)[cell viewWithTag:1500];
    phoneLabel.text = item.mobile;
    
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1100];
    imageView.image = item.image;

  
  ///uiimageview to render in circular shape
    
    imageView.layer.cornerRadius = 20.0; //radius has to be half of the uiimageviewsize
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView.layer.borderWidth = 1.0;

}


///when user tap on the uitableviewcell, following method checks whether the selected index is Phone / SMS and then call the appropriate action

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
   ///to get the uitablecell that tapped
    
    QuicklistItem *item = [items objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    /// connvert the mobile number to string
    
    NSString *phoneString = [item.mobile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
    /// check for selected segement index
    if(Segment.selectedSegmentIndex == 0){  ///if mobile s selected, "phoneString" is passed to final string

    NSString *finalString = [NSString stringWithFormat:@"Tel:%@",phoneString];

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:finalString]]; /// activates tel app
 
    }	if(Segment.selectedSegmentIndex == 1){ /// if message index is selected
        
        NSString *finalString = [NSString stringWithFormat:@"sms:%@",phoneString];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:finalString]]; // send message to the selected phone no
    }

}



///following method deletes the uitableviewcell and update the plist when user swipe on the uitableview cell

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [items removeObjectAtIndex:indexPath.row];
    [self saveChecklistItems];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
}



///dismiss presenting viewcontroller when the user choose to cancel without adding any contact

- (void)addItemViewControllerDidCancel:(AddItemViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



///when the user completes entering/importing contact from address book, following method inserts the data into uitableview cell and update the plist file

- (void)addItemViewController:(AddItemViewController *)controller didFinishAddingItem:(QuicklistItem *)item
{
    int newRowIndex = [items count];
    [items addObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];}



///this prepares the segue which mode to be presented. whether to present additem mode or edititem mode. if the user tapped on the add button, additem will be presented. if the user taps on the accessoryview, editing mode wll be presented

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddItemViewController *controller = (AddItemViewController *)navigationController.topViewController;
        controller.delegate = self;
    }else if ([segue.identifier isEqualToString:@"EditItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddItemViewController *controller = (AddItemViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.itemToEdit = sender;
    }
}



/// presents the additemviewcontroller in edititem mode when accessory button tapped

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    QuicklistItem *item = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditItem" sender:item];
        
}



///when editing finished, it updated the uitableviewcell and saves plist file

- (void)addItemViewController:(AddItemViewController *)controller didFinishEditingItem:(QuicklistItem *)item
{
    int index = [items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    [self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}



// method to call pull to refresh

- (void)refresh
{
    //when the pull to refresh reaches end, performseguewithidentifier method is invoked
    
    [self performSegueWithIdentifier:@"AddItem" sender:self];
    
    // release pulltorefreshcontrol
    [self.refreshControl endRefreshing];
    
}


-(void)viewDidUnload
{


}

- (IBAction)ShowMainMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}






@end
