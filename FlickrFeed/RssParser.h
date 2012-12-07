//
//  RssParser.h
//  SplitViewTest
//
//  This code was not created by Michael Dautermann on 02/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RssItem.h"
//#import "UtilityFunctions.h"

@protocol RssParserDelegate <NSObject>

-(void) finishedParsing;
-(void) failedParsingWithError:(NSError*) error;

@end

@interface RssParser : NSObject <NSXMLParserDelegate>{
    NSData *data;
    NSMutableArray *items;
    RssItem *currentItem;
    NSMutableString *characters;
    __weak id <RssParserDelegate> delegate;
    
    BOOL isTitle;
    BOOL isNid;
    BOOL isDate;
    BOOL isCategory;
    BOOL isDescription;
    BOOL isLink;
    BOOL isContent;
}

@property (nonatomic,retain) NSData *data;
@property (nonatomic,retain) NSMutableArray *items;
@property (weak) id <RssParserDelegate> delegate;

-(id) initWithData:(NSData*) data;
-(void) parse;

@end
