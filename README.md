# InveX

## Overview
InveX is an iOS application developed to support small, cash-run businesses in tracking their inventory and processing sales. It allows businesses to add their inventory, adjust their pricing and on-hand quantity, and track sales. The idea of InveX started when my family's business, Stryker Airsoft, was having trouble with the inventory management app they were using to track concessions. I set out to create an equal or better, free app.

InveX is written in SwiftUI and uses MongoDB's Realm for data persistence. After bouncing from CoreData, to Realm, to Firestore, I finally landed back on Realm for this application. I chose Realm because I want to keep the app completely free and give users a sense of security knowing that their data is completely theirs and stored on their device.

Realm's SDK has several SwiftUI property wrappers that could have been taken advantage of, but just in case I decide to move the data storage to the cloud in the future I decided to use their asynchronous functions so the app's architecture mimics what it would be if it were cloud based.

Though this wasn't the first iOS app I've worked on, I used this project as a means to reach a few goals that I haven't pursued in any other app - the largest being a successful app store submission. 

## Project / Version 1.0 Goals
- Submit to App Store
- Responsive views for all device sizes and orientations
- Light/Dark mode
- Encryption for passcode storage

## Responsive Design
Today, responsive interfaces are not just common, they're expected. Up until this project I put my focus on designing interfaces for a single screen, typically whichever iPhone I had at the time, without putting thought into how they look on others. In InveX, I utilized `ViewThatFits`, `LazyGrids`, and the Environment's `SizeClass` to ensure the app looks correct on all devices. In addition, I learned how important it is to track where you set view `frame` sizes and `padding`.

### Theme Text Field
Since text fields are frequent throughout InveX, I developed my `ThemeTextField` compenent which is aware of its parent's size and can adjust itself accordingly. Like many apps, I wanted to give a title, description, and the field to many of my text fields. `ThemeTextField` is designed to lay itself out with the text field on the side whenever possible, otherwise it will stack itself vertically. It also changes appearance based on the app's asset catalog so it can be re-used in the future.

## Light/Dark Mode
Light and dark mode adaptations are handled through the asset catalog's colors. I learned that the trick to use the asset catalog for colors is simply to be cautious and consistent whenever creating a UI compenent - this goes for everything from text color to background color. 

> The earlier in development this is configured, the less refactoring that will be required later.

## AuthService & Encryption
InveX allows users to lock the screen in case they need to step away from their point of sale. It uses a simple `AuthService` and `CryptoKit` to store the user's passcode in `UserDefaults`. 

When the app opens, `RootView` uses the `Combine Framework` to determine if the user has created an account. If a passcode doesn't exist in `UserDefaults`, the `OnboardingView` is shown. While onboarding, the user will enter a passcode which will be passed to AuthService, encrypted with `SHA256` by `CryptoKit`, then saved to UserDefaults. The hash is then fetched and compared each time the user enters their passcode.

## Passcode View
 To allow for reusability in Onboarding, Change Passcode, and Lock Screen scenarios, this view
 is initialized with an array of processes that can either be `.confirm` or `.set`. Every time
 a passcode is submitted to the ViewModel it takes the first process in the array and runs it's
 logic. If the logic for that process is executed successfully, the first process is removed
 from the array. The last line of `passcodeSubmitted()` checks if `processes` is empty. If it
 is empty, there are no more tasks that need to be complete and `onSuccess()` can be called.

 - `passcodeHash` is initialized to `AuthService.passHash` and will be an empty string if no 
     passcode hash exists in UserDefaults.
 - `onSuccess()` is used once all processes are run to execute cleanup functions in parent views.
 - `showTitles` is used to give parent views control over whether or not the header buttons/titles 
     are visible

 Onboarding Processes => `[.set]` 
     - The user has never created a passcode

 Change Passcode Processes => `[.confirm, .set]`
     - The user wants to change their passcode but they need to enter their current passcode first.

 Lock Screen Processes => `[.confirm]`
     - The user has a passcode set and has no intention of changing it. They need to enter the 
     passcode and unlock the app if it is correct

 The `.set` process:
     When the user is setting a passcode they will need to enter the new passcode twice to ensure 
     they intended to submit the passcode. Initially, `passcodeHash` needs to be an empty string.
     When a passcode is submitted while `passcodeHash` is empty, `passcodeHash` will be set to
     the hash of the new code but they still need to enter the code again so `.set` is not removed
     from the process array. When they submit a passcode a second time, the new hash will be
     compared to the previously entered `passcodeHash` - if they match, the new passcodeHash is
     saved and the `.set` process is finished so it is removed, otherwise an error for mismatched
     passcodes is thrown and `passcodeHash` is cleared so the user will restart the `.set` process.

 The `.confirm` process:
     When the user is confirming a passcode, `AuthService.passHash` must not be empty otherwise there 
     would be nothing to compare passcodes to. `passcodeHash` is initialized to `AuthService.passHash`.
     When a passcode is submitted, check if the new hash matches `passcodeHash`. If the passcode hashes
     match, remove `.confirm` from the process array and set `passcodeHash` to an empty string in
     case the user needs to set a new passcode immediately after.

