//
//  TestSDK.m
//  TestSDK
//
//  Created by Kato Hiroyuki on 11/5/13.
//  Copyright (c) 2013 Hiroyuki Kato. All rights reserved.
//

#import "TestSDK.h"

@interface TestSDK()

// ------------------------------
// private methods
// ------------------------------
- (void) handleResponse:(NSURL *)url
              response:(NSURLResponse *)response
                  data:(NSData *)data
                 error:(NSError *)error;
- (NSDictionary *)deviceInfo;
- (NSString *)generateUUID;
- (void)removeUUID;
- (NSString *)urlEncode:(NSString *)string;
- (NSString *)dic2json:(NSDictionary *)dict;
- (NSString *)generateQuery:(NSDictionary *)params;


// ------------------------------
// private properties
// ------------------------------
@property(retain) NSURL *url;
@property(retain) NSString *unique_user_id;


// ------------------------------
// private static variables
// ------------------------------
#define ENDPOINT_URL @"http://localhost:9292/api/v1/beacon"
#define HTTP_METHOD @"POST"
#define HEADER_NAME_CONTENT_TYPE @"application/x-www-form-urlencoded; charset=utf-8"
#define UUID_KEY @"com.devkato.mobilesdk.uuid.v1"
#define DEVELOPMENT

// ------------------------------
// private macros
// ------------------------------


#define SDK_DEBUG(msg) NSLog(@"[TestSDK:DEBUG] %@", msg)
#define SDK_INFO(msg) NSLog(@"[TestSDK:INFO] %@", msg)

/* System Versioning Preprocessor Macros */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@end


@implementation TestSDK

static TestSDK* shared = nil;

/* --------------------------------------------------------------------------------
 *
 * class(instance) initialization
 *
 -------------------------------------------------------------------------------- */
- (id)init {
  
  SDK_DEBUG(([NSString stringWithFormat:@"ENDPOINT_URL : %@", ENDPOINT_URL]));
  
  if (self = [super init]) {
    self.url = [NSURL URLWithString:ENDPOINT_URL];
    self.unique_user_id = [self generateUUID];
    
    SDK_DEBUG(([NSString stringWithFormat:@"uuid : %@", self.unique_user_id]));
  }
  
  return self;
}

// ==================================================
//
// public methods
//
// ==================================================

#pragma mark Singleton Methods

/* --------------------------------------------------------------------------------
 *
 * return singleton-object
 *
 * @return TestSDK object
 *
 -------------------------------------------------------------------------------- */
+ (id)sharedManager {
  
  @synchronized(self) {
    if (shared == nil) {
      shared = [[self alloc] init];
    }
  }
  
  return shared;
}

/* --------------------------------------------------------------------------------
 *
 * send beacon request to aggregation server
 *
 * @param json dictionary data for json
 *
 *
 * @return void
 *
 -------------------------------------------------------------------------------- */
- (void)sendData:(NSDictionary *)json {
  
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
  
  // dictionary for query parameters
  NSMutableDictionary *queries = [[[NSMutableDictionary alloc] init] autorelease];
  [queries setValue:[self dic2json:json] forKey:@"data"];
  
  // merge device info
  [queries setValue:[self dic2json:[self deviceInfo]] forKey:@"device"];
  
  // query for HTTP request(post data)
  NSString *query_string = [self generateQuery:queries];
  
  SDK_DEBUG(([NSString stringWithFormat:@"query_string : %@", query_string]));
  
  [request setURL:self.url];
  [request setHTTPMethod:HTTP_METHOD];
  [request addValue:HEADER_NAME_CONTENT_TYPE forHTTPHeaderField: @"Content-Type"];
  [request setHTTPBody:[query_string dataUsingEncoding:NSUTF8StringEncoding]];

#ifdef DEVELOPMENT
  // ------------------------------
  // sync-request(for development)
  // ------------------------------
  NSURLResponse *response = nil;
  NSError *error = nil;
  NSData *data = nil;
  
  data = [NSURLConnection sendSynchronousRequest:request
                               returningResponse:&response
                                           error:&error];
  
  [self handleResponse:self.url response:response data:data error:error];
#else
  // ------------------------------
  // async-request(for production)
  // ------------------------------
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[[[NSOperationQueue alloc] init] autorelease]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      [self handleResponse:self.url response:response data:data error:error];
    }];
