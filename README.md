# Flickr Album
Flickr Album is an iOS Application designed for displaying pictures and their detail. User can also search specific picture by searching according to the keywords.

Demo Video Link: **[Flickr Album - iOS ](https://www.youtube.com/watch?v=b3X425LFpsE&ab_channel=HassanShahid)**
#### System Architecture:
This application was developed on Xcode IDE. Xcode is used for creating native iOS, watchOS, tvOS applications. Xcode does not generate the code for any application. The developer has to design the screens first and then connect the code with the design.

### Features:
This app has following major features:
1. UI has been created programmatically
2. Displaying the pictures with the title info
3. Ability to open the full size image
4. User can search the pictures by using keywords
5. Object Mapper technique has been used for mapping API responses
6. Data Cache to present when the internet is not available
7. Pull to refresh (API Call)
8. Internet Connectivity Management
9. Unit and UI Testing has been performed
10. The MVVM design pattern has been used
11. Serach on the bases of predefine keywords

**Models:**
1. FlickrAlbumPhotosResponse (Main Object for the API Response)
2. FlickrAlbumAllPhotos (Second inner object)
3. FlickrAlbumPhoto (Array of pictures with detail)

**ViewModels:**
1. PhotosVM (It is the ViewModel where I bind the API data response to the ViewController)

**Controllers:**
1. PhotosVC (Where all pictures with title info can be seen)

**File Naming Conventions:**
* **VC** are ViewControllers
* **VM** are ViewModels
* **CCell** are CollectionViewCells
* **TCell** are TableViewCells

There is another folder in the app:
**Helpers:**
1. **Constants** (constants used in the app such as URLs)
2. **Extensions** (useful feature that helps in adding more functionality to an existing Class and written one time to access anywhere)
3. **ServerManager** (API calls)

App images are places in **Assets.xcassets** folder

### Cocoapods:

Flickr Album uses a number of open source 3rd Party Libraries for better user experience:

* [SDWebImage](https://github.com/SDWebImage/SDWebImage) - Asynchronous image downloader with cache support as a UIImageView category. Indicator(Loader/Spinner)
* [Alamofire](https://github.com/Alamofire/Alamofire) - An HTTP networking library..
* [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper) - An extension to Alamofire which automatically converts JSON response data into swift objects using ObjectMapper.
* [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper) - ObjectMapper is a framework written in Swift that makes it easy for you to convert your model objects (classes and structs) to and from JSON.
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) - SwiftyJSON makes it easy to deal with JSON data in Swift.
* [DataCache](https://github.com/huynguyencong/DataCache) - This is a simple disk and memory cache. It can cache basic swift type
* [DropDown](https://github.com/AssistoLab/DropDown) - A Material Design drop down for iOS written in Swift.
* [SnapKit](https://github.com/SnapKit/SnapKit) - SnapKit is a DSL to make Auto Layout easy on both iOS and OS X.
* [GSImageViewerController](https://github.com/wxxsw/GSImageViewerController) - GSImageViewerController is used to open the picture in full size with animation.

### Support:
In case of any errors or app crashes please email me at:

Hassan Shahid ( [hassan .shahid94@yahoo.com](hassan.shahid94@yahoo.com) )


----


**Last Updated: 02.05.2021**
