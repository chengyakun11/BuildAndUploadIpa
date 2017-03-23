//
//  ViewController.m
//  BuildAndUploadIpa
//
//  Created by chengyakun11 on 2016/10/12.
//  Copyright © 2016年 fudianshu. All rights reserved.
//

#import "ViewController.h"
#import "LanSearchCell.h"
#import "DJActivityIndicator.h"
#import "DJProgressIndicator.h"
#import "DJProgressHUD.h"
#import "TargetsInfoModel.h"

// 文件协议头长度
#define delegateLength 7

@interface ViewController ()<NSTableViewDataSource,NSTableViewDelegate>
{
    NSMutableArray *_dataSoruce;
    
    NSTextField *projectPathTextField;
    NSTextField *ipaPathTextField;
    
    NSTextView *resultTextView;
    
    NSFileHandle *demoFileHandle;
}
@end


@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"掌讯打包";
    _dataSoruce = [NSMutableArray array];
    //项目路径
    projectPathTextField = [[NSTextField alloc]initWithFrame:NSMakeRect(20, self.view.frame.size.height-30+5, 400, 20)];
    projectPathTextField.editable = NO;
    projectPathTextField.placeholderString = @"请选择项目路径";
    projectPathTextField.backgroundColor = [NSColor whiteColor];
    [self.view addSubview:projectPathTextField];
    NSButton *chooseButton = [[NSButton alloc]init];
    chooseButton.title = @"选择项目路径";
    [chooseButton setTarget:self];
    [chooseButton setAction:@selector(chooseButtonPress:)];
    [chooseButton setButtonType:NSButtonTypeMomentaryPushIn];
    [chooseButton setBezelStyle:NSRoundedBezelStyle];
    [chooseButton setBordered:YES];
    chooseButton.frame = NSMakeRect(projectPathTextField.frame.origin.x+projectPathTextField.frame.size.width+10, self.view.frame.size.height-30, 150, 30);
    [self.view addSubview:chooseButton];
    //生成ipa包的路径
    ipaPathTextField = [[NSTextField alloc]initWithFrame:NSMakeRect(20, self.view.frame.size.height-60+5, 400, 20)];
    ipaPathTextField.editable = NO;
    ipaPathTextField.placeholderString = @"选择生成ipa包的路径";
    ipaPathTextField.backgroundColor = [NSColor whiteColor];
    [self.view addSubview:ipaPathTextField];
    NSButton *ipaPathButton = [[NSButton alloc]init];
    ipaPathButton.title = @"选择生成ipa包的路径";
    [ipaPathButton setTarget:self];
    [ipaPathButton setAction:@selector(ipaPathButtonPress:)];
    [ipaPathButton setButtonType:NSButtonTypeMomentaryPushIn];
    [ipaPathButton setBezelStyle:NSRoundedBezelStyle];
    [ipaPathButton setBordered:YES];
    ipaPathButton.frame = NSMakeRect(ipaPathTextField.frame.origin.x+ipaPathTextField.frame.size.width+10, self.view.frame.size.height-60, 150, 30);
    [self.view addSubview:ipaPathButton];
    //功能性按钮
    NSButton *packageAllButton = [[NSButton alloc]init];
    packageAllButton.title = @"批量打包";
    [packageAllButton setTarget:self];
    [packageAllButton setAction:@selector(didTappedAllPackageButton:)];
    [packageAllButton setButtonType:NSButtonTypeMomentaryPushIn];
    [packageAllButton setBezelStyle:NSRoundedBezelStyle];
    [packageAllButton setBordered:YES];
    packageAllButton.frame = NSMakeRect(chooseButton.frame.origin.x+chooseButton.frame.size.width+30, self.view.frame.size.height-30, 80, 30);
    [self.view addSubview:packageAllButton];
    NSButton *uploadAllButton = [[NSButton alloc]init];
    uploadAllButton.title = @"批量上传";
    [uploadAllButton setTarget:self];
    [uploadAllButton setAction:@selector(didTappedAllUploadButton:)];
    [uploadAllButton setButtonType:NSButtonTypeMomentaryPushIn];
    [uploadAllButton setBezelStyle:NSRoundedBezelStyle];
    [uploadAllButton setBordered:YES];
    uploadAllButton.frame = NSMakeRect(packageAllButton.frame.origin.x+packageAllButton.frame.size.width+30, self.view.frame.size.height-30, 80, 30);
    [self.view addSubview:uploadAllButton];
    //日志信息
    NSButton *resetButton = [[NSButton alloc]init];
    resetButton.title = @"清空无用的日志";
    [resetButton setTarget:self];
    [resetButton setAction:@selector(resetButtonButton:)];
    [resetButton setButtonType:NSButtonTypeMomentaryPushIn];
    [resetButton setBezelStyle:NSRoundedBezelStyle];
    [resetButton setBordered:YES];
    resetButton.frame = NSMakeRect(uploadAllButton.frame.origin.x+uploadAllButton.frame.size.width+30, self.view.frame.size.height-30, 180, 30);
    [self.view addSubview:resetButton];
    NSTextField *logTextField = [[NSTextField alloc]initWithFrame:NSMakeRect(self.view.frame.size.width-400, ipaPathTextField.frame.origin.y-5, 400, 25)];
    logTextField.editable = NO;
    logTextField.placeholderString = @"                                                  日志信息";
    logTextField.backgroundColor = [NSColor whiteColor];
    [self.view addSubview:logTextField];
    resultTextView = [[NSTextView alloc]initWithFrame:NSMakeRect(0, 0, 400, self.view.frame.size.height-60)];
    resultTextView.backgroundColor = [NSColor whiteColor];
    resultTextView.editable = NO;
    NSScrollView *textViewScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(self.view.frame.size.width-400, 0, 400, self.view.frame.size.height-60)];
    [textViewScrollView setAutoresizesSubviews:YES];
    [textViewScrollView setDocumentView:resultTextView];
    [self.view addSubview:textViewScrollView];
    //当前项目中的所有target
    _myScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width-400, self.view.frame.size.height-60)];
    [_myScrollView setAutoresizesSubviews:YES];
    
    _myTableView  = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width-400, self.view.frame.size.height-60)];
    [_myTableView setAutosaveName:@"downloadTableView"];
    [_myTableView setAutoresizesSubviews:YES];
    [_myTableView setGridStyleMask: NSTableViewSolidHorizontalGridLineMask];
    [_myTableView setAutosaveTableColumns:YES];
    [_myTableView setAllowsColumnSelection:NO];
    [_myTableView setAllowsColumnResizing:NO];
    [_myTableView setAllowsColumnReordering:NO];
    [_myTableView setSelectionHighlightStyle:1];
    [_myTableView setRowSizeStyle:NSTableViewRowSizeStyleMedium];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [_myScrollView setDocumentView:_myTableView];
    [self.view addSubview:_myScrollView];

    NSTableColumn *column=[[NSTableColumn alloc] initWithIdentifier:@"lanSearchColumn"];
    [[column headerCell] setStringValue:@"      项目中的Target"];
    [[column headerCell] setAlignment:NSTextAlignmentLeft];
    [column setWidth:self.view.frame.size.width];  //必须固定值
    [column setMinWidth:self.view.frame.size.width];
    [column setEditable:NO];
    [column setResizingMask:NSTableColumnAutoresizingMask | NSTableColumnUserResizingMask];
    [_myTableView addTableColumn:column];
}
- (void)addColumn:(NSString*)newid withTitle:(NSString*)title
{
    NSInteger columnNum = [newid intValue];
    NSTableColumn *column=[[NSTableColumn alloc] initWithIdentifier:newid];
    [[column headerCell] setStringValue:title];
    [[column headerCell] setAlignment:NSTextAlignmentCenter];
    [[column headerCell] setBackgroundColor:[NSColor clearColor]];
    if(columnNum == 1){
        [column setWidth:self.view.frame.size.width];  //必须固定值
    }
    [column setMinWidth:self.view.frame.size.width];
    [column setEditable:NO];
    [column setResizingMask:NSTableColumnAutoresizingMask | NSTableColumnUserResizingMask];
    [_myTableView addTableColumn:column];
}


