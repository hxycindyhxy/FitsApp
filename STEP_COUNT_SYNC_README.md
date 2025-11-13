# Step Count Sync Integration

This document explains the changes made to integrate step count synchronization from the Apple Watch app to the iOS app.

## Overview

When a user completes a walk on their Apple Watch, the step count is now automatically synchronized to the iOS app's TreeViewModel, allowing the tree to grow based on accumulated steps from both devices.

## Files Modified

### Watch App
1. **appleWatch Watch App/ContentView.swift**
   - Added `StepCountSync.shared.addStepsFromWatch(count)` when the user taps to confirm their walk
   - This syncs the step count to shared UserDefaults

2. **appleWatch Watch App/StepCountSync.swift** (NEW)
   - Utility class for managing step count synchronization via shared app group UserDefaults
   - Provides methods: `getTotalStepCount()`, `addStepsFromWatch()`, `resetStepCount()`, `setStepCount()`

### iOS App
1. **FitsApp/ViewModel/TreeViewModel.swift**
   - Modified to load step count from `StepCountSync.shared` instead of a local variable
   - Added observer for UserDefaults changes to real-time update the step count
   - Now syncs with the watch app automatically

2. **FitsApp/Utilities/StepCountSync.swift** (NEW)
   - Same utility class as watch app (mirrors functionality)
   - Handles all shared data access

## Configuration Required

To make this work, you need to enable App Groups in both targets:

### For iOS Target (FitsApp):
1. Open FitsApp.xcodeproj in Xcode
2. Select the "FitsApp" target
3. Go to Signing & Capabilities tab
4. Click "+ Capability" and search for "App Groups"
5. Add the capability
6. Set the App Group identifier to: `group.com.fitsapp.shared`

### For Watch Target (appleWatch Watch App):
1. Select the "appleWatch Watch App" target
2. Go to Signing & Capabilities tab
3. Click "+ Capability" and search for "App Groups"
4. Add the capability
5. Set the App Group identifier to: `group.com.fitsapp.shared`

**Important:** Both targets must use the EXACT same App Group identifier for synchronization to work.

## How It Works

1. **Watch App**: When the user completes a walk and taps the screen, `StepCountSync.shared.addStepsFromWatch(count)` is called
2. **Shared Storage**: The step count is saved to the app group's UserDefaults
3. **iOS App**: TreeViewModel observes changes to the shared UserDefaults and automatically updates its `stepCount` property
4. **UI Update**: The tree grows based on the accumulated step count (1 segment per 5,000 steps)

## Testing

1. Build and run the watch app on your Apple Watch simulator
2. Complete a walk (tap the screen to record steps)
3. Build and run the iOS app
4. The tree should display based on the step count from the watch
5. If you complete another walk on the watch, the iOS app should update automatically
