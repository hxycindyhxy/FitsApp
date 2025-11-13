#!/bin/bash

# Debug script to check if StepCountSync files are properly configured

echo "🔍 Checking FitsApp project setup..."
echo ""

PROJECT_PATH="/Users/cindyhu/Desktop/TestingTesting/OneMOre/FitsApp/FitsApp"

# Check if files exist
echo "1️⃣  Checking if StepCountSync.swift files exist:"
if [ -f "$PROJECT_PATH/FitsApp/ViewModel/StepCountSync.swift" ]; then
    echo "   ✅ iOS app StepCountSync.swift found"
else
    echo "   ❌ iOS app StepCountSync.swift NOT found"
fi

if [ -f "$PROJECT_PATH/appleWatch Watch App/StepCountSync.swift" ]; then
    echo "   ✅ Watch app StepCountSync.swift found"
else
    echo "   ❌ Watch app StepCountSync.swift NOT found"
fi

echo ""
echo "2️⃣  Checking if files are in Xcode project.pbxproj:"

if grep -q "StepCountSync" "$PROJECT_PATH/FitsApp.xcodeproj/project.pbxproj"; then
    echo "   ✅ StepCountSync found in project.pbxproj"
else
    echo "   ⚠️  StepCountSync NOT found in project.pbxproj"
    echo "      This means the files may not be added to Xcode targets!"
fi

echo ""
echo "3️⃣  Checking for App Groups capability:"

if grep -q "group.com.fitsapp.shared" "$PROJECT_PATH/FitsApp.xcodeproj/project.pbxproj"; then
    echo "   ✅ App Groups found in project.pbxproj"
else
    echo "   ⚠️  App Groups NOT found in project.pbxproj"
    echo "      Make sure to add App Groups capability to both targets in Xcode!"
fi

echo ""
echo "4️⃣  File size check (should not be 0):"
SIZE=$(stat -f%z "$PROJECT_PATH/FitsApp/ViewModel/StepCountSync.swift" 2>/dev/null)
echo "   iOS StepCountSync.swift: $SIZE bytes"
SIZE=$(stat -f%z "$PROJECT_PATH/appleWatch Watch App/StepCountSync.swift" 2>/dev/null)
echo "   Watch StepCountSync.swift: $SIZE bytes"

echo ""
echo "📋 Next Steps:"
echo "   1. Open FitsApp.xcodeproj in Xcode"
echo "   2. Right-click StepCountSync.swift in ViewModel folder"
echo "   3. Select 'File Inspector' (right panel)"
echo "   4. Under 'Target Membership', check 'FitsApp'"
echo "   5. Repeat for watch app's StepCountSync.swift"
echo "   6. Press Cmd+Shift+K to clean, then Cmd+B to rebuild"
