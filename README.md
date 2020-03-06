# VServer

## Salient Points

This is a prototype application to show a server onboarding journey. While there are only 3 screens and a fairly simple workflow, this showcases an extensible app architecture that will scale. 

The app code includes unit test cases, UI test cases and provision for snapshot testing.

## Status

- I have finished all 3 screens and the behaviour is as per the spec. There are 10 unit test cases and 3 UI Test Cases to test the app.

## Whats Not Finished

- Did not finish UI Test case for login screen. The UI test cases are there for other screens for reference.
- Did not have enough time to write snapshot test cases.
- UI Test cases needs to be run manually changing the App Delegate to point to the specific screen. I did not have time to add the launch environment utilty to flip the screen for UI Testing.

## Implementation

- The app is written using RxSwift.
- The app uses MVVM + Coordinator pattern.
- Coordinator pattern has a fairly simple event triggered FSM. A more involved app may need a (State, Event) driven FSM that can be tested too and leaving the side affects (instantiating view controllers) untested or tested separately.

## Test Cases

- Unit Tests are written using XCTest
- UI Tests written are using XCUITest. I personally prefer to test individual screens instead of testing the screens in a flow as they tend to get fragile very soon. For this demonstration, I will not have the time to write the hooks and utility to load individual screens for testing and it will require to manually point to the right screen in AppDelegate. 
- Snapshots Tests will be written using Pointfree snapshot library. I will struggle to finish that though.
- I have kept test cases next to the code so it is easier to see the test coverage for individual code files.

## Styling

- Not much effort has been put into styling for the screens. Instead I have put more effort on demonstrating the architecture and the testability of the code.
- All screens uses UIStackView for layout and screens are created in storyboard for quick iteration. The styling is done in both storyboard and in code though I prefer to do styling in code so it can be tested on its own.
- Storyboards are used for creating View Controllers but the navigation will be managed using Controller pattern and that will be unit tested too.

## Open Source + Sample Code

- The app uses Swiftlint, RxSwift, Snapshot testing open source libraries. I have been using Rx for my projects lately and the app uses Rx to drive the app end to end.
- I picked some common utilities and extensions that I generally use in all my projects and they are added as various extensions to UIKit or Rx.

## Changes in Networking Code
- I changed the IP Address for already authenticated server 192.268.0.11. 268 is probably a typo and was failing IP address validation.
