//
//  MutiPlayerViewController.m
//  XHomePage
//
//  Created by csco on 2018/4/17.
//  Copyright © 2018年 csco. All rights reserved.
//

@import Foundation;
@import AVFoundation;
@import CoreMedia.CMTime;

#import "NSDate+YYAdd.h"

#import "MutiPlayerViewController.h"
#import "AAPLPlayerView.h"

#import "YYKit.h"
#import "WBStatusComposeViewController.h"

@interface MutiPlayerViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSTimer * _timer;
    NSInteger delay;
    
    AVQueuePlayer *_player;
    AVURLAsset *_asset;
    
    /*
     A token obtained from calling `player`'s `addPeriodicTimeObserverForInterval(_:queue:usingBlock:)`
     method.
     */
    id<NSObject> _timeObserverToken;
    AVPlayerItem *_playerItem;
    NSDate * _selectDate;
}

@property (readonly) AVPlayerLayer *playerLayer;

@property NSMutableDictionary *assetTitlesAndThumbnailsByURL;

@property (weak, nonatomic) IBOutlet UIImageView *imgHolder;
@property (weak, nonatomic) IBOutlet AAPLPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *controBar;
@property (weak) IBOutlet UISlider *timeSlider;
@property (weak) IBOutlet UILabel *startTimeLabel;
@property (weak) IBOutlet UILabel *durationLabel;

@property (weak) IBOutlet UIButton *playPauseButton;
//@property (weak) IBOutlet UIButton *rewindButton;
//@property (weak) IBOutlet UIButton *fastForwardButton;

//@property (weak) IBOutlet UILabel *queueLabel;

@property (weak, nonatomic) IBOutlet UITableView *channelTable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *readView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MutiPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectDate = [NSDate date];
    
    self.readView.hidden = YES;
    delay = 5;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    // Do any additional setup after loading the view.
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"关于PE" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

/*
 KVO context used to differentiate KVO callbacks for this class versus other
 classes in its class hierarchy.
 */
