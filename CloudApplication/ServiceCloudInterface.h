// This file describes your public interface.
// Every method you put in this interface will be reachable via HTTP.
// Tutorial: http://objective-cloud.com/docs/tutorial/
// Documentation: http://objective-cloud.com/docs/invocation-based-applications/

#import <OCFoundation/OCFoundation.h>

@protocol ServiceCloudInterface <NSObject>
+ (NSString *)sayHello;
@end