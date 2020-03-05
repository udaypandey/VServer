# VServer

## Salient Points

This is a prototype application to show a server onboarding journey. This is still WIP and I will continue to update the code. While there are only 3 screens that needs to be build, I have used the architecture that I may use for a real enterprise app. 

The app code is structured accordingly and includes unit test cases, UI test cases and provision for snapshot testing.

## Status

- I have got it running end to end now.
- Unit test cases and UI Test cases are pending for Login screen
- Flow tests is commented out for Server screen.

## Implementation

- The app is written using RxSwift.
- The app uses MVVM + Coordinator pattern.


## Test Cases

- Unit Tests are written using XCTest
- UI Tests written are using XCUITest. I personally prefer to test individual screens instead of testing the screens in a flow as they tend to get fragile very soon. For this demonstration, I will not have the time to write the hooks and utility to load individual screens for testing and it will require to manually point to the right screen in AppDelegate. 
- Snapshots Tests will be written using Pointfree snapshot library. I will struggle to finish that though.
- I have kept test cases next to the code so it is easier to see the test coverage for individual code files.

## Styling

- Not much effort has been put into styling. Instead I have put more effort on the architecture and the testability of the code.
- All screens uses UIStackView for layout and screens are created in storyboard for quick iteration. The styling is done in both storyboard and in code though I prefer to do styling in code so it can be tested on its own.
- Storyboards are used for creating View Controllers but the navigation will be managed using Controller pattern and that will be unit tested too.

## Open Source + Sample Code

- The app uses Swiftlint, RxSwift, Snapshot testing open source libraries. I have been using Rx for my projects lately and the app uses Rx to drive the app end to end.
- I picked some common utilities and extensions that I generally use in all my projects and they are added as various extensions to UIKit or Rx.

## Changes in Networking Code
- I changed the IP Address for already authenticated server 192.268.0.11. 268 is probably a typo and was failing IP address validation
