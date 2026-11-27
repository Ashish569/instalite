# Instalite

A lightweight iOS app that lets you use Instagram without the Reels tab — keeping your feed, DMs, Stories, and Search fully intact.

Inspired by [SocialLite](https://sociallite.app/).

---

## What it does

- Opens Instagram as a mobile web app inside a clean WKWebView
- **Hides the Reels tab** from Instagram's bottom navigation
- **Redirects** any `/reels/` URL back to the home feed
- Videos play **inline** (no unwanted fullscreen takeover)
- Login **persists** across app restarts via cookies
- Camera & microphone access for **Stories** works natively

## What it keeps

- Home feed
- Stories
- Search / Explore
- Direct Messages
- Profile
- Create / Upload

---

## Requirements

- macOS with Xcode 15+
- iOS 16+ device
- Free Apple ID (no paid developer account needed to run on your own device)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)

---

## Getting Started

```bash
# Clone the repo
git clone https://github.com/Ashish569/instalite.git
cd instalite

# Generate the Xcode project
xcodegen generate

# Open in Xcode
open instalite.xcodeproj
```

Then select your iPhone from the device dropdown and hit **Cmd+R**.

**First run on device:** Go to Settings → General → VPN & Device Management → trust your Apple ID.

---

## Project Structure

```
Sources/
├── SocialLiteApp.swift      # App entry point
├── ContentView.swift        # Root view
├── WebView.swift            # WKWebView + JS injection
└── Assets.xcassets/
    └── AppIcon.appiconset/  # App icon
project.yml                  # XcodeGen config
```

---

## License

MIT
