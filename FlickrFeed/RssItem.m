//
//  RssItem.m
//  SplitViewTest
//
//  This code was not created by Michael Dautermann on 02/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RssItem.h"


@implementation RssItem

@synthesize title;
@synthesize nid;
@synthesize pubDate;
@synthesize category;
@synthesize descriptionHTML;
@synthesize others;
@synthesize link;
@synthesize content;

-(id) init
{
    if ( (self=[super init]) !=nil ) 
    {
        others=[[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString*) description
{
    NSMutableString *string=[[NSMutableString alloc]init];
    [string appendFormat:@"title %@, nid %@, date %@, cate %@,link %@\n",title,nid,pubDate,category,link];
    [string appendFormat:@"desc %@\n",descriptionHTML];
    [string appendFormat:@"other %@",others];
    return string;
}

@end
