
#import <Foundation/Foundation.h>
#import "EventEmitter.h"


NSString *const kCustomEventName = @"showEvent";

@implementation EventEmitter

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(struct _NSZone *)zone {
  static EventEmitter *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
    [defaultCenter addObserver:self
                      selector:@selector(sendCustomEvent:)
                          name:@"OpenByDeepLink"
                        object:nil];
  }
  return self;
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}



- (void)sendCustomEvent:(NSNotification *)notification {
    NSLog(@"custom event");
  NSString *redirectURL = notification.object;
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",redirectURL]];
  NSDictionary<NSString *, NSString *> *params = [self queryParametersFromURL:url];
  NSString *client_id = [params objectForKey:@"client_id"];
  NSString *signature = [params objectForKey:@"signature"];
  NSString *status = [params objectForKey:@"status"];
  NSDictionary* data = @{ @"client_id": client_id, @"signature": signature, @"status": status };
  [self sendEventWithName:kCustomEventName body: data];
}


- (NSArray<NSString *> *)supportedEvents {
  return @[kCustomEventName];
}



- (NSDictionary<NSString *, NSString *> *)queryParametersFromURL:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableDictionary<NSString *, NSString *> *queryParams = [NSMutableDictionary<NSString *, NSString *> new];
    for (NSURLQueryItem *queryItem in [urlComponents queryItems]) {
        if (queryItem.value == nil) {
            continue;
        }
        [queryParams setObject:queryItem.value forKey:queryItem.name];
    }
    return queryParams;
}
@end

