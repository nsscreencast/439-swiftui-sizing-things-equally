//
//  ContentView.swift
//  SwiftUI-SizingEqually
//
//  Created by Ben Scheirman on 5/14/20.
//  Copyright © 2020 Fickle Bits, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var buttonWidth: CGFloat?

    var body: some View {
        Rectangle()
            .fill(Color(.secondarySystemFill))
            .frame(height: 80)
        .overlay(
            HStack {
                ToolbarButton(label: "Btn1", labelWidth: self.buttonWidth)
                Spacer()
                ToolbarButton(label: "center", labelWidth: self.buttonWidth)
                Spacer()
                ToolbarButton(label: "Button 3", labelWidth: self.buttonWidth)
            }
            .onPreferenceChange(ToolbarButtonSizePreference.self) {
                self.buttonWidth = $0?.width
            }
            .padding()
        )
    }
}

struct ToolbarButtonSizePreference: PreferenceKey {
    static var defaultValue: CGSize? = nil

    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        guard let next = nextValue() else {
            return
        }
        if value == nil {
            value = next
            return
        }

        let maxSize = [value!, next].max { $0.width < $1.width }
        value = maxSize
    }
}

struct ToolbarButton: View {
    let label: String
    let labelWidth: CGFloat?
    var body: some View {
        Text(label)
        .padding(10)
        .frame(width: self.labelWidth)
        .background(
            Capsule()
                .fill(Color(.systemBlue))
                .shadow(radius: 1)
        )
        .foregroundColor(.white)
        .font(.headline)
        .modifier(ToolbarButtonSizeSetter())
    }
}

struct ToolbarButtonSizeSetter: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(GeometryReader { geometry in
            Color.clear.preference(key: ToolbarButtonSizePreference.self, value: geometry.size)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