static int AAPLPlayerViewControllerKVOContext = 0;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimer];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparence"] forBarMetrics:UIBarMetricsDefault];
//    itemColor = self.navigationController.navigationItem.rightBarButtonItem.tintColor;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    /*
     Update the UI when these player properties change.
     
     Use the context parameter to distinguish KVO for our particular observers and not
     those destined for a subclass that also happens to be observing these properties.
     */
    [self addObserver:self forKeyPath:@"player.currentItem.duration" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    
    self.playerView.playerLayer.player = self.player;
    
    /*
     Read the list of assets we'll be using from a JSON file.
     */
    [self asynchronouslyLoadURLAssetsWithManifestURL:[[NSBundle mainBundle] URLForResource:@"MediaManifest" withExtension:@"json"]];
    
    // Use a weak self variable to avoid a retain cycle in the block.
    MutiPlayerViewController __weak *weakSelf = self;
    _timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        double timeElapsed = CMTimeGetSeconds(time);
        
        weakSelf.timeSlider.value = timeElapsed;
        weakSelf.startTimeLabel.text = [weakSelf createTimeString: timeElapsed];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    __weak MutiPlayerViewController *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [weakSelf.collectionView reloadData];
//        NSLog(@"self.player.items.count==%lu", (unsigned long)self.player.items.count);
        [self.player play];
    });
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_timeObserverToken) {
        [self.player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }
    
    [self.player pause];
    
    [self removeObserver:self forKeyPath:@"player.currentItem.duration" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.rate" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.currentItem.status" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.currentItem" context:&AAPLPlayerViewControllerKVOContext];
}

// MARK: - Properties

// Will attempt load and test these asset keys before playing
+ (NSArray *)assetKeysRequiredToPlay {
    return @[@"playable", @"hasProtectedContent"];
}

- (AVQueuePlayer *)player {
    if (!_player) {
        _player = [[AVQueuePlayer alloc] init];
    }
    return _player;
}

- (CMTime)currentTime {
    return self.player.currentTime;
}

- (void)setCurrentTime:(CMTime)newCurrentTime {
    [self.player seekToTime:newCurrentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (CMTime)duration {
    return self.player.currentItem ? self.player.currentItem.duration : kCMTimeZero;
}

- (float)rate {
    return self.player.rate;
}

- (void)setRate:(float)newRate {
    self.player.rate = newRate;
}

- (AVPlayerLayer *)playerLayer {
    return self.playerView.playerLayer;
}

- (NSDateComponentsFormatter *)timeRemainingFormatter {
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    formatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return formatter;
}

// MARK: - Asset Loading

/*
 Prepare an AVAsset for use on a background thread. When the minimum set
 of properties we require (`assetKeysRequiredToPlay`) are loaded then add
 the asset to the `assetTitlesAndThumbnails` dictionary. We'll use that
 dictionary to populate the "Add Item" button popover.
 */
- (void)asynchronouslyLoadURLAsset:(AVURLAsset *)asset title:(NSString *)title thumbnailResourceName:(NSString *)thumbnailResourceName {
    
    /*
     Using AVAsset now runs the risk of blocking the current thread (the
     main UI thread) whilst I/O happens to populate the properties. It's
     prudent to defer our work until the properties we need have been loaded.
     */
    [asset loadValuesAsynchronouslyForKeys:MutiPlayerViewController.assetKeysRequiredToPlay completionHandler:^{
        
        /*
         The asset invokes its completion handler on an arbitrary queue.
         To avoid multiple threads using our internal state at the same time
         we'll elect to use the main thread at all times, let's dispatch
         our handler to the main queue.
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /*
             This method is called when the `AVAsset` for our URL has
             completed the loading of the values of the specified array
             of keys.
             */
            
            /*
             Test whether the values of each of the keys we need have been
             successfully loaded.
             */
            for (NSString *key in self.class.assetKeysRequiredToPlay) {
                NSError *error = nil;
                if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
                    NSString *stringFormat = NSLocalizedString(@"error.asset_%@_key_%@_failed.description", @"Can't use this AVAsset because one of it's keys failed to load");
                    
                    NSString *message = [NSString localizedStringWithFormat:stringFormat, title, key];
                    
                    [self handleErrorWithMessage:message error:error];
                    
                    return;
                }
            }
            
            // We can't play this asset.
            if (!asset.playable || asset.hasProtectedContent) {
                NSString *stringFormat = NSLocalizedString(@"error.asset_%@_not_playable.description", @"Can't use this AVAsset because it isn't playable or has protected content");
                
                NSString *message = [NSString localizedStringWithFormat:stringFormat, title];
                
                [self handleErrorWithMessage:message error:nil];
                
                return;
            }
            
            /*
             We can play this asset. Create a new AVPlayerItem and make it
             our player's current item.
             */
            if (!self.loadedAssets)
                self.loadedAssets = [NSMutableDictionary dictionary];
            self.loadedAssets[title] = asset;
            
            NSString *path = [[NSBundle mainBundle] pathForResource:[thumbnailResourceName stringByDeletingPathExtension] ofType:[thumbnailResourceName pathExtension]];
            UIImage *thumbnail = [[UIImage alloc] initWithContentsOfFile:path];
            if (!self.assetTitlesAndThumbnailsByURL) {
                self.assetTitlesAndThumbnailsByURL = [NSMutableDictionary dictionary];
            }
            self.assetTitlesAndThumbnailsByURL[asset.URL] = @{ @"title" : title, @"thumbnail" : thumbnail };
            
            NSLog(@"self.loadedAssets:%lu", (unsigned long)self.loadedAssets.count);
            /* add available media item to player*/
            AVPlayerItem *newPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
            [self.player insertItem:newPlayerItem afterItem:nil];
            
        });
    }];
}

/*
 Read the asset URLs, titles and thumbnail resource names from a JSON manifest
 file - then load each asset.
 */
- (void)asynchronouslyLoadURLAssetsWithManifestURL:(NSURL *)jsonURL
{
    NSArray *assetsArray = nil;
    
    NSData *dataJson = [[NSData alloc] initWithContentsOfURL:jsonURL];
    if (dataJson) {
        assetsArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:dataJson options:0 error:nil];
        if (!assetsArray) {
            [self handleErrorWithMessage:NSLocalizedString(@"error.json_parse_failed.description", @"Failed to parse the assets manifest JSON") error:nil];
        }
    }
    else {
        [self handleErrorWithMessage:NSLocalizedString(@"error.json_open_failed.description", @"Failed to open the assets manifest JSON") error:nil];
    }
    
    for (NSDictionary *assetDict in assetsArray) {
        
        NSURL *mediaURL = nil;
        NSString *optionalResourceName = assetDict[@"mediaResourceName"];
        NSString *optionalURLString = assetDict[@"mediaURL"];
        if (optionalResourceName) {
            mediaURL = [[NSBundle mainBundle] URLForResource:[optionalResourceName stringByDeletingPathExtension] withExtension:optionalResourceName.pathExtension];
        }
        else if (optionalURLString) {
            mediaURL = [NSURL URLWithString:optionalURLString];
        }
        NSLog(@"mediaURL==%@", mediaURL);
        [self asynchronouslyLoadURLAsset:[AVURLAsset URLAssetWithURL:mediaURL options:nil]
                                   title:assetDict[@"title"]
                   thumbnailResourceName:assetDict[@"thumbnailResourceName"]];
    }
    
}

