//
//  MaxFusionFilter.m
//  MaxFusion
//
//  Copyright (c) 2013 Stephan. All rights reserved.
//

#import "MaxFusionFilter.h"

@implementation MaxFusionFilter

+ (void)maxOfBuffer:(float*)bufferB and:(float*)bufferA withWidth:(long)width withHeight:(long)height;
{
    long i;
    
    for(i = 0; i < width*height; i++, bufferA++, bufferB++)
        *bufferA = (*bufferA > *bufferB) ? *bufferA : *bufferB;
        
}

+ (void)maxOfDCMPix:(DCMPix*)pixB and:(DCMPix*)pixA;
{
    float *fImageA, *fImageB;
    fImageA = [pixA fImage];
    fImageB = [pixB fImage];
    
    long width = ([pixA pwidth]<[pixB pwidth])? [pixA pwidth] : [pixB pwidth] ;
    long height = ([pixA pheight]<[pixB pheight])? [pixA pheight] : [pixB pheight] ;
    [MaxFusionFilter maxOfBuffer: fImageB and: fImageA withWidth: width withHeight: height];
}


- (void) initPlugin
{
}

- (long) filterImage:(NSString*) menuName
{
    DCMView *fixedView   = [viewerController imageView];
    DCMView *draggedView = [[viewerController blendedWindow] imageView];

    NSArray *imagesA     = [fixedView dcmPixList];
    NSArray *imagesB     = [draggedView dcmPixList];
    
    for(NSUInteger i = 0; i < [imagesA count]; i++)
    {
        DCMPix *imageA = [imagesA objectAtIndex: i];
        DCMPix *imageB = [imagesB objectAtIndex: i];
        [MaxFusionFilter maxOfDCMPix: imageB and: imageA];
    }
 
    [[viewerController blendedWindow] needsDisplayUpdate];

    return 0;
}

@end
