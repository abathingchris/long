#import "CloudApp.h"

#import <OCFoundation/OCFoundation.h>
#import <PGCKit/PGCKit.h>

@implementation CloudApp

+ (void)loadDatabase
{
    // Get the default connection object
  PGCConnection *connection = [self defaultDatabaseConnection];

    // Try to connect
  NSError *error;
  BOOL connected = [connection connectAndGetError:&error];

    // Handle errors
  if(connected == NO) {
    NSLog(@"Failed to connect: %@", error);
  } else {
    NSLog(@"Connected!");
  }

    // Be happy!
}

+ (void)finishLaunching {

  [CloudApp loadDatabase];

  // You can delete this handler if you want.
  [self handleRequestsWithMethod:@"GET" matchingPath:@"/" withBlock:^(OCFRequest *request) {
    NSString *appName = [[NSBundle mainBundle] infoDictionary][@"OCFCloudAppName"];
    NSMutableString *result = [NSMutableString new];
    
    [result appendString:@"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">"];
    [result appendString:@"<html><head>"];
    [result appendString:@"<style type=\"text/css\">body {font-family: \"HelveticaNeue-Light\", \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif;} pre { background-color:#efefef; padding:10px;  overflow: auto; word-wrap: normal; white-space: pre; }</style>"];
    [result appendFormat:@"<title>%@</title>", appName];
    [result appendString:@"</head><body>"];
    [result appendString:@"<h1>Congratulations!</h1>"];
    [result appendString:@"<p>You did it! Your cloud application is running! You can now invoke methods by using Terminal (or any other HTTP client). Give it a try.</p>"];
    [result appendString:@"<h2>On localhost</h2>"];
    [result appendFormat:@"<pre>curl -X POST localhost:10000/Service -d '{\"selector\" : \"sayHello\", \"arguments\" : []}' -H 'Content-Type: application/json' --ipv4</pre>"];
    [result appendString:@"<h2>On Objective-Cloud</h2>"];
    [result appendFormat:@"<pre>curl -X POST https://%@.obcl.io/Service -d '{\"selector\" : \"sayHello\", \"arguments\" : []}' -H 'Content-Type: application/json'</pre>", appName];
    [result appendString:@"</body></html>"];

    [request respondWith:result];
  }];

  [self handleRequestsWithMethod:@"GET"
                    matchingPath:@"/hello"
                       withBlock:^(OCFRequest *request) {
                         NSMutableString *result = [NSMutableString new];
                         [result appendString:@"こんにちは"];
                         [request respondWith:result];
                       }];
  [self handleRequestsWithMethod:@"POST"
                    matchingPath:@"/hello"
                       withBlock:^(OCFRequest *request) {
                         NSMutableString *result = [NSMutableString new];
                         [result appendString:@"クリス"];
                         [request respondWith:result];
                       }];
  [CloudApp addHandlers];
}

+ (NSString *)jsonStringFromDict:(NSDictionary *)aDict
{
  NSError *error = nil;
  NSData *json;

    // Dictionary convertable to JSON ?
  if ([NSJSONSerialization isValidJSONObject:aDict])
  {
      // Serialize the dictionary
    json = [NSJSONSerialization dataWithJSONObject:aDict options:NSJSONWritingPrettyPrinted error:&error];
      // If no errors, let's view the JSON
    if (json != nil && error == nil)
    {
      NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
      NSLog(@"JSON: %@", jsonString);
      return jsonString;
    }
  }

  return nil;
}

+ (NSString *)errorStringWithDescription:(NSString *)aDescription
{
  return @"{ error: error }";
}

+ (void)addHandlers
{
  [self handleRequestsWithMethod:@"GET"
                    matchingPath:@"/user"
                       withBlock:^(OCFRequest *request) {
                         NSDictionary *userDict = @{@"users" : @[@"ami", @"chris", @"yvonne", @"melissa"]};
                         NSString *returnString = [CloudApp jsonStringFromDict:userDict];
                         if (!returnString) {
                           returnString = [CloudApp errorStringWithDescription:@"unable to construct json message"];
                         }
                         [request respondWith:returnString];
                       }];
}

@end
