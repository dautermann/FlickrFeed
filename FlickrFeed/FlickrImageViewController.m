//
//  FlickrImageViewController.m
//  FlickrFeed
//
//  Created by Michael Dautermann on 12/5/12.
//  Copyright (c) 2012 Michael Dautermann. All rights reserved.
//

#import "FlickrImageViewController.h"
#import "FlickrImageListViewController.h"

@interface FlickrImageViewController ()

@end

@implementation FlickrImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)displayCurrentPicture
{
    // concept for this stolen from
    // http://stackoverflow.com/questions/4667614/uiwebview-with-just-an-image-that-should-fit-the-whole-view
    NSString *htmlString = [NSString stringWithFormat:
                            @"<html>"
                            "<head>"
                            "<script type=\"text/javascript\" >"
                            "function display(img){"
                            "var imgOrigH = document.getElementById('image').offsetHeight;"
                            "var imgOrigW = document.getElementById('image').offsetWidth;"
                            "var bodyH = window.innerHeight;"
                            "var bodyW = window.innerWidth;"
                            "if((imgOrigW/imgOrigH) > (bodyW/bodyH))"
                            "{"
                            "document.getElementById('image').style.width = bodyW + 'px';"
                            "document.getElementById('image').style.top = (bodyH - document.getElementById('image').offsetHeight)/2  + 'px';"
                            "}"
                            "else"
                            "{"
                            "document.getElementById('image').style.height = bodyH + 'px';"
                            "document.getElementById('image').style.marginLeft = (bodyW - document.getElementById('image').offsetWidth)/2  + 'px';"
                            "}"
                            "}"
                            "</script>"
                            "</head>"
                            "<body style=\"margin:0;width:100%;height:100%;\" >"
                            "<img id=\"image\" src=\"%@\" onload=\"display()\" style=\"position:relative\" />"
                            "</body>"
                            "</html>",[self.displayPicture.urlToImage absoluteString]
                            ];
    
    
    [fullSizeView loadHTMLString:htmlString baseURL:nil];
    authorLabel.text = self.displayPicture.author;
    titleLabel.text = self.displayPicture.title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayCurrentPicture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) leftArrowButtonTouched: (id) sender
{
    UINavigationController * nc = self.navigationController;
    FlickrImageListViewController * listVC = (FlickrImageListViewController *) [nc.viewControllers objectAtIndex: 0];
    if(listVC)
    {
        self.displayPicture = [listVC getPreviousEntry];
        [self displayCurrentPicture];
    }
}

- (IBAction) rightArrowButtonTouched: (id) sender
{
    UINavigationController * nc = self.navigationController;
    FlickrImageListViewController * listVC = (FlickrImageListViewController *) [nc.viewControllers objectAtIndex: 0];
    if(listVC)
    {
        self.displayPicture = [listVC getNextEntry];
        [self displayCurrentPicture];
    }
}

@end
