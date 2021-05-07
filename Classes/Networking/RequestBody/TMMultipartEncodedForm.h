//
//  TMMultipartEncodedForm.h
//  Pods-ExampleiOS
//
//  Created by Pinar Olguc on 7.05.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMMultipartEncodedForm : NSObject

@property (nonatomic, readonly, nullable) NSData *data;
@property (nonatomic, readonly, nullable) NSURL *fileURL;

- (nonnull instancetype)initWithData:(nullable NSData *)data
                             fileURL:(nullable NSURL *)fileURL;

@end

NS_ASSUME_NONNULL_END