// MARK: Convenience

- (NSString *)createTimeString:(double)time {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.second = (NSInteger)fmax(0.0, time);
    
    return [self.timeRemainingFormatter stringFromDateComponents:components];
}

- (NSDictionary *)titleAndThumbnailForPlayerItemAtIndexPath:(NSIndexPath *)indexPath {
    AVPlayerItem *item = [self.player items][[indexPath indexAtPosition:1]];
    return self.assetTitlesAndThumbnailsByURL[[(AVURLAsset *)item.asset URL]];
}


#pragma mark-- IBActions
// MARK: - IBActions

- (IBAction)playPauseButtonWasPressed:(UIButton *)sender {
    if (self.player.rate != 1.0) {
        // Not playing foward; so play.
        if (CMTIME_COMPARE_INLINE(self.currentTime, ==, self.duration)) {
            // At end; so got back to beginning.
            self.currentTime = kCMTimeZero;
        }
        [self.player play];
    } else {
        // Playing; so pause.
        [self.player pause];
    }
}

/*
- (IBAction)rewindButtonWasPressed:(UIButton *)sender {
    self.rate = MAX(self.player.rate - 2.0, -2.0); // rewind no faster than -2.0
}

- (IBAction)fastForwardButtonWasPressed:(UIButton *)sender {
    self.rate = MIN(self.player.rate + 2.0, 2.0); // fast forward no faster than 2.0
}
*/
- (IBAction)seekToNext:(id)sender {
    [self.player advanceToNextItem];
}

- (IBAction)timeSliderDidChange:(UISlider *)sender {
    self.currentTime = CMTimeMakeWithSeconds(sender.value, 1000);
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)tapToReadText:(id)sender {
    
    self.readView.hidden = !self.readView.hidden;
}

- (IBAction)tapControView:(UITapGestureRecognizer *)sender {
    NSLog(@"%s", __func__);
    delay = 5;
}
- (IBAction)collectOrLikeIt:(id)sender {
    
}
- (IBAction)writeComment:(id)sender {
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeStatus;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}
- (IBAction)shareAction:(id)sender {
    NSString * title = @"[私募宝]分享：投资、选私募，就上私募宝！";
    UIImage * image = [UIImage imageNamed:@"CSico.png"];
    NSURL * url = [NSURL URLWithString:@"http://www.csco.com.cn"];
    //https://www.pgyer.com/ZpS6
    NSArray *activityItems = @[title, image, url];
    NSArray<UIActivityType> *excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];  //⑤
    activityVC.excludedActivityTypes = excludedActivityTypes; //⑥excluded排除的
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverPresentationController *popover = activityVC.popoverPresentationController;
        if (popover) {
            popover.barButtonItem = sender;//provide location
            popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
        }
    }else{ }
    [self presentViewController:activityVC animated:TRUE completion:^{ }];
}


