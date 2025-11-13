# How to Add App Groups Capability in Xcode

App Groups allows your iOS app and Watch app to share data via UserDefaults. Follow these steps to enable it for both targets.

## Step 1: Open Your Project in Xcode

1. Open `FitsApp.xcodeproj` in Xcode
2. The project should appear in the left sidebar

## Step 2: Add App Groups to iOS Target (FitsApp)

### 2a. Select the iOS Target
1. Click on the project name in the left sidebar ("FitsApp")
2. In the main area, you'll see a list of targets
3. Select the **"FitsApp"** target (the iOS app, not the watch app)

### 2b. Open Signing & Capabilities
1. Click on the **"Signing & Capabilities"** tab at the top
2. You should see existing capabilities like "App Groups" or "Team ID"

### 2c. Add the App Groups Capability
1. Click the **"+ Capability"** button in the top-left corner
2. A search box will appear
3. Type **"App Groups"** in the search box
4. Click on **"App Groups"** from the results

### 2d. Set the App Group Identifier
1. After adding the capability, you'll see a section titled "App Groups"
2. You'll see a text field with a placeholder or empty value
3. Click the **"+"** button to add a new app group
4. Enter the following identifier:
   ```
   group.com.fitsapp.shared
   ```
5. Make sure it matches EXACTLY (including the dots and "group." prefix)

**Your iOS target should now look like this:**
```
App Groups
├── group.com.fitsapp.shared ✓
```

---

## Step 3: Add App Groups to Watch Target (appleWatch Watch App)

### 3a. Select the Watch Target
1. In the same project settings window, look for the list of targets
2. Select the **"appleWatch Watch App"** target

### 3b. Open Signing & Capabilities
1. Click on the **"Signing & Capabilities"** tab
2. This tab is for the watch app now

### 3c. Add the App Groups Capability
1. Click the **"+ Capability"** button
2. Search for **"App Groups"**
3. Click on **"App Groups"**

### 3d. Set the App Group Identifier
1. Click the **"+"** button to add a new app group
2. Enter the SAME identifier as before:
   ```
   group.com.fitsapp.shared
   ```
3. Must match EXACTLY

**Your Watch target should now look like this:**
```
App Groups
├── group.com.fitsapp.shared ✓
```

---

## Step 4: Verify Both Targets Have the Same ID

This is **CRITICAL** for synchronization to work!

✓ iOS target (FitsApp): `group.com.fitsapp.shared`
✓ Watch target (appleWatch Watch App): `group.com.fitsapp.shared`

Both must be **IDENTICAL**.

---

## Step 5: Build and Run

1. Select your iOS simulator/device as the target
2. Press **Cmd + B** to build
3. Press **Cmd + R** to run

The app should build without errors related to App Groups.

---

## Troubleshooting

### Issue: "Unable to decipher container manifest at path"
**Solution:** Make sure both targets have the EXACT same App Group identifier

### Issue: Steps not syncing between watch and iOS
**Solution:**
1. Check that both targets have the capability added
2. Verify the App Group IDs are identical
3. Clean build folder: **Cmd + Shift + K**
4. Delete the app from simulator/device
5. Rebuild and run

### Issue: Can't find the "+" Capability button
**Solution:**
1. Make sure you're on the "Signing & Capabilities" tab
2. Make sure the correct target is selected (not the project)
3. If you don't see the button, try scrolling right or looking at the top-right corner

---

## Visual Reference

Here's what you should see in Xcode:

```
PROJECT NAVIGATOR (Left)
├── FitsApp (Project)
│   └── TARGETS
│       ├── FitsApp (iOS) ← Select this first
│       └── appleWatch Watch App ← Select this second

EDITOR (Right)
├── Signing & Capabilities (Tab)
│   └── + Capability (Button in top-left)
│       └── App Groups
│           └── group.com.fitsapp.shared
```

---

## What App Groups Does

With App Groups configured:
- Both apps share a common UserDefaults container
- When the watch app saves steps to `UserDefaults(suiteName: "group.com.fitsapp.shared")`
- The iOS app can read those same steps
- Data syncs in real-time between the two apps