#pragma mark - Table View DataSource  Delegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return _dataSoruce.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 80;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    LanSearchCell * cell = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    cell.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    if([[tableColumn identifier] isEqualToString:@"lanSearchColumn"]) {
        if (!cell)
        {
            TargetsInfoModel *model = [_dataSoruce objectAtIndex:row];
            cell = [[LanSearchCell alloc]initWithFrame:NSMakeRect(0, 0, _myTableView.frame.size.width, 75)];
            [cell layoutWithNewDevice:model];
            cell.checkButton.tag = 200+row;
            
            cell.packageBtn.tag = 100 + row;
            [cell.packageBtn setAction:@selector(packageBtnClicked:)];
            
            cell.uploadBtn.tag = 900 + row;
            [cell.uploadBtn setAction:@selector(uploadBtnClicked:)];
        }
    }
    return cell;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    NSLog(@"I'm allow you to select:%ld",row);
    NSLog(@"%@",[_dataSoruce objectAtIndex:row]);
    return YES;
}



#pragma mark - 按钮事件
//选择项目根目录
-(void)chooseButtonPress:(id)sender
{
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    if ([openDlg runModal]) {
        NSURL *directoryURL = [openDlg directoryURL];
        projectPathTextField.stringValue = [self getPathWithfileString:[directoryURL relativeString]];
        [self readProjectDirectory];
    }
}
//选择ipa目录
-(void)ipaPathButtonPress:(id)sender
{
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    if ([openDlg runModal]) {
        NSURL *directoryURL = [openDlg directoryURL];
        ipaPathTextField.stringValue = [self getPathWithfileString:[directoryURL relativeString]];;
        [self readIpaDirectory];
    }
}
//批量打包按钮
- (IBAction)didTappedAllPackageButton:(NSButton *)button
{
    //选择ipa地址
    NSString *ipaPath = ipaPathTextField.stringValue;
    if(nil == ipaPath || [ipaPath isEqualToString:@""]){
        [DJProgressHUD showStatus:@"生产的ipa路径不能为空" FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
        return;
    }
    //获取需要打包或上传的target
    NSMutableArray *packageAndUploadArray = [NSMutableArray array];
    for (int i = 0; i<_dataSoruce.count; i++) {
        NSButton *checkButton = (NSButton *)[_myTableView viewWithTag:(200+i)];
        if(checkButton.state == NSOnState){
            TargetsInfoModel *model = _dataSoruce[i];
            [packageAndUploadArray addObject:model];
        }
    }
    if(packageAndUploadArray.count<1){
        [DJProgressHUD showStatus:@"请选择要打包上传的Target" FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
        return;
    }
    [DJProgressHUD showStatus:@"批量打包时间较长，正在打包，请稍等片刻..." FromView:_myScrollView];
    //启动一个time,每隔30s清空日志,
    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(resetButtonButton:) userInfo:nil repeats:YES];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    NSLog(@"Testing NSOperationQueue...");
    for (int i = 0; i < packageAndUploadArray.count; i++)
    {
        TargetsInfoModel *model = packageAndUploadArray[i];
        [queue addOperationWithBlock:^{
            //删除之前打包遗留下来的数据
            NSString *buildPath = [NSString stringWithFormat:@"%@build",projectPathTextField.stringValue];
            NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:buildPath];
            for (NSString *fileName in enumerator) {
                [[NSFileManager defaultManager] removeItemAtPath:[buildPath stringByAppendingPathComponent:fileName] error:nil];
            }
            NSString *packScriptPath = [[NSBundle mainBundle] pathForResource:@"ipa-build" ofType:@""];
            NSLog(@"packScriptPath = %@",packScriptPath);
            [DJProgressHUD showStatus:[NSString stringWithFormat:@"批量中%d/%lu，正在打包%@，请稍等片刻...",(i+1),(unsigned long)packageAndUploadArray.count,model.schemesName] FromView:_myScrollView];
            [self cmd:[NSString stringWithFormat:@"cd %@;%@ . -o %@ -t %@ -w -s %@ -k %@ -n",projectPathTextField.stringValue,packScriptPath,ipaPathTextField.stringValue,model.schemesName,model.schemesName,model.mobileprovisionRealName] WithALL:1];
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [DJProgressHUD dismiss];
    });
}
//批量上传按钮
-(void)didTappedAllUploadButton:(id)sender
{
    //选择ipa地址
    NSString *ipaPath = ipaPathTextField.stringValue;
    if(nil == ipaPath || [ipaPath isEqualToString:@""]){
        [DJProgressHUD showStatus:@"生产的ipa路径不能为空" FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
        return;
    }
    //获取需要打包或上传的target
    NSMutableArray *packageAndUploadArray = [NSMutableArray array];
    for (int i = 0; i<_dataSoruce.count; i++) {
        NSButton *checkButton = (NSButton *)[_myTableView viewWithTag:(200+i)];
        if(checkButton.state == NSOnState){
            TargetsInfoModel *model = _dataSoruce[i];
            [packageAndUploadArray addObject:model];
        }
    }
    if(packageAndUploadArray.count<1){
        [DJProgressHUD showStatus:@"请选择要上传ipa包的Target" FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
        return;
    }
    //查看该目录下面存在哪些ipa文件
    NSMutableString *noticeMsg = [NSMutableString string];
    for (TargetsInfoModel *model in packageAndUploadArray) {
        BOOL flag = NO;
        NSFileManager *manager=[NSFileManager defaultManager];
        NSArray *dirArray = [manager contentsOfDirectoryAtPath:ipaPathTextField.stringValue error:nil];
        for (NSString* str in dirArray) {
            NSArray *tmp_array = [str componentsSeparatedByString:@"_"];
            NSString *tmp_schemesName = tmp_array[0];
            if([model.cfbundleDisplayName isEqualToString:tmp_schemesName]){
                model.ipaPath = [NSString stringWithFormat:@"%@%@",ipaPath,str];
                flag = YES;
                break;
            }
        }
        if(flag == NO){
            [noticeMsg appendString:[NSString stringWithFormat:@"%@,",model.cfbundleDisplayName]];
        }
    }
    if(nil != noticeMsg && ![noticeMsg isEqualToString:@""]){
        [DJProgressHUD showStatus:[NSString stringWithFormat:@"%@,,,还没有打包,请重新攒则",noticeMsg] FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
        return;
    }
    [DJProgressHUD showStatus:@"批量上传时间较长，正在上传，请稍等片刻..." FromView:_myScrollView];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    NSLog(@"Testing NSOperationQueue...");
    for (int i = 0; i < packageAndUploadArray.count; i++)
    {
        TargetsInfoModel *model = packageAndUploadArray[i];
        [queue addOperationWithBlock:^{
            NSString *uploadScriptPath = [[NSBundle mainBundle] pathForResource:@"ipa_upload" ofType:@"sh"];
            NSLog(@"uploadScriptPath = %@",uploadScriptPath);
            [DJProgressHUD showStatus:[NSString stringWithFormat:@"批量中%d/%lu，正在上传%@，请稍等片刻...",(i+1),(unsigned long)packageAndUploadArray.count,model.schemesName] FromView:_myScrollView];
            [self cmd:[NSString stringWithFormat:@"sh %@ %@",uploadScriptPath,model.ipaPath] WithALL:1];
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [DJProgressHUD dismiss];
    });
}
//恢复默认按钮
-(void)resetButtonButton:(id)sender
{
    resultTextView.string = @"";
}
//打包按钮
- (void)packageBtnClicked:(NSButton *)sender
{
    NSString *ipaPath = ipaPathTextField.stringValue;
    if(nil == ipaPath || [ipaPath isEqualToString:@""]){
        [DJProgressHUD showStatus:@"生产的ipa路径不能为空" FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
        return;
    }
    TargetsInfoModel *model = [_dataSoruce objectAtIndex:(sender.tag - 100)];
    NSString *mobileprovisionPath = [NSString stringWithFormat:@"%@XingChangTong/Package/%@/%@_dis.mobileprovision",projectPathTextField.stringValue,model.schemesName,[model.schemesName lowercaseString]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:mobileprovisionPath]) {
        [DJProgressHUD showStatus:@"mobileprovision不存在" FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
        return;
    }
    [DJProgressHUD showStatus:[NSString stringWithFormat:@"%@正在打包，请稍等片刻...",model.cfbundleDisplayName] FromView:_myScrollView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //删除之前打包遗留下来的数据
        NSString *buildPath = [NSString stringWithFormat:@"%@build",projectPathTextField.stringValue];
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:buildPath];
        for (NSString *fileName in enumerator) {
            [[NSFileManager defaultManager] removeItemAtPath:[buildPath stringByAppendingPathComponent:fileName] error:nil];
        }
        NSString *packScriptPath = [[NSBundle mainBundle] pathForResource:@"ipa-build" ofType:@""];
        NSLog(@"packScriptPath = %@",packScriptPath);
        [self cmd:[NSString stringWithFormat:@"cd %@;%@ . -o %@ -t %@ -w -s %@ -k %@ -n",projectPathTextField.stringValue,packScriptPath,ipaPathTextField.stringValue,model.schemesName,model.schemesName,model.mobileprovisionRealName] WithALL:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [DJProgressHUD dismiss];
            //刷新当前列表
            [self readIpaDirectory];
//            system([[@"open " stringByAppendingString:[self getPathWithfileString:self.exportPathLabel.stringValue]] UTF8String]);
        });
    });
}
//上传按钮
-(void)uploadBtnClicked:(NSButton *)sender
{
    NSString *ipaPath = ipaPathTextField.stringValue;
    if(nil == ipaPath || [ipaPath isEqualToString:@""]){
        [DJProgressHUD showStatus:@"生产的ipa路径不能为空" FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
        return;
    }
    TargetsInfoModel *model = [_dataSoruce objectAtIndex:(sender.tag - 900)];
    NSString *fuckIpaPath = @"";
    //查看该目录下面存在哪些ipa文件
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *dirArray = [manager contentsOfDirectoryAtPath:ipaPath error:nil];
    for (NSString* str in dirArray) {
        NSLog(@"fromFileName : %@",str);
        NSArray *tmp_array = [str componentsSeparatedByString:@"_"];
        NSString *tmp_schemesName = tmp_array[0];
        if([model.cfbundleDisplayName isEqualToString:tmp_schemesName]){
            fuckIpaPath = [NSString stringWithFormat:@"%@%@",ipaPathTextField.stringValue,str];
            break;
        }
    }
    [DJProgressHUD showStatus:[NSString stringWithFormat:@"%@正在上传中，请稍等片刻...",model.cfbundleDisplayName] FromView:_myScrollView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *uploadScriptPath = [[NSBundle mainBundle] pathForResource:@"ipa_upload" ofType:@"sh"];
        NSLog(@"uploadScriptPath = %@",uploadScriptPath);
        [self cmd:[NSString stringWithFormat:@"sh %@ %@",uploadScriptPath,fuckIpaPath] WithALL:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [DJProgressHUD dismiss];
        });
    });
}
//日志处理
- (void)commandNotification:(NSNotification *)notification
{
    NSData *data = nil;
    while ((data = [demoFileHandle availableData]) && [data length]){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *lineString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"lineString  : %@",lineString);
            NSAttributedString* attr = [[NSAttributedString alloc] initWithString:lineString];
            [[resultTextView textStorage] appendAttributedString:attr];
            [resultTextView scrollRangeToVisible:NSMakeRange([[resultTextView string] length], 0)];
        });
    }
}
//执行shell命令
- (void)cmd:(NSString *)cmd WithALL:(int)flag{
    // 初始化并设置shell路径
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    // -c 用来执行string-commands（命令字符串），也就说不管后面的字符串里是什么都会被当做shellcode来执行
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
//    task.currentDirectoryPath = [[NSBundle  mainBundle] resourcePath];
    // 新建输出管道作为Task的输出
    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput: outputPipe];
    [task setStandardError:outputPipe];
    // 开始task
    demoFileHandle = [outputPipe fileHandleForReading];
    [demoFileHandle waitForDataInBackgroundAndNotify];
    if(flag ==1){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commandNotification:) name:NSFileHandleDataAvailableNotification object:nil];
    }
    [task launch];
    [task waitUntilExit];
    // 获取运行结果
