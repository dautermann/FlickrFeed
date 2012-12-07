//
//  FlickrPictureFeed.m
//  FlickrFeed
//
//  Created by Michael Dautermann on 12/5/12.
//  Copyright (c) 2012 Michael Dautermann. All rights reserved.
//

#import "FlickrPictureFeed.h"
#import "FlickrPictureEntry.h"
#import "RssParser.h"
#import "RssItem.h"

@interface FlickrPictureFeed ()
- (void) getNewestPictures;
- (void) rssWorkTimerThread: (NSTimer *) theTimer;
@end

@implementation FlickrPictureFeed

- (NSString *) getSubstringFrom: (NSString *) originalString forThisKeyword: (NSString *) lookingFor
{
    NSString * substring = NULL;
    NSRange rangeOfWhatWeWant = [originalString rangeOfString: [NSString stringWithFormat: @"%@=\"", lookingFor] options: NSCaseInsensitiveSearch];
    if(rangeOfWhatWeWant.location != NSNotFound)
    {
        NSInteger whatWeWantsStartsHere = rangeOfWhatWeWant.location + rangeOfWhatWeWant.length;
        NSInteger remainingCharactersInString = [originalString length] - whatWeWantsStartsHere;

        NSRange endOfWhatWeWant = [originalString rangeOfString: @"\"" options: NSCaseInsensitiveSearch range: NSMakeRange(whatWeWantsStartsHere,remainingCharactersInString)];
        
        substring = [originalString substringWithRange: NSMakeRange(whatWeWantsStartsHere, endOfWhatWeWant.location - whatWeWantsStartsHere)];
    }
    return(substring);
}

- (NSString *) getTitleFrom: (NSString *) originalString
{
    return([self getSubstringFrom: originalString forThisKeyword: @"title"]);
}

- (NSString *) getImageURLFrom: (NSString *) originalString
{
    return([self getSubstringFrom: originalString forThisKeyword: @"img src"]);
}

- (NSString *) getAuthorFrom: (NSString *) originalString
{
    NSString * substring = NULL;
    NSRange endOfSubString = [originalString rangeOfString: @"</a> posted a photo:"];
    if(endOfSubString.location != NSNotFound)
    {
        // work backwards from this point to find the "/>" bit that indicates the start of the name
        NSRange beginningOfSubstring = [originalString rangeOfString: @"/\">" options: NSBackwardsSearch range: NSMakeRange(0, endOfSubString.location)];
        if(beginningOfSubstring.location != NSNotFound)
        {
            NSInteger whatWeWantStartsHere = beginningOfSubstring.location + beginningOfSubstring.length;
            NSInteger whatWeWantEndsHere = endOfSubString.location - whatWeWantStartsHere;
            substring = [originalString substringWithRange: NSMakeRange(whatWeWantStartsHere, whatWeWantEndsHere)];
        }
    }
    return(substring);
}

- (FlickrPictureEntry *) getNewFlickrPictureFromRssItem: (RssItem *) rssItem
{
    // create a new FlickrPictureEntry based on the contents of the RSS item
    FlickrPictureEntry * newEntry = [[FlickrPictureEntry alloc] init];
    
    if(newEntry)
    {
        NSString * urlString = [self getImageURLFrom: rssItem.content];
        newEntry.title = [self getTitleFrom: rssItem.content];
        newEntry.author = [self getAuthorFrom: rssItem.content];
        if(urlString)
        {
            newEntry.urlToImage = [[NSURL alloc] initWithString: urlString];
            
#if 1 // we're doing this synchronously... this sucks!!
            if(newEntry.urlToImage)
            {
                NSData * dataForImage = [[NSData alloc] initWithContentsOfURL: newEntry.urlToImage];
                if(dataForImage)
                {
                    newEntry.thumbnailData = dataForImage;
                }
            }
        }
#endif
    }
    return(newEntry);
}
- (void) getNewestPictures
{
    NSMutableArray * newestPictureArray = NULL;
    NSURL *url = [[NSURL alloc] initWithString: @"http://api.flickr.com/services/feeds/photos_public.gne"];
    if(url)
    {
        NSData * contentsOfURL = [[NSData alloc] initWithContentsOfURL: url];
        if(contentsOfURL)
        {
            RssParser * parser = [[RssParser alloc] initWithData: contentsOfURL];
            if(parser)
            {
                [parser parse];
                
                if([parser.items count] > 0)
                {
                    newestPictureArray = [[NSMutableArray alloc] initWithCapacity: [parser.items count]];
                    if(newestPictureArray)
                    {
                        // now get the parser items and convert them into FlickerPictureObjects
                        for(RssItem * rssItem in parser.items)
                        {
                            FlickrPictureEntry * newEntry = [self getNewFlickrPictureFromRssItem: rssItem];
                            if(newEntry)
                                [newestPictureArray addObject: newEntry];
                        }
                        
                        NSDictionary * dictionaryToSend = [NSDictionary dictionaryWithObject: newestPictureArray forKey: @"new_picture_array" ];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"new_pictures_have_arrived" object:self userInfo: dictionaryToSend];
                    }
                }
            }
        }
    }
}

- (void) awakeFromNib
{
    NSLog( @"feed awakefromnib");
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(rssWorkTimerThread:) userInfo:NULL repeats:YES];
}

- (void) rssWorkTimerThread: (NSTimer *) theTimer
{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.myke.backgroundQueue", NULL);
    dispatch_async(backgroundQueue, ^{
        @autoreleasepool {
            //Your code to be run in background
            [self getNewestPictures];
        }
    });
}

#if DEADCODE
- (void) rssFeedThread: (id) anArgument
{
    @autoreleasepool {
        FlickrPictureFeed * myself = (FlickrPictureFeed *) anArgument;
        [NSTimer scheduledTimerWithTimeInterval:5.0f target:myself selector:@selector(getNewestPictures:) userInfo:NULL repeats:YES];
    }
}

// the magic of singletons!
+ (FlickrPictureFeed *) sharedInstance
{
	static FlickrPictureFeed *sharedInstance = NULL;
	
	if( NULL == sharedInstance )
	{
		sharedInstance = [[ self alloc ] init ];
	}
	return sharedInstance;
}

+ (void) startUpRSSFeed
{

    FlickrPictureFeed * feedObject = [FlickrPictureFeed sharedInstance];
    if(feedObject)
    {
        // probably should GCD this??
		[ NSThread detachNewThreadSelector: @selector(rssFeedThread:) toTarget: feedObject withObject: NULL ];
    }
}
#endif

@end
