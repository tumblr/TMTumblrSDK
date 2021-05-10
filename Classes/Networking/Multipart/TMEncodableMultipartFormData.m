//
//  TMEncodableMultipartFormData.m
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 5.05.2021.
//

#import "TMEncodableMultipartFormData.h"
#import "TMMultipartPartProtocol.h"
#import "TMInputStreamMultipartPart.h"
#import "TMMultipartConstants.h"

NSString * const TMMultipartFormErrorDomain = @"com.tumblr.sdk.multipartform";

// Value taken from Apple doc: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Streams/Articles/ReadingInputStreams.html
NSUInteger const TMMaxBufferSize = 1024;

@interface TMEncodableMultipartFormData ()

@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSString *boundary;
@property (nonatomic) NSMutableArray <id<TMMultipartPartProtocol>> *parts;

@end

@implementation TMEncodableMultipartFormData

- (instancetype)initWithFileManager:(NSFileManager *)fileManager boundary:(NSString *)boundary {
    NSParameterAssert(fileManager);
    NSParameterAssert(boundary);
    self = [super init];
    
    if (self) {
        _fileManager = fileManager;
        _boundary = [boundary copy];
        _parts = [NSMutableArray new];
    }
    
    return self;
}

// MARK: - Public methods

- (void)appendFileURL:(NSURL *)fileURL
                 name:(NSString *)name
          contentType:(NSString *)contentType
                error:(NSError **)error {

    // Is the file name is valid?
    NSString *fileName = fileURL.lastPathComponent;
    if (!(fileName.length > 0)) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeFileNameNotValid userInfo:nil];
        return;
    }
    
    // Does the fileURL have `file` scheme?
    if (!fileURL.isFileURL) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeURLNotUsingFileScheme userInfo:nil];
        return;
    }

    // Is the URL points to a file or a directory?
    BOOL isDirectory = false;
    if ([self.fileManager fileExistsAtPath:fileURL.path isDirectory:&isDirectory] && isDirectory) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeFileIsDirectory userInfo:nil];
        return;
    }
    
    // Is the file reachable?
    NSError *reachableError;
    if (![fileURL checkPromisedItemIsReachableAndReturnError:&reachableError]) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeFileNotReachable userInfo:reachableError.userInfo];
        return;
    }

    // File size can be captured?
    NSNumber *fileSizeNumber = [[self.fileManager attributesOfItemAtPath:fileURL.path error:nil] objectForKey:NSFileSize];
    if (!fileSizeNumber) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeFileSizeNotAvailable userInfo:nil];
        return;
    }
    UInt64 contentLength = fileSizeNumber.longLongValue;
    
    // Can we create the input stream?
    NSInputStream *inputStream = [[NSInputStream alloc] initWithURL:fileURL];
    if (!inputStream) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeInputStreamCreationFailed userInfo:nil];
        return;
    }
    
    [self appendInputStream:inputStream contentLength:contentLength name:name fileName:fileName contentType:contentType];
}

- (void)appendFilePath:(NSString *)filePath
                  name:(NSString *)name
           contentType:(NSString *)contentType
                 error:(NSError **)error {
    
    /// Create a URL with `file` scheme if it is not already
    NSURL *fileURL = [NSURL URLWithString:filePath];
    if (!fileURL.isFileURL) {
        fileURL = [NSURL fileURLWithPath:filePath];
    }
    
    NSError *fileError;
    [self appendFileURL:fileURL
                   name:name
            contentType:contentType
                  error:&fileError];
    if (fileError) {
        // If that fails somehow then fallback to the old mechanism and try appending the data instead.
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (!data) {
            *error = [NSError errorWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeInvalidFilePath userInfo:@{@"path":filePath}];
            return;
        }
        [self appendData:data
                       name:name
                   fileName:filePath
                contentType:contentType];
    }
}

- (void)appendData:(NSData *)data
              name:(NSString *)name
          fileName:(NSString *)fileName
       contentType:(NSString *)contentType {
    
    NSInputStream *inputStream = [[NSInputStream alloc] initWithData:data];
    [self appendInputStream:inputStream contentLength:data.length name:name fileName:fileName contentType:contentType];
}

- (void)appendInputStream:(NSInputStream *)inputStream
            contentLength:(UInt64)contentLength
                     name:(NSString *)name
                 fileName:(NSString *)fileName
              contentType:(NSString *)contentType {
    
    TMInputStreamMultipartPart *part = [[TMInputStreamMultipartPart alloc] initWithInputStream:inputStream name:name fileName:fileName contentType:contentType contentLength:contentLength];
    [self.parts addObject:part];
}

