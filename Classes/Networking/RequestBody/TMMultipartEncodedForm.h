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
@property (nonatomic, readonly, nonnull) NSURL *fileURL;

- (nonnull instancetype)initWithData:(nullable NSData *)data
                             fileURL:(nonnull NSURL *)fileURL;

- (nonnull instancetype)initWithData:(nullable NSData *)data;

@end

NS_ASSUME_NONNULL_END
