//
//  SPImage.m
//  SimplePicture
//
//  Created by Scott Stevenson on 9/28/07.
//
//  Personal site: http://theocacao.com/
//  Post for this sample: http://theocacao.com/document.page/497
//
//  The code in this project is intended to be used as a learning
//  tool for Cocoa programmers. You may freely use the code in
//  your own programs, but please do not use the code as-is in
//  other tutorials.

#import "SPImage.h"


@implementation SPImage

- (id)init
{
    if (self = [super init])
    {
        [self setTitle:@"Picture"];
        [self setImagePath:nil];
        [self setDefaultThumbnail:nil];
    }
    return self;
}

- (void)dealloc
{
    [self setTitle:nil];
    [self setImagePath:nil];
    [self setDefaultThumbnail:nil];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (NSString*)title
{
    return _title;
}

- (void)setTitle:(NSString*)aValue
{
    NSString* oldTitle = _title;
    _title = [aValue copy];
    [oldTitle release];
}

- (NSString*)imagePath
{
    return _imagePath;
}

- (void)setImagePath:(NSString*)aValue
{
    NSString* oldImagePath = _imagePath;
    _imagePath = [aValue copy];
    [oldImagePath release];
}

- (NSImage*)defaultThumbnail
{
    return _defaultThumbnail;
}

- (void)setDefaultThumbnail:(NSImage*)aValue
{
    NSImage* oldDefaultThumbnail = _defaultThumbnail;
    _defaultThumbnail = [aValue retain];
    [oldDefaultThumbnail release];
}

@end
