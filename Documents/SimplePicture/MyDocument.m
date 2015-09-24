//
//  MyDocument.m
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

#import "MyDocument.h"
#import "SPImage.h"
#import "NSImage-Extras.h"

@implementation MyDocument

- (id)init
{
    
    if (self = [super init])
    {
        // this is an array of UTI file types provided by the ImageIO framework.
        // see http://developer.apple.com/macosx/uniformtypeidentifiers.html for
        // more info on UTI types.

        NSArray* types = (NSArray*)CGImageSourceCopyTypeIdentifiers();
        [self setImageFileTypes:types];
        [types release];
        
        [self setPathForImages:nil];
        [self setImageList:[NSArray array]];
        [self setImportingImages:NO];
    }
    return self;
}

- (void)dealloc
{

    [self setPathForImages:nil];
    [self setImageFileTypes:nil];
    [self setImageList:nil];
    
    [super dealloc];
}




#pragma mark -
#pragma mark Utilities

- (void)threadedReloadImageList
{
    // since this method should be run in a seperate background
    // thread, we need to create our own NSAutoreleasePool, then
    // release it at the end.
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    // get the source path for the images, and an enumerator at
    // that path so we can loop throught all the files
    NSString *pathForImages = [self pathForImages];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator* e = [fileManager enumeratorAtPath:pathForImages];

    // a list of UTI types which NSImage is likely able to open
    NSArray* imageFileTypes = [self imageFileTypes];
    
    // the list of images we'll loaded from this directory
    NSMutableArray* imageList = [[NSMutableArray alloc] init];

    // loop through each file name at this locaiton
    NSString* fileName;
    NSString* fullPath;
    
    while ( fileName = [e nextObject] )
    {
        fullPath = [pathForImages stringByAppendingPathComponent:fileName];

        // skip anything which is not a regular file
        NSDictionary* attributes = [fileManager fileAttributesAtPath:fullPath traverseLink:NO];
        if ( [attributes objectForKey:NSFileType] != NSFileTypeRegular ) continue;

        // skip anything which is not an image type
        NSString* utiTypeForFile = (NSString*)UTTypeCreatePreferredIdentifierForTag (
            kUTTagClassFilenameExtension,
            (CFStringRef)[fileName pathExtension],
            NULL);

        if ( [imageFileTypes containsObject:utiTypeForFile] == NO ) continue;


        // try to load the file as an NSImage, and continue only if it's valid
        NSImage* sourceImage = [[NSImage alloc] initByReferencingFile:fullPath];
        if ([sourceImage isValid])
        {
            // drawing the entire, full-sized image every time the table view
            // scrolls is way too slow, so instead will draw a thumbnail version
            // into a separate NSImage, which acts as a cache
            
            NSImage* thumbnail = [sourceImage imageByScalingProportionallyToSize:NSMakeSize(64,64)];
                    
            // create a new SPImage
            SPImage* spImage = [[SPImage alloc] init];
            
            // set the path of the on-disk image and our cache instance
            [spImage setTitle:[fileName stringByDeletingPathExtension]];
            [spImage setImagePath:fullPath];
            [spImage setDefaultThumbnail:thumbnail];

            // add to the SPImage array
            [imageList addObject:spImage];

            // adding an object to an array retains it, so we
            // can release our reference
            [spImage release];
        }

        // now release the image we created.
        [sourceImage release];        
    }
            

    // we want to actually set the new value in the main thread, to
    // avoid any mix-ups with Cocoa Bindings
    [self performSelectorOnMainThread: @selector(setImageList:)
                           withObject: imageList
                        waitUntilDone: NO];
                        
    [imageList release];
    
    // remember to release the pool    
    [pool release];
}


#pragma mark -
#pragma mark Accessors

- (BOOL)importingImages
{
    return _importingImages;
}

- (void)setImportingImages:(BOOL)newImportingImages
{
    _importingImages = newImportingImages;
}

- (NSArray*)imageFileTypes
{
    return _imageFileTypes;
}

- (void)setImageFileTypes:(NSArray*)aValue
{
    NSArray* oldImageFileTypes = _imageFileTypes;
    _imageFileTypes = [aValue copy];
    [oldImageFileTypes release];
}

- (NSString*)pathForImages
{
    return _pathForImages;
}

- (void)setPathForImages:(NSString*)aValue
{
    NSString* oldPathForImages = _pathForImages;
    _pathForImages = [aValue copy];
    [oldPathForImages release];
}

- (NSMutableArray*)imageList
{
    return _imageList;
}

- (void)setImageList:(NSArray*)aValue
{
    NSMutableArray* oldImageList = _imageList;
    _imageList = [aValue mutableCopy];
    [oldImageList release];
    
    [self setImportingImages:NO];
}


#pragma mark -
#pragma mark Standard NSDocument

// we don't need to override any of these, so just comment them out
// so it's clear we're using the versions provided by NSDocument


- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)type
{
    // this is deprecated. use readFromURL instead.
    
    [self setPathForImages:fileName];   

    [self setImportingImages:YES];
    [NSThread detachNewThreadSelector:@selector(threadedReloadImageList) toTarget:self withObject:nil];

    return YES;
}


/*

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API -dataOfType:error:.  In this case you can also choose to override -writeToURL:ofType:error:, -fileWrapperOfType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API readFromData:ofType:error:.  In this case you can also choose to override -readFromURL:ofType:error: or -readFromFileWrapper:ofType:error: instead.
    
    return YES;
}
*/

@end
