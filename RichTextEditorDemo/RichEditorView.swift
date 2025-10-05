import SwiftUI

struct ContentView: View {
    @Environment(\.fontResolutionContext) var fontResolutionContext
    
    @State private var attributedText = AttributedString("Welcome to Rich Text Editor!\n\nSelect any text and use the toolbar above to format it. Try making text bold, italic, changing colors, or adding underlines.\n\nYou can also combine multiple formatting options for creative effects!")
    @State private var selection = AttributedTextSelection()
    
    @State private var selectedForegroundColor = Color.primary
    @State private var selectedBackgroundColor = Color.clear
    @State private var showingColorPicker = false
    @State private var showingBackgroundPicker = false
    @State private var fontSize: CGFloat = 16
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Primary Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // Text Style Controls
                        Group {
                            ToolbarButton(
                                icon: "bold",
                                isActive: isBold,
                                action: toggleBold
                            )
                            
                            ToolbarButton(
                                icon: "italic",
                                isActive: isItalic,
                                action: toggleItalic
                            )
                            
                            ToolbarButton(
                                icon: "underline",
                                isActive: hasUnderline,
                                action: toggleUnderline
                            )
                            
                            ToolbarButton(
                                icon: "strikethrough",
                                isActive: hasStrikethrough,
                                action: toggleStrikethrough
                            )
                        }
                        
                        Divider()
                            .frame(height: 30)
                        
                        // Color Controls
                        Group {
                            Button(action: { showingColorPicker.toggle() }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "textformat")
                                    Circle()
                                        .fill(selectedForegroundColor)
                                        .frame(width: 16, height: 16)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(showingColorPicker ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                            }
                            
                            Button(action: { showingBackgroundPicker.toggle() }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "highlighter")
                                    Circle()
                                        .fill(selectedBackgroundColor == .clear ? Color.white : selectedBackgroundColor)
                                        .frame(width: 16, height: 16)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(showingBackgroundPicker ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                            }
                        }
                        
                        Divider()
                            .frame(height: 30)
                        
                        // Font Size Controls
                        Group {
                            Button(action: decreaseFontSize) {
                                Image(systemName: "textformat.size.smaller")
                                    .frame(width: 36, height: 36)
                            }
                            
                            Text("\(Int(fontSize))pt")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 40)
                            
