//
//  BKXCoreDisplayView.m
//  Pods-TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//

#import "BKXCoreDisplayView.h"
#import "BKXCoreTextImageData.h"
#import "BKXEnlargePictureView.h"
#import "BKXUnlineImageView.h"
#import "BKXCoreTextLinkData.h"
#import "BKXCoreTextUtils.h"
#import "BKXSDImageDownLoad.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
NSString *const CTDisplayViewImagePressedNotification = @"CTDisplayViewImagePressedNotification";
NSString *const CTDisplayViewLinkPressedNotification = @"CTDisplayViewLinkPressedNotification";

typedef enum CTDisplayViewState : NSInteger {
    CTDisplayViewStateNormal,       // 普通状态
    CTDisplayViewStateTouching,     // 正在按下，需要弹出放大镜
    CTDisplayViewStateSelecting     // 选中了一些文本，需要弹出复制菜单
} CTDisplayViewState;


@interface BKXCoreDisplayView()<UIGestureRecognizerDelegate>
@property (nonatomic) NSInteger selectionStartPosition;
@property (nonatomic) NSInteger selectionEndPosition;
@property (nonatomic) CTDisplayViewState state;
@property (strong, nonatomic) UIImageView *leftSelectionAnchor;
@property (strong, nonatomic) UIImageView *rightSelectionAnchor;
@property (assign, nonatomic) NSInteger requestCount; // 最多请求次数。
@property (nonatomic,strong)NSDictionary * selectImageDic;

@end

@implementation BKXCoreDisplayView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self setupEvents];
    }
    return self;
}

- (void)setData:(BKXCoreTextData *)data {
    _requestCount=0;
    _data = data;
}

- (void)setupEvents {
    UIGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    tapRecognizer.delegate=self;
    [self addGestureRecognizer:tapRecognizer];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.data == nil) {
        return;
    }
    
    CGContextClearRect(UIGraphicsGetCurrentContext(), self.frame);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    if (self.data.imageArray.count > 0) {
        NSArray *lines = (NSArray *)CTFrameGetLines(self.data.ctFrame);
        NSUInteger lineCount = [lines count];
        CGPoint lineOrigins[lineCount];
        CTFrameGetLineOrigins(self.data.ctFrame, CFRangeMake(0, 0), lineOrigins);

        for (int i = 0; i < lineCount; i++) {
            
            CGPoint origin = lineOrigins[i];
            CTLineRef line = (__bridge CTLineRef)lines[i];
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
            CGFloat lineHeight = lineAscent + lineDescent;
            
            __block CGFloat fontSize = 0;
            [self.data.content enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, self.data.content.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                UIFont *font = (UIFont *)value;
                if (font) {
                    fontSize = font.pointSize;
                    *stop = YES;
                }
            }];
            
            CGContextSetTextPosition(context, origin.x, origin.y + lineHeight / 2 - fontSize / 2);
            CTLineDraw(line, context);
        }
        
    } else {
        CTFrameDraw(self.data.ctFrame, context);
    }
    
    // 绘制图片
    for (BKXCoreTextImageData * imageData in self.data.imageArray) {
            UIImage *image = [UIImage imageNamed:imageData.name];
            SDImageCache * cache = [SDImageCache sharedImageCache];
            if (imageData.name.length > 0) {
                image = [cache imageFromDiskCacheForKey:imageData.name];
                    // 适配lj后台
                    if ([imageData.name containsString:@"base64"]) {
                        NSArray *imageArray = [imageData.name  componentsSeparatedByString:@","];
                        NSData *imagebase = [[NSData alloc] initWithBase64EncodedString:imageArray[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        image = [UIImage imageWithData:imagebase];
    //                    image = imageData.baseImage;
                    }
                    if (image) {
                        CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
                    }else{
                        if (imageData.isDownloading == NO) {
                            [self refreshImage:imageData.name imageData:imageData];
                        }
                }
            }
        }
}

-(void)refreshImage:(NSString*)imageUrls imageData:(BKXCoreTextImageData *)imageData{
    if ([imageData.name containsString:@"base64"]) {
        return;
    }
    SDImageCache *cache = [SDImageCache sharedImageCache];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *urlStr = [imageUrls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // 转译一些特殊字符
    NSURL *url = [NSURL URLWithString:urlStr];
    [cache diskImageExistsWithKey:urlStr completion:^(BOOL isInCache) {
        __weak BKXCoreDisplayView *view=self;
            if (!isInCache)
            {
                imageData.isDownloading = YES;
                __block int i=0;
                __weak typeof(self) weakSelf = self;
                [manager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if(!error){
                        if (i<view.data.imageArray.count) {
                            for (int t=0; t<view.data.imageArray.count; t++) {
                                if ([imageURL.absoluteString isEqualToString:[imageURL absoluteString]] ) {
                                    i++;
                                }
                            }
                        }
                    }else{
                        if (weakSelf.requestCount<3) {
                            if(imageURL.absoluteString){
                                weakSelf.requestCount++;
                        NSLog(@"有网络，正在第%ld次重试图片下载。%@",(long)weakSelf.requestCount,imageURL.absoluteString);

                                [weakSelf refreshImage:imageURL.absoluteString imageData:imageData];
                            }
                        }else{
                            weakSelf.requestCount = 0;
                        }
                    }
                    imageData.isDownloading = NO;
                    imageData.name = urlStr;  // 使用转译后的url
                    [view setNeedsDisplay];
                }];
            }else{
                imageData.isDownloading = NO;
                imageData.name = urlStr;
                [view setNeedsDisplay];
            }
    }];
    
    
}

/**
 *  单击手势
 */
- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    if (_state == CTDisplayViewStateNormal) {
        for (BKXCoreTextImageData * imageData in self.data.imageArray) {
            CGRect imageRect = imageData.imagePosition;
            CGPoint imagePosition = imageRect.origin;
            imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
            CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
            if (CGRectContainsPoint(rect, point)) {
                BKXCoreTextImageData* imageData= _selectImageDic[@"imageData"];
                UIImage *image = [BKXSDImageDownLoad imageForURL:imageData.name];
//                BKXEnlargePictureView * picthure=[[BKXEnlargePictureView alloc]initWithImageView:image];
//                picthure =nil;
                return;
            }
        }
    } else {
        self.state = CTDisplayViewStateNormal;
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:) || action == @selector(selectAll:)) {
        return YES;
    }
    return NO;
}

- (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range {
    if (position >= range.location && position < range.location + range.length) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

/**
 *  处理手势和tableViewCell的冲突
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch  locationInView:self];
    CGPoint point2 = [gestureRecognizer  locationInView:self];
    
    BKXCoreTextLinkData *linkData = [BKXCoreTextUtils touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        NSLog(@"hint link!");
        NSDictionary *userInfo = @{ @"linkData": linkData };
        [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewLinkPressedNotification
                                                            object:self userInfo:userInfo];

        return YES;
    }
    
    
    for (BKXCoreTextImageData * imageData in self.data.imageArray) {
        // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        // 检测点击位置 Point 是否在rect之内
        if (CGRectContainsPoint(rect, point)) {
            NSLog(@"hint image");
            _selectImageDic= @{ @"imageData": imageData };
            // 在这里处理点击后的逻辑
            NSDictionary *userInfo = @{ @"imageData": imageData };
            [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewImagePressedNotification
                                                                object:self userInfo:userInfo];
            return YES;
        }
    }
    
   
    return NO;
}

@end
