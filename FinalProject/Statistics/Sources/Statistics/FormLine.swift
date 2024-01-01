//
//  FormLine.swift
//
//

import SwiftUI

struct FormLine: View {
    var title: String
    var value: Int

    var body: some View {
        Section(
            header: Text("\(title)")
                .font(.title3)
                .bold()
                // .foregroundColor(.black)
        ) {
            Text( "\(value)" )
            // Problem 7B code goes here.
                .font(.title.monospacedDigit())
                .foregroundColor(Color("accent"))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    Form {
        FormLine(
            title: "A",
            value: 20000
        )
    }
}