                            Button(action: increaseFontSize) {
                                Image(systemName: "textformat.size.larger")
                                    .frame(width: 36, height: 36)
                            }
                        }
                        
                        Divider()
                            .frame(height: 30)
                        
                        // Clear Formatting
                        Button(action: clearFormatting) {
                            Label("Clear", systemImage: "trash")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemGray6))
                
                // Color Pickers
                if showingColorPicker {
                    ColorPicker("Text Color", selection: $selectedForegroundColor)
                        .padding()
                        .background(Color(.systemGray5))
                        .onChange(of: selectedForegroundColor) { _, newColor in
                            applyForegroundColor(newColor)
                        }
                }
                
                if showingBackgroundPicker {
                    HStack {
                        ColorPicker("Background Color", selection: $selectedBackgroundColor)
                        
                        Button("Clear") {
                            selectedBackgroundColor = .clear
                            applyBackgroundColor(.clear)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .onChange(of: selectedBackgroundColor) { _, newColor in
                        applyBackgroundColor(newColor)
                    }
                }
                
                Divider()
                
                // Text Editor
                TextEditor(text: $attributedText, selection: $selection)
                    .padding()
                    .onChange(of: selection) { _, _ in
                        updateToolbarState()
                    }
                
                // Status Bar
                HStack {
                    Text("Ready to format")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(attributedText.characters.count) characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
            }
            .navigationTitle("Rich Text Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { attributedText = AttributedString("") }) {
                            Label("Clear All", systemImage: "trash")
                        }
                        
                        Button(action: selectAll) {
                            Label("Select All", systemImage: "selection.pin.in.out")
                        }
                        
                        Divider()
                        
                        Button(action: insertSampleText) {
                            Label("Insert Sample Text", systemImage: "doc.text")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var isBold: Bool {
        let attributes = selection.typingAttributes(in: attributedText)
        if let font = attributes.font {
            let resolved = font.resolve(in: fontResolutionContext)
            return resolved.isBold
        }
        return false
    }
    
    private var isItalic: Bool {
        let attributes = selection.typingAttributes(in: attributedText)
        if let font = attributes.font {
            let resolved = font.resolve(in: fontResolutionContext)
            return resolved.isItalic
        }
        return false
    }
    
    private var hasUnderline: Bool {
        let attributes = selection.typingAttributes(in: attributedText)
        return attributes.underlineStyle != nil
    }
    
    private var hasStrikethrough: Bool {
        let attributes = selection.typingAttributes(in: attributedText)
        return attributes.strikethroughStyle != nil
    }
    
    // MARK: - Formatting Actions
    
    func toggleBold() {
        attributedText.transformAttributes(in: &selection) { container in
            let currentFont = container.font ?? .body
            let resolved = currentFont.resolve(in: fontResolutionContext)
            container.font = currentFont.bold(!resolved.isBold)
        }
    }
    
    func toggleItalic() {
        attributedText.transformAttributes(in: &selection) { container in
            let currentFont = container.font ?? .body
            let resolved = currentFont.resolve(in: fontResolutionContext)
            container.font = currentFont.italic(!resolved.isItalic)
        }
    }
    
    func toggleUnderline() {
        attributedText.transformAttributes(in: &selection) { container in
            if container.underlineStyle != nil {
                container.underlineStyle = nil
            } else {
                container.underlineStyle = .single
            }
        }
    }
    
    func toggleStrikethrough() {
        attributedText.transformAttributes(in: &selection) { container in
            if container.strikethroughStyle != nil {
                container.strikethroughStyle = nil
            } else {
                container.strikethroughStyle = .single
            }
        }
    }
    
    func applyForegroundColor(_ color: Color) {
        attributedText.transformAttributes(in: &selection) { container in
            container.foregroundColor = color
        }
    }
    
    func applyBackgroundColor(_ color: Color) {
        attributedText.transformAttributes(in: &selection) { container in
            if color == .clear {
                container.backgroundColor = nil
            } else {
                container.backgroundColor = color
            }
        }
    }
    
    func increaseFontSize() {
        fontSize = min(fontSize + 2, 72)
        attributedText.transformAttributes(in: &selection) { container in
            container.font = .system(size: fontSize)
        }
    }
    
    func decreaseFontSize() {
        fontSize = max(fontSize - 2, 8)
        attributedText.transformAttributes(in: &selection) { container in
            container.font = .system(size: fontSize)
        }
    }
    
    func clearFormatting() {
        attributedText.transformAttributes(in: &selection) { container in
            container.font = .body
            container.foregroundColor = .primary
            container.backgroundColor = nil
            container.underlineStyle = nil
            container.strikethroughStyle = nil
        }
        fontSize = 16
    }
    
    func updateToolbarState() {
        let attributes = selection.typingAttributes(in: attributedText)
        
        // Update color picker states based on selection
        if let color = attributes.foregroundColor {
            selectedForegroundColor = color
        }
        
        if let bgColor = attributes.backgroundColor {
            selectedBackgroundColor = bgColor
        }
    }
    
    func selectAll() {
        selection = AttributedTextSelection(
            range: attributedText.startIndex..<attributedText.endIndex
        )
    }
    
    func insertSampleText() {
        var sample = AttributedString("\n\nThis is sample text with ")
        
        var bold = AttributedString("bold")
        bold.font = .body.bold()
        sample.append(bold)
        
        sample.append(AttributedString(", "))
        
        var italic = AttributedString("italic")
        italic.font = .body.italic()
        sample.append(italic)
        
        sample.append(AttributedString(", "))
        
        var colored = AttributedString("colored")
        colored.foregroundColor = .blue
        sample.append(colored)
        
        sample.append(AttributedString(", and "))
        
        var highlighted = AttributedString("highlighted")
        highlighted.backgroundColor = .yellow
        sample.append(highlighted)
        
        sample.append(AttributedString(" text!\n"))
        
        attributedText.append(sample)
    }
}

// MARK: - Toolbar Button Component

struct ToolbarButton: View {
    let icon: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 36, height: 36)
                .background(isActive ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
        }
    }
}
