//
//  FlickrImageListViewController.m
//  FlickrFeed
//
//  Created by Michael Dautermann on 12/6/12.
//  Copyright (c) 2012 Michael Dautermann. All rights reserved.
//

#import "FlickrImageListViewController.h"
#import "RssParser.h"
#import "RssItem.h"
#import "FlickrPictureFeed.h"
#import "FlickrImageViewController.h"
#import "ImageTableViewCell.h"

@interface FlickrImageListViewController ()

@end

@implementation FlickrImageListViewController

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
	// Do any additional setup after loading the view.
        
    timeFormatter = [[NSDateFormatter alloc] init ];
    if(timeFormatter)
    {
        [timeFormatter setDateFormat:@"HH:mm:ss"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPictureEntriesArrived:) name:@"new_pictures_have_arrived" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (FlickrPictureEntry *) getPreviousEntry
{
    FlickrPictureEntry * selectedItem = NULL;
    if(selectedImageIndex > 0)
    {
        selectedImageIndex--;
        selectedItem = [pictureItemArray objectAtIndex: selectedImageIndex];
    }
    return(selectedItem);
}

- (FlickrPictureEntry *) getNextEntry
{
    FlickrPictureEntry * selectedItem = NULL;
    if(selectedImageIndex < ([pictureItemArray count] - 1))
    {
        selectedImageIndex++;
        selectedItem = [pictureItemArray objectAtIndex: selectedImageIndex];
    }
    return(selectedItem);
}

// this is probably a great place to do this as a bindable property
//
// I haven't fully implemented this, but if I had... I would enable or disable the arrow buttons
- (BOOL) previousEntryAvailable
{
    if(selectedImageIndex > 1)
    {
        return YES;
    }
    return NO;
}

- (BOOL) nextEntryAvailable
{
    if(selectedImageIndex < ([pictureItemArray count] - 1))
    {
        return YES;
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"GoToWeb"])
    {
        // Get reference to the destination view controller
        FlickrImageViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        if(vc)
        {
            NSIndexPath * indexPath = [imageTable indexPathForSelectedRow];
            selectedImageIndex = indexPath.row;
            FlickrPictureEntry * selectedItem = [pictureItemArray objectAtIndex: indexPath.row];
            if(selectedItem)
            {
                vc.displayPicture = selectedItem;
            } else {
                NSLog( @"no selected item for this segue" );
            }
        }
    }
}

- (void) updateTableView: (NSArray *) indexPaths
{
    UIViewAnimationOptions animationOptions = UITableViewRowAnimationRight;
    
    // [self.tableView beginUpdates];
    
    [imageTable insertRowsAtIndexPaths: indexPaths withRowAnimation: animationOptions];
    
    // [self.tableView endUpdates];
    lastUpdatedLabel.text = [NSString stringWithFormat: @"Feed Updated: %@", [timeFormatter stringFromDate: [NSDate date]]];
}

- (void) newPictureEntriesArrived: (NSNotification *) notification
{
    NSArray * arrayOfNewEntries = [[notification userInfo] objectForKey: @"new_picture_array"];
    {
        // might be useful to put another check in here to make certain we don't
        // accidentally insert duplicate entries
        if(pictureItemArray == NULL)
        {
            pictureItemArray = [[NSMutableArray alloc] initWithCapacity: [arrayOfNewEntries count]];
        }
        
        if(pictureItemArray)
        {
            NSMutableArray * indexPathArray = [[NSMutableArray alloc] initWithCapacity: [arrayOfNewEntries count]];
            // get the last row in the current pictureItemArray
            NSInteger lastRow = [pictureItemArray count];
            
            [pictureItemArray addObjectsFromArray: arrayOfNewEntries];
            
            // and build an array of index paths for the new cells to be rendered
            for(NSInteger index = 0; index < [arrayOfNewEntries count]; index++)
            {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow: index + lastRow inSection: 0];
                if(indexPath)
                {
                    [indexPathArray addObject: indexPath];
                }
            }
            
            // can only do this UI magic on the main thread
            [self performSelectorOnMainThread: @selector(updateTableView:) withObject: indexPathArray waitUntilDone:NO];
        }
        
        NSLog( @"pictureItemArray count %d", [pictureItemArray count]);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(pictureItemArray)
    {
        return([pictureItemArray count]);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // because we're using a reuse identifier we entered into the storyboard
    // dequeuReusableCellWithIdentifier always returns a cell, brand new or reused...
    // how nice!
    
    static NSString *CellIdentifier = @"ImageTableViewCell";
    FlickrPictureEntry *item=[pictureItemArray objectAtIndex:indexPath.row];
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSLog( @"surprise, we actually got a NULL when requesting a table view cell");
    }
    
    if (cell)
    {
        // NSLog( @"cell %p has bigImageView %p", cell, cell.bigImageView);
        
        // how nice, iOS 6 gives us a "scale" property...
        cell.bigImageView.image = [UIImage imageWithData: item.thumbnailData scale: 0.20];
    }
    return(cell);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // FlickrPictureEntry * item = [pictureItemArray objectAtIndex: indexPath.row];
    // NSLog( @"url for row %d is %@", indexPath.row, [item.urlToImage absoluteString]);
    
    [self.navigationController setTitle: @"Image List"];
    
    @try {
        [self performSegueWithIdentifier: @"GoToWeb" sender: self];
    }
    @catch( NSException * e)
    {
        NSLog( @"exception is %@", [e description] );
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [imageTable deselectRowAtIndexPath: indexPath animated: YES];
}


@end
