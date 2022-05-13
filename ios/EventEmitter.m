
#import <Foundation/Foundation.h>
#import "EventEmitter.h"


NSString *const kCustomEventName = @"showEvent";

@implementation EventEmitter

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(struct _NSZone *)zone {
  static LightningRewardsEmitter *sharedInstance = nil;
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
  NSString *redirectURL = notification.object;
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",redirectURL]];
  NSDictionary<NSString *, NSString *> *params = [self queryParametersFromURL:url];
  NSString *msg = [params objectForKey:@"msg"];
  [self sendEventWithName:kCustomEventName body: msg];
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