- (UInt64)totalContentLength {
    UInt64 result = 0;
    for (id<TMMultipartPartProtocol> part in self.parts) {
        result += part.contentLength;
    }
    return result;
}

- (void)encodeIntoFileWithURL:(NSURL *)targetFileURL error:(NSError **)error {
    if ([self.fileManager fileExistsAtPath:targetFileURL.path]) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeOutputFileAlreadyExists userInfo:nil];
        return;
    }
    if (!targetFileURL.isFileURL) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeOutputFileURLInvalid userInfo:nil];
        return;
    }
    
    NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:targetFileURL append:false];
    if (!outputStream) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeOutputStreamCreationFailed userInfo:nil];
        return;
    }
    
    [outputStream open];
        
    for (id<TMMultipartPartProtocol> part in self.parts) {
        [self writeBodyPart:part toOutputStream:outputStream error:error];
    }
    
    [self writeFinalBoundaryToOutputStream:outputStream error:error];
    
    [outputStream close];
}

- (NSData *)encodeIntoDataWithError:(NSError **)error {
    NSMutableData *data = [NSMutableData new];
        
    for (id<TMMultipartPartProtocol> part in self.parts) {
        [data appendData:[self buildDataForBodyPart:part error:error]];
    }
    [data appendData: [self.finalBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    return [NSData dataWithData:data];
}

- (NSData *)buildDataForBodyPart:(id<TMMultipartPartProtocol>)part error:(NSError **)error {
    NSMutableData *data = [NSMutableData new];

    // Write top boundary

    [data appendData: [self.topBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Write headers

    [data appendData: [[self headerTextForBodyPart:part] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Write streamable

    if ([part isKindOfClass: [TMInputStreamMultipartPart class]]) {
        TMInputStreamMultipartPart *streamblePart = (TMInputStreamMultipartPart *)part;
        NSData *partData = [self bodyDataFrom:streamblePart error:error];
        if (!partData) {
            return nil;
        }
        [data appendData:partData];
    }

    // Write bottom boundary
    
    [data appendData: [self.bottomBoundary dataUsingEncoding:NSUTF8StringEncoding]];

    return [NSData dataWithData:data];
}

// MARK: - Private methods

- (void)writeBodyPart:(id<TMMultipartPartProtocol>)part toOutputStream:(NSOutputStream *)outputStream error:(NSError **)error {
    
    // Write top boundary
    
    [self writeTopBoundaryForBodyPart:part toOutputStream:outputStream error:error];
    if (*error) {
        return;
    }
    
    // Write headers
    
    [self writeHeadersForBodyPart:part toOutputStream:outputStream error:error];
    if (*error) {
        return;
    }
    
    // Write streamable
    
    if ([part isKindOfClass: [TMInputStreamMultipartPart class]]) {
        TMInputStreamMultipartPart *streamblePart = (TMInputStreamMultipartPart *)part;
        [self writeBodyStreamForPart:streamblePart toOutputStream:outputStream error:error];
        if (*error) {
            return;
        }
    }
    
    // Write bottom boundary
    [self writeBottomBoundaryForBodyPart:part toOutputStream:outputStream error:error];
}

- (void)writeBodyStreamForPart:(TMInputStreamMultipartPart *)part toOutputStream:(NSOutputStream *)outputStream error:(NSError **)error {
    NSInputStream *inputStream = part.inputStream;
    [inputStream open];
    
    while (inputStream.hasBytesAvailable) {
        uint8_t buffer[TMMaxBufferSize];
        (void)memset(buffer, 0, TMMaxBufferSize);

        NSInteger bytesRead = [inputStream read:buffer maxLength:TMMaxBufferSize];
        if (inputStream.streamError) {
            *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeInputStreamReadFailed userInfo:inputStream.streamError.userInfo];
            return;
        }
        if (bytesRead > 0) {
            [self writeBuffer:buffer oflength:bytesRead toOutputStream:outputStream error:error];
        }
        else {
            break;
        }
    }
    
    [inputStream close];
}

- (NSData *)bodyDataFrom:(TMInputStreamMultipartPart *)part error:(NSError **)error {
    NSInputStream *inputStream = part.inputStream;
    [inputStream open];
    NSMutableData *data = [NSMutableData new];
    
    while ([inputStream hasBytesAvailable]) {
        uint8_t buffer[TMMaxBufferSize];
        (void)memset(buffer, 0, TMMaxBufferSize);
        NSInteger inputBytes = [inputStream read:buffer maxLength:TMMaxBufferSize];
        
        if (inputStream.streamError) {
            *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeEncodingFailed userInfo:inputStream.streamError.userInfo];
            return nil;
        }
        
        if (inputBytes > 0) {
            [data appendBytes:buffer length:inputBytes];
        }
        else {
            break;
        }
    }
    
    if (data.length != part.contentLength) {
        *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeUnexpectedInputLength userInfo:inputStream.streamError.userInfo];
        return nil;
    }
    
    [inputStream close];
    
    return [NSData dataWithData:data];
}

- (void)writeData:(NSData *)data toOutputStream:(NSOutputStream *)outputStream error:(NSError **)error {
    Byte *readBytes = (uint8_t *)[data bytes];
    NSUInteger length = data.length;
    Byte buffer[length];
    (void)memcpy(buffer, readBytes, length);
    [self writeBuffer:buffer oflength:length toOutputStream:outputStream error:error];
}

- (void)writeBuffer:(Byte *)buffer oflength:(NSUInteger)length toOutputStream:(NSOutputStream *)outputStream error:(NSError **)error {
        
    NSInteger bytesToWrite = length;
    while (bytesToWrite > 0 && outputStream.hasSpaceAvailable) {
        NSUInteger writtenLength = [outputStream write:buffer maxLength:length];
        if (outputStream.streamError) {
            *error = [[NSError alloc] initWithDomain:TMMultipartFormErrorDomain code:TMMultipartFormErrorTypeOutputStreamWriteFailed userInfo:outputStream.streamError.userInfo];
            return;
        }
        
        bytesToWrite -= writtenLength;

        if (bytesToWrite > 0) {
            (void)memcpy(buffer, buffer + writtenLength, bytesToWrite);
        }
    }
}

// MARK: -Boundary related

- (void)writeFinalBoundaryToOutputStream:(NSOutputStream *)outputStream error:(NSError **)error {
    [self writeData:[self.finalBoundary dataUsingEncoding:NSUTF8StringEncoding] toOutputStream:outputStream error:error];
}

- (void)writeTopBoundaryForBodyPart:(id<TMMultipartPartProtocol>)part toOutputStream:(NSOutputStream *)outputStream error:(NSError **)error {
    NSData *data = [self.topBoundary dataUsingEncoding:NSUTF8StringEncoding];
    [self writeData:data toOutputStream:outputStream error:error];
}

- (void)writeHeadersForBodyPart:(id<TMMultipartPartProtocol>)part toOutputStream:(NSOutputStream *)outputStream error:(NSError **)error {
    NSData *data = [[self headerTextForBodyPart:part] dataUsingEncoding:NSUTF8StringEncoding];
    [self writeData:data toOutputStream:outputStream error:error];
}

- (NSString *)headerTextForBodyPart:(id<TMMultipartPartProtocol>)part {
    NSMutableString *string = [[NSMutableString alloc] init];

    [string appendFormat:@"Content-Disposition: form-data; name=\"%@\"", part.name];
    if (part.fileName) {
        [string appendFormat:@"; filename=\"%@\"", part.fileName];
    }
    [string appendString:TMMultipartCRLF];
    [string appendFormat:@"Content-Type: %@", part.contentType];
    [string appendString:TMMultipartCRLF];
    [string appendString:TMMultipartCRLF];
    
    return [NSString stringWithString:string];
}

- (void)writeBottomBoundaryForBodyPart:(id<TMMultipartPartProtocol>)part toOutputStream:(NSOutputStream *)outputStream error:(NSError **)error {
    NSData *data = [self.bottomBoundary dataUsingEncoding:NSUTF8StringEncoding];
    [self writeData:data toOutputStream:outputStream error:error];
}

- (NSString *)bottomBoundary {
    return TMMultipartCRLF;
}

- (NSString *)topBoundary {
    NSString *prefixedBoundary = [@"--" stringByAppendingString:self.boundary];
    
    NSMutableString *topBoundary = [[NSMutableString alloc] init];
    [topBoundary appendString:prefixedBoundary];
    [topBoundary appendString:TMMultipartCRLF];
    return  topBoundary;
}

- (NSString *)finalBoundary {
    NSMutableString *string = [NSMutableString stringWithFormat:@"--%@--", self.boundary];
    [string appendString: TMMultipartCRLF];
    return [NSString stringWithString:string];
}

@end
