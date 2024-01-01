//
//  SwiftUIView.swift
//  
//
//  Created by Linda Zhao on 12/7/23.
//

import SwiftUI

public struct BubbleButton: View {
    public var text: String
    public var action: () -> Void

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
            Button(action: action) {
                Text(text).font(.system(size: 24.0).bold())
                    .frame(width: 90, height: 50)
                    .shadow(color: .white, radius: 1)
            }
            .background(Capsule().fill(LinearGradient(colors: [Color("gridLine"),  Color("born"), Color("alive")], startPoint: .bottomLeading, endPoint: .topTrailing)).opacity(0.8).blur(radius: 2))
            .padding([.top, .bottom], 8.0)
            .shadow(radius: 2)
            Spacer()
        }
    }
}

// MARK: Previews
#Preview {
    BubbleButton(text: "Bubble") { }
}
