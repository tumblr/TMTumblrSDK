//
//  TMMultipartUtil.h
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 18.05.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMMultipartUtil : NSObject

/// Creates a file under `<temp-directory>/com.tumblr.sdk/multipart.form`
/// @param error Encountered error.
+ (NSURL *_Nullable)createTempFileWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
