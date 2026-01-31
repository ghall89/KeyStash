# macos-template

A template for creating native macOS apps without using Xcode.

While the starter code uses SwiftUI, there should be no issues if you prefer to use AppKit to develop your UI. 

## Prerequisites

- [task](https://taskfile.dev/)
- [mint](https://github.com/yonaskolb/Mint)
    - [swift-bundler](https://swiftbundler.dev/documentation/swift-bundler)
- [create-dmg](https://github.com/create-dmg/create-dmg) 

## Setup

### Install Tooling

1. Install task, mint, and create-dmg, if they aren't already installed. The suggested way to do this is through [homebrew](https://brew.sh)
    - task - `brew install go-task`
    -  mint - `brew install mint`
    - create-dmg - `brew install create-dmg`
2. Install swift-bundler with mint - `mint install stackotter/swift-bundler@main`

### Add Credentials For Code Signing and Notarization

If you're going to sign and notarize your application (not required, but suggested if you will be distributing your application), you will need a few things:

1. An [Apple Developer Program membership](https://developer.apple.com/programs/)
2. Either a Keychain profile with login credentials for the Apple ID associated with your Developer Program membership, or [an app-specific password](https://support.apple.com/en-us/102654)
3. A [Developer ID Application certifiate](https://developer.apple.com/help/account/certificates/create-developer-id-certificates/)

Create a file in the project root with the name `.env` and copy the contents of `.env.example` into it, and fill out the following:

- `NAME` - The name of your Developer ID certificate. The name of the certificate you use _must_ begin with `Developer ID Application:` or it will not work.
- `KEYCHAIN_PROFILE` - The name of your Keychain profile, or the name of the profile you'd like to create.

#### Creating a Keychain Profile

If you need to create a Keychain profile, also fill out the following:

- `APPLE_ID` - The email address you use to log in to the Apple account associated with your Developer Program membership
- `PASSWORD` - An app-specific password associated with your Apple account, I suggest [creating a new one](https://support.apple.com/en-us/102654) to use for this process.

Finally, run `task store:credentials` in your terminal from the project root. This will create a profile in your system Keychain (viewable in Keychain.app) with the name you specified in `KEYCHAIN_PROFILE`.

## Configuration

Most of the configuration will happen in `Bundler.toml`. You can find the full documentation [here](https://swiftbundler.dev/documentation/swift-bundler/configuration), but I've come across a few innacuracies, which are corrected in the `Bundler.toml` file included in this template:

- `identifier` is incorrect, and should be `bundle_identifier`
- `[apps.HelloWorld.plist]` is incorrect, and should be `[apps.AutoDock.extra_plist_entries]`

There may be other inaccuracies that I have not come across.

### App Name and Bundle Identifier

Be sure to set the name of your app and its bundle ID in `Bundler.toml` and in `Taskfile.yml`. The easiest way to do this at the moment is to a project-wide find and replace in your editor for "HelloWorld", though you will still have to manually change `bundle_identifier` in `Bundler.toml`.

## Debugging

To run your app in "debug" mode, run `task debug`. 

This is ideal for testing your app, as logs will be printed directly to your terminal. If needed, you can force quit your app from the terminal with `ctrl` + `C`.

## Building and Distribution

### Build

To build your app, run `task build`.

This will output your binary to `.build/bundler/HelloWorld.app`. 

### Sign

First, ensure you have a `.env` file the project root with `NAME="Developer ID Application: <your name> (<team id>)"`, as descrbed in the [Code Signing & Notarization section](#add-credentials-for-code-signing-and-notarization). Then, to sign your application, run `task sign`. To verify your app was signed, run `task verify`. You should see the following output:

```
.build/bundler/HelloWorld.app: valid on disk
.build/bundler/HelloWorld.app: satisfies its Designated Requirement
```

### Create Disk Image

Before notarizing your app, you will need to create a disk image containing your application. Simply run `task disk-image`, and it will package your application in a disk image, and save it to a new folder called `dist`.

### Notarize

Finally, run `task notarize`. This will upload your disk image to Apple's servers and, if successful, will "staple" the response to your disk image. 

Your app is now ready to share!

## Final Notes

This template, as well as the documentation, is a work in progress. I would like to make the developer experience for setting up a new project with this template as nice as possible. 

If you have any thoughts, questions, or comments, please reach out to me on [Mastodon](https://mastodon.social/@ghalldev), or create an issue.
