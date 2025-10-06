![iOS](https://img.shields.io/badge/iOS-26.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)

# 📝 SwiftUI Rich Text Editor

A modern, native rich text editor built with SwiftUI and iOS 26+ APIs. This demo showcases the power of `AttributedString`, `AttributedTextSelection`, and `TextEditor` to create a fully-featured text formatting experience without UIKit.

## ✨ Features

### 🎨 Text Formatting
- **Bold** - Make your text stand out
- **Italic** - Add emphasis with style
- **Underline** - Highlight important content
- **Strikethrough** - Mark completed items or revisions

### 🌈 Color Controls
- **Text Color** - Full color picker for foreground text
- **Background Color** - Highlight text with custom backgrounds
- **Clear Background** - Remove highlighting with one tap

### 📐 Font Customization
- **Font Size Control** - Adjust from 8pt to 72pt
- **Increment/Decrement** - Precise 2pt adjustments
- **Visual Feedback** - Live size indicator

### 🎯 Smart Features
- **Active State Indicators** - Visual feedback for applied formatting
- **Clear Formatting** - Remove all formatting with one tap
- **Select All** - Quick text selection
- **Sample Text Insertion** - Demo formatted text
- **Character Counter** - Track document length in real-time

### 🎨 Modern UI/UX
- **Horizontal Scrolling Toolbar** - Fits all controls elegantly
- **Color Picker Integration** - Native iOS color selection
- **Status Bar** - Live document statistics
- **Responsive Design** - Works on all iOS devices

### Article
I have also written detaild article on this which explains it well, You can have a look here: https://medium.com/@dkvekariya/how-to-build-rich-text-editor-in-swiftui-f09a39d2dce9

## 📱 Screenshots

<table>
  <tr>
    <th  width="100%" >mac Editor dark</th>
  </tr>
  <tr align="center">
    <td> <img src="/RichTextEditorDemo/Documents/rich_editor_demo.png"  width="70%" /> </td>
  </tr>
</table>

## 🚀 Getting Started

### Prerequisites

- **Xcode 16.0+** or later
- **iOS 26.0+** deployment target
- **macOS Sonoma** or later (for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/swiftui-rich-text-editor.git
   cd swiftui-rich-text-editor
   ```

2. **Open in Xcode**
   ```bash
   open RichTextEditorDemo.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `⌘ + R` to build and run

## 💻 Code Structure

```
RichTextEditorDemo/
├── ContentView.swift          # Main editor view
├── ToolbarButton.swift        # Reusable toolbar button component
├── RichTextEditorApp.swift    # App entry point
└── Assets.xcassets/           # App assets
```

## 🎓 Key Concepts

### Using FontResolutionContext

The app leverages `fontResolutionContext` to accurately detect font traits:

```swift
@Environment(\.fontResolutionContext) var fontResolutionContext

private var isBold: Bool {
    let attributes = selection.typingAttributes(in: attributedText)
    if let font = attributes.font {
        let resolved = font.resolve(in: fontResolutionContext)
        return resolved.isBold
    }
    return false
}
```

### Transform Attributes Pattern

All formatting uses the modern `transformAttributes(in:)` API:

```swift
func toggleBold() {
    attributedText.transformAttributes(in: &selection) { container in
        let currentFont = container.font ?? .body
        let resolved = currentFont.resolve(in: fontResolutionContext)
        container.font = currentFont.bold(!resolved.isBold)
    }
}
```

### Typing Attributes

Check current formatting state without accessing internal ranges:

```swift
let attributes = selection.typingAttributes(in: attributedText)
if let font = attributes.font {
    // Work with font attributes
}
```

## 🏗️ Architecture Highlights

### State Management
- Uses `@State` for local view state
- Leverages SwiftUI's automatic UI updates
- Minimal state for optimal performance

### Environment Integration
- Proper use of `@Environment` for system values
- Respects iOS design patterns

### Reusable Components
- `ToolbarButton` - Custom button with active states
- Modular design for easy extension

## 🎯 iOS 26+ API Features

This demo exclusively uses iOS 26+ APIs:

✅ **AttributedTextSelection** - Modern selection handling  
✅ **FontResolutionContext** - Accurate trait detection  
✅ **transformAttributes(in:)** - Safe attribute modification  
✅ **typingAttributes(in:)** - State inspection  
✅ **AttributedString** - Rich text representation  

## 📚 Learning Resources

### Key Concepts Demonstrated

1. **Working with AttributedTextSelection**
   - No direct range access
   - Using `typingAttributes(in:)` and `transformAttributes(in:)`

2. **Font Trait Resolution**
   - Using `fontResolutionContext` for accurate detection
   - Proper bold/italic toggling

3. **Color Management**
   - ColorPicker integration
   - Foreground and background colors

4. **Attribute Containers**
   - Modifying multiple attributes efficiently
   - Clearing all formatting

## 🔧 Customization

### Adding New Formatting Options

```swift
// Example: Add superscript
func toggleSuperscript() {
    attributedText.transformAttributes(in: &selection) { container in
        let currentOffset = container.baselineOffset ?? 0
        container.baselineOffset = currentOffset == 0 ? 5 : 0
    }
}
```

### Changing Color Scheme

Modify the toolbar background:

```swift
.background(Color(.systemGray6))  // Change to your preferred color
```

## 🐛 Known Limitations

- **iOS 26+ Only** - Requires latest iOS version
- **No Undo/Redo** - Not implemented in this demo
- **Single Font Family** - Uses system font only
- **No Persistence** - Text is not saved between sessions

## 👨‍💻 Author

**Your Name**
- GitHub: [@DKVekariya](https://github.com/DKVekariya)
- Twitter: [@D_K_Vekariya](https://x.com/D_K_Vekariya)
- LinkedIn: [Divyesh Vekariya](https://www.linkedin.com/in/dkvekariya)

## 🙏 Acknowledgments

- Inspired by Apple's WWDC 2024 sessions on SwiftUI
- Built following iOS 26+ design patterns
- Special thanks to the SwiftUI community

## ⭐ Show Your Support

If this project helped you, please give it a ⭐️!

---

**Built with ❤️ using SwiftUI**

*Last Updated: October 2025*
