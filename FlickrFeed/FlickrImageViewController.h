//
//  FlickrImageViewController.h
//  FlickrFeed
//
//  Created by Michael Dautermann on 12/5/12.
//  Copyright (c) 2012 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPictureEntry.h"

@interface FlickrImageViewController : UIViewController
{
    IBOutlet UIWebView * fullSizeView;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * titleLabel;
}

@property (strong) FlickrPictureEntry * displayPicture;

- (IBAction) leftArrowButtonTouched: (id) sender;
- (IBAction) rightArrowButtonTouched: (id) sender;

@end
