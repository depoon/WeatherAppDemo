//
//  WeatherRequestApi.m
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import "WeatherRequestApi.h"
#import "AFNetworking.h"
//@import AFNetworking;

static NSString *endPoint = @"http://api.worldweatheronline.com/free/v1/weather.ashx";
static NSString *apiPath = @"/free/v1/weather.ashx";
static NSString *secret = @"vzkjnx2j5f88vyn5dhvvqkzc";
static NSString *format = @"json";

@interface WeatherRequestApi()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, strong) WeatherRequestApiCallback callback;
@property(nonatomic, strong) UIApplication *app;
@property(nonatomic, copy) NSString *searchKeyword;
@end

@implementation WeatherRequestApi

- (instancetype)initWithCallback:(WeatherRequestApiCallback)callback withSearchKeyword:(NSString *)keyword{
    self = [super init];
    _callback = callback;
    _searchKeyword = keyword;
    _app = [UIApplication sharedApplication];
    
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:endPoint]];
    [self.manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [self.manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    return self;
}


- (void)execute {
    self.app.networkActivityIndicatorVisible = YES;    

    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"PackagedConfig"
                                                     ofType:@"plist"];
    NSDictionary* plistJson = [[NSDictionary alloc]
             initWithContentsOfFile:configPath];
    NSString* apiDomain = [plistJson objectForKey: @"ApiDomain"];
    if (apiDomain){
        
        //NSString *apiPath = @"/free/v1/weather.ashx";
        NSString* apiEndPoint = [NSString stringWithFormat: @"%@%@", apiDomain, apiPath];
        [self.manager GET:apiEndPoint
               parameters:[self parameters]
                  success:[self getOperationSuccessBlock]
                  failure:[self getOperationFailureBlock]];
    }
    
}

-(NSDictionary *)parameters{
    return @{@"q":self.searchKeyword,
             @"key":secret,
             @"format":format,
             @"fx":@"yes"};
}

- (void (^) (AFHTTPRequestOperation *, id))getOperationSuccessBlock {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        self.app.networkActivityIndicatorVisible = NO;
        NSDictionary *dictData ;

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dictData = (NSDictionary *)[responseObject objectForKey:@"data"];
            
            if([dictData count] > 0){
                if (dictData[@"error"]){
                    NSString *errorMessage = [[dictData valueForKeyPath:@"error.msg"] firstObject];
                    NSDictionary *info = @{@"message":errorMessage};
                    NSError *error = [NSError errorWithDomain:@"WEATHER_CUSTOM_MESSAGE_ERROR" code:999999 userInfo:info];
                    
                   return _callback(nil,error);
                }
            }
        }
        
        _callback(dictData, nil);
    };
}

- (void (^) (AFHTTPRequestOperation *, NSError *))getOperationFailureBlock {
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        self.app.networkActivityIndicatorVisible = NO;

        _callback(nil, error);
    };
}

- (void) cancelOperation {
    [self.manager.operationQueue cancelAllOperations];
}


@end
