SwiftHN
=======

#### A Hacker News reader in Swift using the best features of both the language and iOS 8 latest API (well, that's the end goal)


![screen-1](https://raw.githubusercontent.com/Dimillian/SwiftHN/master/git_images/images.png)

SwiftHN is now available on the [App Store](https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=919243741&mt=8)! I've renamed it to HN Reader for obvious reason. 

##### ETA
=======
# Installation
Clone this repository.
```shell
$ git clone --recursive https://github.com/Dimillian/SwiftHN
```

Incase you cloned the repository without the `recursive` option, you will have
to manually install the HackerSwifter submodule.
```shell
$ cd SwiftHN
$ git submodule init
$ git submodule update
```

Open using Xcode.
```shell
$ open SwiftHN.xcodeproj
```

# Features

* Now link with its own Hacker News Swift scrapping library, [HackerSwifter](https://github.com/Dimillian/HackerSwifter). This is still a work in progress but it support the most basic features. This is linked as a submodule, so be sure to clone it too (I'm looking at you Github for Mac)
* The podfile is now useless, you may still run pod install to setup the project.
* A basic UI which respect latest Apple guidelines
* Use Swift features such as extension, framework, etc...
* Display HN home categories (Top, Ask, Jobs..)
* Load and display comments per posts.
* Load and display posts per user
* Share, Add to reading list, read in webview
* Live view rendering in Interface Builder
* Class Extensions
* Today and share extensions
* Clean design pattern
* More...

The app is in progress, but already functional, you can read the newsfeed, send article to the Safari Reading List, view the article in a webview, and load comments. 

You can contribute to the app, just do a pull request. You can even contribute to the design in Sketch if you want!

# Planned features

* Login
* Settings
* Upvote post & comments
* Post comments
* Today extension which show 3 latest posts in notification center
* Safari/Share extension to post a page to Hacker News
