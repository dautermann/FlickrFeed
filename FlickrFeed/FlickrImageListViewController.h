//
//  FlickrImageListViewController.h
//  FlickrFeed
//
//  Created by Michael Dautermann on 12/6/12.
//  Copyright (c) 2012 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPictureEntry.h"

@interface FlickrImageListViewController : UIViewController
{
    NSMutableArray * pictureItemArray;
    NSDateFormatter * timeFormatter;
    IBOutlet UITableView * imageTable;
    IBOutlet UILabel * lastUpdatedLabel;
    NSInteger selectedImageIndex;
}

- (FlickrPictureEntry *) getPreviousEntry;
- (FlickrPictureEntry *) getNextEntry;
- (BOOL) previousEntryAvailable;
- (BOOL) nextEntryAvailable;

@end