//    NSData *data = [demoFileHandle readDataToEndOfFile];
//    NSString *result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//    NSLog(@"result  : %@",result);
}
-(NSString *)getProvisionUUID:(NSString *)cmd{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput: outputPipe];
    [task setStandardError:outputPipe];
    NSFileHandle *fileHandle = [outputPipe fileHandleForReading];
    [fileHandle waitForDataInBackgroundAndNotify];

    [task launch];
    [task waitUntilExit];
    
    NSData *data = [fileHandle readDataToEndOfFile];
    NSString *result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog(@"result  : %@",result);
    return result;
}
/**
 *  去掉file://协议头
 *  @param fileString 带协议头的路径
 *  @return 返回去掉协议头的路径
 */
- (NSString *)getPathWithfileString:(NSString *)fileString
{
    return [fileString substringWithRange:NSMakeRange(delegateLength, fileString.length - delegateLength)];
}
//读取项目根目录的相关信息，刷新tableview
-(void)readProjectDirectory
{
    //获取项目中的target
    NSString *pbxprojFileText=[NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@XingChangTong.xcodeproj/project.pbxproj",projectPathTextField.stringValue] encoding:NSUTF8StringEncoding error:nil];
    NSRange iStart = [pbxprojFileText rangeOfString:@"targets = ("];
    if (iStart.location != NSNotFound) {
        NSString *newStr1 = [pbxprojFileText substringFromIndex:iStart.location-1];
        NSRange iEnd = [newStr1 rangeOfString:@"/* End PBXProject section */"];
        if (iEnd.location != NSNotFound) {
            NSString *newStr2 = [newStr1 substringToIndex:iEnd.location-1];
            NSArray *array = [newStr2 componentsSeparatedByString:@" */,"];
            if(array.count > 0){
                [_dataSoruce removeAllObjects];
            }
            for (NSString *fuckStr in array) {
                NSArray *newArray = [fuckStr componentsSeparatedByString:@" /* "];
                if(newArray.count==2 && ![newArray[1] isEqualToString:@"XingChangTongTests"] && ![newArray[1] isEqualToString:@"XingChangTongUITests"]){
                    NSString *schemesName = newArray[1];
                    NSString *plistPath = [NSString stringWithFormat:@"%@XingChangTong/Package/%@/%@-Info.plist",projectPathTextField.stringValue,schemesName,schemesName];
                    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                    NSString *CFBundleDisplayName = [plistDict objectForKey:@"CFBundleDisplayName"];
                    NSString *CFBundleShortVersionString = [plistDict objectForKey:@"CFBundleShortVersionString"];
                    NSString *CFBundleVersion = [plistDict objectForKey:@"CFBundleVersion"];
                    
                    TargetsInfoModel *model = [[TargetsInfoModel alloc]init];
                    model.cfbundleDisplayName = CFBundleDisplayName;
                    model.schemesName = schemesName;
                    model.cfbundleShortVersionString = CFBundleShortVersionString;
                    model.cfbundleVersion = CFBundleVersion;
                    
                    NSString *mobileprovisionPath = [NSString stringWithFormat:@"%@XingChangTong/Package/%@/%@_dis.mobileprovision",projectPathTextField.stringValue,schemesName,[schemesName lowercaseString]];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:mobileprovisionPath]) {
                        model.mobileprovisionPath = @"存在";
                        NSString *provisionPath = [[NSBundle mainBundle] pathForResource:@"getmobileuuid" ofType:@"sh"];
                        
                        NSString *mobileprovisionRealName = [self getProvisionUUID:[NSString stringWithFormat:@"sh %@ %@",provisionPath,mobileprovisionPath]];
                        NSArray *tmpArray = [mobileprovisionRealName componentsSeparatedByString:@"UUID is:"];
                        
                        model.mobileprovisionRealName = [tmpArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    }else {
                        model.mobileprovisionPath = @"不存在";
                    }
                    [_dataSoruce addObject:model];
                }
            }
        }
    }
    if(_dataSoruce.count < 1){
        [DJProgressHUD showStatus:@"项目根目录不正确" FromView:self.view];
        [NSThread sleepForTimeInterval:2];
        [DJProgressHUD dismiss];
    }
    [self.myTableView reloadData];
}
//读取项目根目录的相关信息，刷新tableview
-(void)readIpaDirectory
{
    //查看该目录下面存在哪些ipa文件
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *dirArray = [manager contentsOfDirectoryAtPath:ipaPathTextField.stringValue error:nil];
    for (NSString* str in dirArray) {
        NSLog(@"fromFileName : %@",str);
        NSArray *tmp_array = [str componentsSeparatedByString:@"_"];
        NSString *tmp_schemesName = tmp_array[0];
        for (TargetsInfoModel *model in _dataSoruce) {
            if([model.cfbundleDisplayName isEqualToString:tmp_schemesName]){
                model.isPackFlag = YES;
            }
        }
    }
    [self.myTableView reloadData];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
