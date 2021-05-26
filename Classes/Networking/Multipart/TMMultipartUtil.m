//
//  TMMultipartUtil.m
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 18.05.2021.
//

#import "TMMultipartUtil.h"
#import "TMMultipartConstants.h"

@implementation TMMultipartUtil

+ (NSURL *)createTempFileWithError:(NSError **)error {
    NSURL *tempDirectory = [[[NSFileManager defaultManager] temporaryDirectory] URLByAppendingPathComponent:TMMultipartFormDirectory];
    NSString *fileName = [NSUUID UUID].UUIDString;
    NSURL *fileURL = [tempDirectory URLByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] createDirectoryAtURL:tempDirectory withIntermediateDirectories:YES attributes:nil error:error];
    if (error && *error) {
        return nil;
    }
    return fileURL;
}

@end
