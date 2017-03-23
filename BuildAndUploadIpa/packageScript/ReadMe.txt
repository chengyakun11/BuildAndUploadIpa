
一、xcode选择好对应的证书和mobileprovision文件

二、打包
1、切换到项目源代码的根目录
	$ cd /Users/apple/Desktop/new_fuck_source/iOS/trunk/XingChangTong 
2、编译打包生产ipa文件（修改ipa-build的路径）
	$ /Users/apple/Desktop/MakePackage/ipa-build . -t XingChangTong -w -s XingChangTong -n

三、上传
1、修改ipa_upload.sh中的ipaPath的路径。（路径的地址为源代码根目录下build/ipa-build/的ipa文件）
2、执行上传ipa文件的命令。（修改ipa_upload.sh路径）
	$ sudo sh /Users/apple/Desktop/MakePackage/ipa_upload.sh





NSArray*Array = [[NSArray alloc] init];
Array = [NSBundle pathsForResourcesOfType:@"sh" inDirectory:[[NSBundle mainBundle]resourcePath]];
NSLog(@"%@", Array);


NSString* scriptPath = [[NSBundle mainBundle] pathForResource:@"hello" ofType:@"sh"];
NSLog(@"%@", scriptPath);
if(scriptPath){
NSArray* theArguments = [NSArray arrayWithObjects: @"/bin/sh", scriptPath, theName,nil];
NSTask* scriptTask = [[NSTask alloc] init];
NSPipe *pipe;
pipe = [NSPipe pipe];
[scriptTask setStandardOutput: pipe];
[scriptTask setStandardError: pipe];
NSFileHandle *file;
file = [pipe fileHandleForReading];
[scriptTask setLaunchPath: [theArguments objectAtIndex:0]];
[scriptTask setArguments: [theArguments subarrayWithRange: NSMakeRange (1,([theArguments count] - 1))]];
[scriptTask launch];
NSData *data;
data = [file readDataToEndOfFile];
NSString *string;
string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
NSLog (@"got\n%@", string);
} else {
NSLog(@"That dosn't exist");
}
