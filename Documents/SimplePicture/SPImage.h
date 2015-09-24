//
//  SPImage.h
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


// a very simple data class. just a light reference to an
// image on disk.

@interface SPImage : NSObject {

    NSString * _title;
    NSString * _imagePath;
    NSImage  * _defaultThumbnail;
}

#pragma mark Accessors

- (NSString*)title;
- (void)setTitle:(NSString*)aValue;

- (NSString*)imagePath;
- (void)setImagePath:(NSString*)aValue;

- (NSImage*)defaultThumbnail;
- (void)setDefaultThumbnail:(NSImage*)aValue;

@end
