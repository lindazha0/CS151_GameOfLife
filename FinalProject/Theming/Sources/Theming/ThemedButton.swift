//
//  ThemedButton.swift
//  SwiftUIGameOfLife
//

import SwiftUI

public struct ThemedButton: View {
    public var text: String
    public var action: () -> Void
    @State private var clickTrigger = 1.0

    public init(
        text: String,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.action = action
    }

    public var body: some View {
        HStack {
            Spacer()
            Button(action: {
                clickTrigger = 3
                self.action()
                clickTrigger = 1
            }) {
                Text(text)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 82.0, height: 82.0)
                    .scaleEffect(clickTrigger)
                    .animation(.linear(duration: 1).repeatCount(2), value: clickTrigger)
            }
            .background(Circle().fill(Color("accent")).opacity(0.9))
            // Your Problem 2 code goes here.
            .overlay(Circle().stroke(Color.white, lineWidth: 1.0))
            .shadow(radius: 4.0)
            Spacer()
        }
    }
}

// MARK: Previews
#Preview {
    ThemedButton(text: "Step") { }
}
