//
//  ImageTableViewCell.h
//  FlickrFeed
//
//  Created by Michael Dautermann on 12/5/12.
//  Copyright (c) 2012 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell
{
    IBOutlet UIImageView * _bigImageView;
}

@property (strong) UIImageView * bigImageView;

@end
