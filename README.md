# Nuxeo iOS projects

## Deprecated

This project is now **deprecated**. But, you might want to check our new repository about [Nuxeo SDK iOS](https://github.com/nuxeo/nuxeo-sdk-ios).

## Nuxeo AutomationClient

Nuxeo AutomationClient using an automation client written in Objective C.

For now, it's only a sample project that allows you to navigate through a Nuxeo repository and performing a fulltext search using [Content Automation](http://doc.nuxeo.com/x/mQAz).

Our next targets are to enhance the automation client:
  - Manipulate object instead of dictionnaries (JSON result).
  - Correctly handle HTTP results code / and anonymous navigation enabled
  - Have a correct error handling

## Nuxeo SDK

Nuxeo SDK is using our Document oriented REST API using.

REST / CRUD mapping are done using [RestKit](https://github.com/RestKit/RestKit)

### How to build Nuxeo SDK using CocoaPods

    $ cd NuxeoSDK
    $ gem install cocoapods
    $ pod setup
    $ pod
    $ open NuxeoSDK.xcworkspace


## About Nuxeo

Nuxeo provides a modular, extensible Java-based [open source software platform for enterprise content management](http://www.nuxeo.com/en/products/ep) and packaged applications for [document management](http://www.nuxeo.com/en/products/document-management), [digital asset management](http://www.nuxeo.com/en/products/dam) and [case management](http://www.nuxeo.com/en/products/case-management). Designed by developers for developers, the Nuxeo platform offers a modern architecture, a powerful plug-in model and extensive packaging capabilities for building content applications.

More information on: <http://www.nuxeo.com/>
