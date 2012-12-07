//
//  RssParser.m
//  SplitViewTest
//
//  This code was not created by Michael Dautermann on 02/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RssParser.h"


@implementation RssParser

@synthesize data;
@synthesize items;
@synthesize delegate;

-(id) initWithData:(NSData*) theData
{
    if ( (self=[super init]) != nil )
    {
        self.data=theData;
        items=[[NSMutableArray alloc]init];
    }
    return self;
}

-(id) init
{
    return [self initWithData:nil];
}

-(void) parse
{
    currentItem=nil;
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"parsing started");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // NSLog(@"parsing done");
    // callSelectorOnDelegate(@selector(finishedParsing), delegate);
    [delegate finishedParsing];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    // NSLog(@"started %@ uri %@ q %@ att %@",elementName,namespaceURI,qualifiedName,attributeDict);
    
    if ([elementName isEqualToString:@"entry"]==YES)
    {
        currentItem=[[RssItem alloc] init];
    }
    else if (currentItem!=nil)
    {
        if ([elementName isEqualToString:@"title"]==YES)
        {
            isTitle=YES;
        }
        else if ([elementName isEqualToString:@"hpac:nid"]==YES)
        {
            isNid=YES;
        }
        else if ([elementName isEqualToString:@"pubDate"]==YES)
        {
            isDate=YES;
        }
        else if ([elementName isEqualToString:@"category"]==YES)
        {
            isCategory=YES;
        }
        else if ([elementName isEqualToString:@"description"]==YES)
        {
            isDescription=YES;
        }
        else if ([elementName isEqualToString:@"link"]==YES)
        {
            isLink=YES;
        }
        else if ([elementName isEqualToString:@"content"] == YES)
        {
            isContent=YES;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    NSLog(@"ended %@ uri %@ q %@",elementName,namespaceURI,qName);
    
    if ([elementName isEqualToString:@"entry"]==YES)
    {
        [items addObject:currentItem];
        currentItem=nil;
    }
    else if (currentItem!=nil)
    {
        if ([elementName isEqualToString:@"title"]==YES)
        {
            [currentItem setTitle:characters];
            isTitle=NO;
        }
        else if ([elementName isEqualToString:@"hpac:nid"]==YES)
        {
            [currentItem setNid:characters];
            isNid=NO;
        }
        else if ([elementName isEqualToString:@"pubDate"]==YES)
        {
            [currentItem setPubDate:characters];
            isDate=NO;
        }
        else if ([elementName isEqualToString:@"category"]==YES)
        {
            [currentItem setCategory:characters];
            isCategory=NO;
        }
        else if ([elementName isEqualToString:@"description"]==YES)
        {
            [currentItem setDescriptionHTML:characters];
            isDescription=NO;
        }
        else if ([elementName isEqualToString:@"link"]==YES)
        {
            [currentItem setLink:characters];
            isLink=NO;
        }
        else if ([elementName isEqualToString:@"content"]==YES)
        {
            [currentItem setContent:characters];
            isContent=NO;
        }
        else
        {
            [currentItem.others setObject:characters forKey:elementName];
        }
    }
    if (characters!=nil)
    {
        characters=nil;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"error occured %@",parseError);
    // callSelectorOnDelegateWithObject(@selector(failedParsingWithError:), delegate, parseError);
    [delegate failedParsingWithError: parseError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError
{
    NSLog(@"validation error %@",validError);
    // callSelectorOnDelegateWithObject(@selector(failedParsingWithError:), delegate, validError);
    [delegate failedParsingWithError: validError];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"chars %@",string);
    
    if (characters==nil)
    {
        characters=[[NSMutableString alloc] initWithString:@""];
    }
    else
    {
        [characters appendString:string];
    }
}

@end
