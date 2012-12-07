//
//  RssItem.h
//  SplitViewTest
//
//  This code was not created by Michael Dautermann on 02/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RssItem : NSObject {
    NSString *title;
    NSString *nid;
    NSString *pubDate;
    NSString *category;
    NSString *descriptionHTML;
    NSString *link;
    NSString *content;
    NSMutableDictionary *others;
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *nid;
@property (nonatomic,retain) NSString *pubDate;
@property (nonatomic,retain) NSString *category;
@property (nonatomic,retain) NSString *descriptionHTML;
@property (nonatomic,retain) NSString *link;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSMutableDictionary *others;

@end
