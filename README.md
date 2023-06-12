# Staring-Home-Task

Author: Alexandru Pop

## Product Assumptions

- No authentication refresh mechanism is required, test app user can just pass in a basic auth token if current one expired/is missing
- Auth token shall be stored in keychain and deleted upon expiry
- When the client receives an unauthenticated response, it will automatically clear the auth token and prompt the user to insert a new one
- No loading & error states are needed; the product should allow easily appending those states afterwards
- No persistent storage solution is needed for other entities than auth token (e.g. FeedItem)
- No error handling UI needs to be implemented
- Round up is considering all settled outgoing transactions since 7 days ago midnight client date, with no option to select other timeframes
- Round up can be executed every time the user enters the Transactions screen, even if already previously executed for same data set
- Round up idempotency key should be randomly generated every time the user presents the intent to perform a new round up action (e.g. enters the round up screen / refreshes it in case of error)
- No log out mechanism is needed; user will be logged out once the auth token expires
- Application interacts with FIAT currencies only and considers default minorUnit multiplcation factor be 100

## Engineering assumptions & considerations

- **UI testing**: no need to implement it as is right now; for future reference should be implemented to make sure critical paths of each flow is working as expected, considering a mocked api interaction (e.g. proxying/mock BE etc.)
- **Unit testing**: given/when/then simple unit testing covering meaningful cases & potential edgecases of each component; unit definition can depend on the context; XCTest Framework is used; consider Quick & Nimble for better readability and faster coverage of complex test cases; additionally, data content which has no impact on test relevance (e.g. ids, strings etc.) will be taken as random; further infrastructure could be used to ensure reproductibility of those random states to gradually increase edge case converage;
- **Snapshot testing**: no need to be implemented as is right now; for future reference should be used to assert individual UI components look as expected;
- **Security**: standard TSL encryption & no local storage to be sufficient; consider E2E encryption with digital signature for each client version;
- **Generic**: 
    - no modules/packages separation is need as it's a simple demo app
    - flows should provide simple way to unit test navigation, replacing the need for UI testing as of now
    - data transfer objects implementation is not required as models complexity is low
    - unit testing models encoding/decoding is not required, but can be appended if needed
    - unit testing extensions is not required, but can be appended if needed
    - networking client considers simple straightforward cases: no requests reauthorization/ retry queue; results are returned on main queue by default
    - mocking is done manually but code generation tools should be considered (e.g. sourcery)
    - no static code analsys needs to be appended (e.g. swiftlint)
    - no bundle/build analysis and report tools need to be appended (e.g. ipa size breakdown, unused code etc.)
    - no localization is needed; raw string values will be used

## Architecture

Standard MVVM architecture with few additions:
- *flows*: meant to encapsulate navigation
- *screen interactors*: stateless, meant to encapsulate more complex bits of business logic and substract the responsibilit from VM


<p align="center">
  <img src="https://github.com/apphx/Staring-Home-Task/blob/13a30156781dc3d49b92b3bcadf2f2567fd5025e/Docs/Architecture.png" alt="Architecture"/>
</p>