## Realm
While creating version 0.1 of Invex, I bounced between CoreData and Realm several times. I eventually opted for Realm because of the SwiftUI Property Wrappers they offer like `ObservedResults`. While developing version 1.0, which was released to the App Store, I decided I would take a different approach and develop the app as if it were communicating with a cloud-based database - `RealmActor` handles all communication with Realm via their async functions.

`RealmActor`'s methods are generally `@MainActor`, `asynchronous`, and they `throw` any custom AppErrors related to Realm.

** Note: Better app performance can likely be achieved by using the property wrappers. RealmActor was developed more as practice.

```swift
    @MainActor
    func fetchDepartments() async throws -> Results<DepartmentEntity> {
        let realm = try await Realm()
        return realm.objects(DepartmentEntity.self)
    }
    
    func addDepartment(name: String, restockThresh: String, markup: String) async throws {
        // ...
        let department = DepartmentEntity(name: name, restockNum: restockThresh, defMarkup: markup)
        try await realm.asyncWrite {
            realm.add(department)
        }
    }
```

### Database Migration
 The app handles Realm database migration. The `RealmMigrator` class sets the schema version and provides a migration block to manage changes in the schema version. The `RealmMigrator` should be able to handle the majority of database changes by simply increasing the `schemeVersion`. 

 ```swift
class RealmMigrator {
    let currentSchemaVersion: UInt64 = 59
    
    init() {
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < self.currentSchemaVersion) {
                migration.enumerateObjects(ofType: DepartmentEntity.className()) { oldObject, newObject in }
                // ...
            }
        })
        
        do {
            _ = try Realm(configuration: config)
        } catch {
            debugPrint("Error initializing Realm:\n \(error.localizedDescription)")
        }
    }
    
}
 ```

## Custom Navigation Structure
Version 1.0 of InveX uses a custom navigation structure where the orientation and screen size of the device had to be manually handled. Screen sizes were monitored by their height and width, in addition to whether they are in landscape mode or not. The custom navigation allowed for the small menu sidebar to appear on the far left of the screen while the full menu is closed. On the PointOfSaleView, the cart appears on the right hand side. 

### Layout Rules

- The RootView determines the initial state of the menu and cart
    ```swift
    init(uiProperties: LayoutProperties) {
        self.uiProps = uiProperties
        
        if uiProps.width < 680 {
            // Both menu and cart should default to closed
            menuState = .closed
            cartState = .closed
        } else if uiProps.width < 840 {
            // Menu should default to closed. Cart should default to sidebar
            menuState = .closed
            cartState = .sidebar
        } else {
            // Screen is wider than 840
            // Menu should default to compact. Cart should default to sidebar
            menuState = .compact
            cartState = .sidebar
        }
    }
    ```

- The menu is only allowed to show as a compact sidebar when:
    ```swift
    var shouldShowMenu: Bool {
        let c1: Bool = cartState != .confirming
        let c2: Bool = uiProps.width > 840
        let c3: Bool = menuState == .open
        let shouldShow = (c1 && c2) || c3
        return shouldShow
    }
    ```

- The cart is allowed to show as a sidebar when the width of the screen is greater than 680 (a little less than an iPad in portrait mode. If the cart is being displayed on a smaller screen it should only toggle between taking up the full width of the screen and being hidden entirely.
    ```swift
    func toggleCart() {
        var newState: CartState = .closed

        newState = switch true {
        case uiSize.width < 680: .confirming
        case cartState == .closed: .sidebar
        case cartState == .confirming: .confirming
        default: .closed
        }
    }
    ```

- The menu can't be open while the cart is a sidebar
    ```swift
    if menuState == .open && cartState == .sidebar {
        menuState = .closed
    }
    ```

- Only allow the cart sidebar to be shown on larger screens
    ```swift
    if uiSize.width > 680 && cartState == .sidebar {
        ResponsiveView { properties in
            CartView(cartState: $cartState, menuState: $menuState, uiSize: uiSize)
                .environmentObject(vm)
        }
        .frame(maxWidth: cartState.idealWidth)

    }
    ```

- If the view is large enough, always show a compact menu instead of hiding it.
    ```swift
        /// Open or close the menu depending on the current MenuState. On large screens the menu never closes fully, so .compact is considered .closed for larger screens.
        func toggleMenu() {
            var newMenuState: MenuState = (menuState == .closed || menuState == .compact) ? .open : .closed
            
            if newMenuState == .closed && uiProps.width > 840 {
                newMenuState = .compact
            }
            
            withAnimation(.interpolatingSpring) {
                menuState = newMenuState
                if menuState == .open {
                    cartState = .closed
                }
            }
        }
    ```

## Menu: External Tap Detection
Use a nearly-invisible background to detects taps that occur outside of the menu -> close the menu.
    ```swift
     Group {
         switch currentDisplay {
            // ...
         }
     }
     .background(.accent.opacity(0.0001))
     .onTapGesture(coordinateSpace: .global) { location in
         if menuState == .open {
             withAnimation(.interpolatingSpring) {
                 menuState = .closed
             }
         }
     }
     .opacity(contentOpacity)
    ```