- (void)presentModalPopoverAlertController:(UIAlertController *)alertController sender:(UIButton *)sender
{
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    alertController.popoverPresentationController.sourceView = sender;
    alertController.popoverPresentationController.sourceRect = sender.bounds;
    alertController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark-- KV Observation
// MARK: - KV Observation

// Update our UI when player or player.currentItem changes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context != &AAPLPlayerViewControllerKVOContext) {
        // KVO isn't for us.
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:@"player.currentItem"]) {
        [self queueDidChangeFromArray:nil toArray:[self.player items]];
        
    }
    else if ([keyPath isEqualToString:@"player.currentItem.duration"]) {
        // Update timeSlider and enable/disable controls when duration > 0.0
        
        // Handle NSNull value for NSKeyValueChangeNewKey, i.e. when player.currentItem is nil
        NSValue *newDurationAsValue = change[NSKeyValueChangeNewKey];
        CMTime newDuration = [newDurationAsValue isKindOfClass:[NSValue class]] ? newDurationAsValue.CMTimeValue : kCMTimeZero;
        BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
        double currentTime = hasValidDuration ? CMTimeGetSeconds(self.currentTime) : 0.0;
        double newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0;
        
        self.timeSlider.maximumValue = newDurationSeconds;
        self.timeSlider.value = currentTime;
//        self.rewindButton.enabled = hasValidDuration;
//        self.playPauseButton.enabled = hasValidDuration;
//        self.fastForwardButton.enabled = hasValidDuration;
        self.timeSlider.enabled = hasValidDuration;
        self.startTimeLabel.enabled = hasValidDuration;
        self.startTimeLabel.text = [self createTimeString:currentTime];
        self.durationLabel.enabled = hasValidDuration;
        self.durationLabel.text = [self createTimeString:newDurationSeconds];
    }
    else if ([keyPath isEqualToString:@"player.rate"]) {
        // Update playPauseButton image
        double newRate = [change[NSKeyValueChangeNewKey] doubleValue];
        UIImage *buttonImage = (newRate == 1.0) ? [UIImage imageNamed:@"19"] : [UIImage imageNamed:@"16"];
        [self.playPauseButton setImage:buttonImage forState:UIControlStateNormal];
        
        // Update holder image
        self.imgHolder.hidden = (newRate == 1.0)?YES:NO;
    }
    else if ([keyPath isEqualToString:@"player.currentItem.status"]) {
        // Display an error if status becomes Failed
        
        // Handle NSNull value for NSKeyValueChangeNewKey, i.e. when player.currentItem is nil
        NSNumber *newStatusAsNumber = change[NSKeyValueChangeNewKey];
        AVPlayerItemStatus newStatus = [newStatusAsNumber isKindOfClass:[NSNumber class]] ? newStatusAsNumber.integerValue : AVPlayerItemStatusUnknown;
        
        if (newStatus == AVPlayerItemStatusFailed) {
            [self handleErrorWithMessage:self.player.currentItem.error.localizedDescription error:self.player.currentItem.error];
            self.imgHolder.hidden = NO;
        }else{
            self.playPauseButton.enabled = YES;
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    CGSize presentationSize = self.player.currentItem.presentationSize;
    NSLog(@"+++++++++presentationSize==%@", NSStringFromCGSize(presentationSize));
    if (CGSizeEqualToSize(presentationSize, CGSizeZero)) {
        //audio only:
        self.imgHolder.hidden = NO;
    }else{
        self.imgHolder.hidden = YES;
    }
}

// Trigger KVO for anyone observing our properties affected by player and player.currentItem
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"duration"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.duration" ]];
    } else if ([key isEqualToString:@"currentTime"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.currentTime" ]];
    } else if ([key isEqualToString:@"rate"]) {
        return [NSSet setWithArray:@[ @"player.rate" ]];
    } else {
        return [super keyPathsForValuesAffectingValueForKey:key];
    }
}

// player.items is not KV observable so we need to call this function every time the queue changes

- (void)queueDidChangeFromArray:(NSArray *)oldPlayerItems toArray:(NSArray *)newPlayerItems {
    
    if (newPlayerItems.count == 0) {
//        self.queueLabel.text = NSLocalizedString(@"label.queue.empty", @"Queue is empty");
    }
    else {
//        NSString *stringFormat = NSLocalizedString(@"label.queue.%lu items", @"Queue of n item(s)");
        
//        self.queueLabel.text = [NSString localizedStringWithFormat:stringFormat, newPlayerItems.count];
    }
    
//    BOOL isQueueEmpty = newPlayerItems.count == 0;
//    self.clearButton.enabled = !isQueueEmpty;
    
//    [self.collectionView reloadData];
}

// MARK: - Error Handling

- (void)handleErrorWithMessage:(NSString *)message error:(NSError *)error {
    NSLog(@"Error occurred with message: %@, error: %@.", message, error);
    
    NSString *alertTitle = NSLocalizedString(@"alert.error.title", @"Alert title for errors");
    NSString *defaultAlertMessage = NSLocalizedString(@"error.default.description", @"Default error message when no NSError provided");
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:alertTitle message:message ?: defaultAlertMessage  preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *alertActionTitle = NSLocalizedString(@"alert.error.actions.OK", @"OK on error alert");
    UIAlertAction *action = [UIAlertAction actionWithTitle:alertActionTitle style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark-- timer

- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(delayHide:) userInfo:nil repeats:YES];
    }
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)delayHide:(NSTimer*)timer{
    if (self.readView.hidden) {
        delay --;
    }
    if (delay <= 0) {
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            self->_controBar.hidden =YES;
//        });
        _controBar.hidden =YES;
        delay = 0;
    }else{
        _controBar.hidden =NO;
        NSLog(@"delay==%ld", (long)delay);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-- UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _channelTable) {
        _selectDate = [[NSDate date] dateByAddingDays:indexPath.row];
        [_tableView reloadData];
    }else{
        [self seekToNext:nil];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView== _tableView) {
        UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"play_item" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"节目标题%ld", (long)indexPath.row];
        cell.detailTextLabel.text = [[_selectDate dateByAddingHours:indexPath.row] stringWithFormat:@"yyyy-MM-dd HH:mm"];
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"time" forIndexPath:indexPath];
        cell.textLabel.text = [[[NSDate date] dateByAddingDays:indexPath.row] stringWithFormat:@"MM-dd"];
        return cell;
    }
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return 65.0;
    }else{
        return 50.0;
    }
}

@end
