//
//  ImageTableViewCell.m
//  FlickrFeed
//
//  Created by Michael Dautermann on 12/5/12.
//  Copyright (c) 2012 Michael Dautermann. All rights reserved.
//

#import "ImageTableViewCell.h"

@implementation ImageTableViewCell

@synthesize bigImageView = _bigImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
