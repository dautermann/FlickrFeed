//
//  FlickrPictureEntry.h
//  FlickrFeed
//
//  Created by Michael Dautermann on 12/5/12.
//  Copyright (c) 2012 Michael Dautermann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPictureEntry : NSObject

@property (strong) NSString * title;
@property (strong) NSString * author;
@property (strong) NSURL * urlToImage;
@property (strong) NSData * thumbnailData;

@end