#endif
}


// ==================================================
//
// private methods
//
// ==================================================

-(NSString*) generateQuery:(NSDictionary *)params {
  
  NSMutableArray *parts = [NSMutableArray array];
  
  for (NSString* key in params) {
    NSString* value = [params objectForKey: key];

    SDK_DEBUG(([NSString stringWithFormat:@"PARAM %@ : %@", key, value]));
    
    NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode:key], [self urlEncode:value]];
    [parts addObject: part];
  }
  
  return [parts componentsJoinedByString: @"&"];
}

/* --------------------------------------------------------------------------------
 *
 * callback for beacon request
 *
 * @param url requested
 * @param response response information
 * @param data response data(text)
 * @param error error object(null if request ends up successfully)
 *
 * @return void
 *
 -------------------------------------------------------------------------------- */
-(void) handleResponse:(NSURL *)url
              response:(NSURLResponse *)response
                  data:(NSData *)data
                 error:(NSError *)error {
  
  if (error) {
    if (error.code == -1003) {
      NSLog(@"not found hostname. targetURL=%@", url);
    } else if (-1019) {
      NSLog(@"auth error. reason=%@", error);
    } else {
      NSLog(@"unknown error occurred. reason = %@", error);
    }
  } else {
    NSInteger httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
    
    if (httpStatusCode == 404) {
      NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
      // } else if (...) {
      
    } else {
      SDK_DEBUG(@"success request!!");
      SDK_DEBUG(([NSString stringWithFormat:@"statusCode = %d", (int)httpStatusCode]));
      SDK_DEBUG(([NSString stringWithFormat:@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]));
      
      // any routine in main thread.
      dispatch_async(dispatch_get_main_queue(), ^{
      });
    }
  }
}

/* --------------------------------------------------------------------------------
 *
 * convert NSDictonary to NSString with JSON format
 *
 * @param dict
 *
 * @return NSString
 *
 -------------------------------------------------------------------------------- */
-(NSString *)dic2json:(NSDictionary *)dict {
  NSError *error = nil;
  NSData *data = nil;
  NSString *string = nil;
  
  if([NSJSONSerialization isValidJSONObject:dict]){
    data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
  }
  
  return string;
}

/* --------------------------------------------------------------------------------
 *
 * encode String for query parameter
 *
 * @param string string to be encoded
 *
 * @return NSString encoded string
 *
 -------------------------------------------------------------------------------- */
-(NSString *)urlEncode:(NSString *)string {
  return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                             (CFStringRef)string,
                                                             NULL,
                                                             (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                             CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

/* --------------------------------------------------------------------------------
 *
 * get device information as dictionary
 *
 * @return NSDictionary
 *
 -------------------------------------------------------------------------------- */
-(NSMutableDictionary *)deviceInfo {
  
  NSMutableDictionary *deviceinfo = [[[NSMutableDictionary alloc] init] autorelease];
  UIDevice *currentDevice = [UIDevice currentDevice];
  
  [deviceinfo setValue:[currentDevice model] forKey:@"model"];
  [deviceinfo setValue:[currentDevice systemVersion] forKey:@"system_version"];
  [deviceinfo setValue:[currentDevice systemName] forKey:@"system_name"];
  
  NSString *app_version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
  [deviceinfo setValue:(app_version ? app_version : @"0.0.0") forKey:@"app_version"];
  
  // add uuid
  [deviceinfo setValue:self.unique_user_id forKey:@"uuid"];
  
  return deviceinfo;
}

-(NSString *)generateUUID {
  
  NSString* uuid = [[NSUserDefaults standardUserDefaults] valueForKey:UUID_KEY];
  
  if (!uuid) {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    uuid = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:UUID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  
  return [uuid autorelease];
}

-(void)removeUUID {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:UUID_KEY];
}


/* ================================================================================
 *
 * these methods are forbidden if you want to use ARC
 *
 ================================================================================ */
//+ (id)allocWithZone:(NSZone *)zone {
//  return [[self sharedManager] retain];
//}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

//- (unsigned)retainCount {
//  return UINT_MAX;
//}

- (oneway void)release {
}

- (id)autorelease {
  return self;
}

- (void)dealloc {
  [super dealloc];
}


@end
