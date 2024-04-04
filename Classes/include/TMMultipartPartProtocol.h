//
//  TMMultipartPartProtocol.h
//  Pods
//
//  Created by Pinar Olguc on 5.05.2021.
//

/// Represents a model of `multipart/form-data` for uploads.
@protocol TMMultipartPartProtocol <NSObject>

/// Total length of the parts in bytes.
@property (nonatomic, readonly) NSUInteger contentLength;

/// `name` attribute value from `Content-Disposition` header.
@property (nonatomic, nonnull, copy, readonly) NSString *name;

/// `filename` attribute value from `Content-Disposition` header.
@property (nonatomic, nullable, copy, readonly) NSString *fileName;

/// `Content-Type` header value.
@property (nonatomic, nonnull, copy, readonly) NSString *contentType;

@end
