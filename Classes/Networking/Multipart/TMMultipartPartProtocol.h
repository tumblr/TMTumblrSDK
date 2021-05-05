//
//  TMMultipartPartProtocol.h
//  Pods
//
//  Created by Pinar Olguc on 5.05.2021.
//

@protocol TMMultipartPartProtocol <NSObject>

@property (nonatomic, readonly) UInt64 contentLength;
@property (nonatomic, nonnull, copy, readonly) NSString *name;
@property (nonatomic, nullable, copy, readonly) NSString *fileName;
@property (nonatomic, nonnull, copy, readonly) NSString *contentType;
@property (nonatomic) BOOL hasTopBoundary;
@property (nonatomic) BOOL hasBottomBoundary;

@end
