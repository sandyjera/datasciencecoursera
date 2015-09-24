//
//  MyDocument.h
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


#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
    IBOutlet NSImageView *mainImageView;
    
    NSArray* _imageFileTypes;
    NSString* _pathForImages;
    NSMutableArray * _imageList;
    BOOL _importingImages;
}


#pragma mark Utilities

// runs through all the images in the given folder
// (using pathForImages) and sets them as the new
// array for imageList. intended to be run in the
// background, so sets up an NSAutoreleasePool.
- (void)threadedReloadImageList;

#pragma mark Accessors

// a list of UTI types that we can probably open with NSImage.
// see http://developer.apple.com/macosx/uniformtypeidentifiers.html for
// more info on UTI types.
- (NSArray*)imageFileTypes;
- (void)setImageFileTypes:(NSArray*)aValue;

// the path of the folder that we'll load images from
- (NSString*)pathForImages;
- (void)setPathForImages:(NSString*)aValue;

// the getter returns an NSMutableArray but the setter
// takes a regular NSArray. That allows us to accept
// either kind of array as input.
- (NSMutableArray*)imageList;
- (void)setImageList:(NSArray*)aValue;

// a simple BOOL which states if we're busy loading images.
// from a folder. this is what the spinner's animate property
// is bound to.
- (BOOL)importingImages;
- (void)setImportingImages:(BOOL)newImportingImages;

@end
