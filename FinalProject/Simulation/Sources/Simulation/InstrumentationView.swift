//
//  InstrumentationView.swift
//  SwiftUIGameOfLife
//

import SwiftUI
import ComposableArchitecture
import Theming

fileprivate let formatter: NumberFormatter = {
    let nf = NumberFormatter()
    nf.numberStyle = .decimal
    nf.maximumFractionDigits = 3
    return nf
}()

struct InstrumentationView: View {
    let store: StoreOf<SimulationModel>
    private var width: CGFloat

    init(
        store: StoreOf<SimulationModel>,
        width: CGFloat = 300.0
    ) {
        self.store = store
        self.width = width
    }

    var body: some View {
        VStack {
            Spacer()
            control1(width)
                .frame(width: width, alignment: .leading)
                .offset(x: 0.0)
                .fixedSize(horizontal: true, vertical: false)
            control2(width)
                .frame(width: width, alignment: .leading)
                .offset(x: 0.0)
                .fixedSize(horizontal: true, vertical: false)
            control3(width)
                .frame(width: width, alignment: .leading)
                .offset(x: 0.0)
                .fixedSize(horizontal: true, vertical: false)
            control4(width)
                .frame(width: width, alignment: .leading)
                .offset(x: 0.0)
                .fixedSize(horizontal: true, vertical: false)
            buttons
                .frame(width: width, alignment: .top)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.top, 16.0)
            
            // some animation text
            // poor squidword would run away in no time
            WithViewStore(store, observe: { $0 }) { viewStore in
                Text("Watch Out For Plankton(s) !!!")
                    .font(.subheadline.lowercaseSmallCaps().italic().bold())
                    .shadow(radius: 4)
                    .opacity(viewStore.gridState.step ? 0.2 : 1)
                    .offset(x: viewStore.gridState.step  ? width : -width)
                    .animation(.easeInOut(duration: 5.0), value: viewStore.gridState.step)
            }
        }
    }

    func control1(_ width: CGFloat) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Text("Size: \(Int(viewStore.gridState.grid.size.rows))")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(Color("accent"))
                    .frame(width: width * 0.65, alignment: .bottomLeading)
                    .padding(0.0)
                Spacer()
                Text("Depth")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(Color("accent"))
                    .frame(width: width * 0.25, alignment: .bottomTrailing)
                    .padding(0.0)
            }
        }
    }

    func control2(_ width: CGFloat) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Slider(
                    value: viewStore.binding(
                        get: { Double($0.gridState.grid.size.rows) },
                        send: { .setGridSize(Int($0)) }
                    ),
                    in: 5 ... 40,
                    step: 1,
                    onEditingChanged: { (changed) in },
                    minimumValueLabel: Text("5").font(.system(.subheadline, design: .rounded)).foregroundColor(Color("accent")),
                    maximumValueLabel: Text("40").font(.system(.subheadline, design: .rounded)).foregroundColor(Color("accent")),
                    label: { Spacer() }
                )
                .frame(width: width * 0.65, alignment: .bottomLeading)
                .accentColor(Color("accent"))


                Spacer()

                Text(self.cycleLength(for: viewStore))
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color("accent"))
                    .frame(width: width * 0.25, alignment: .trailing)
                    .fixedSize(horizontal: true, vertical: false)
                    .background(
                        Color("textBackground")
                            .frame(width: width * 0.25, height: 31.0, alignment: .leading)
                            .fixedSize(horizontal: true, vertical: true)
                    )
            }
        }
    }

    func control3(_ width: CGFloat) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Text("Refresh Period: \(self.numberString(for: viewStore.timerInterval))")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(Color("accent"))
                    .frame(width: width * 0.55, alignment: .bottomLeading)
                    .offset(x: 0.0)
                    .padding(0.0)

                Spacer()

                Text("Simulation")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .frame(width: width * 0.45, alignment: .bottomTrailing)
                    .padding(0.0)
                    .foregroundColor(viewStore.isRunningTimer ?  Color("accent") : Color("accent").opacity(0.6))
            }
        }
    }

    func control4(_ width: CGFloat) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Slider(
                    value: viewStore.binding(
                        get: \.timerInterval,
                        send: { .setTimerInterval($0) }
                    ),
                    in: 0.0 ... 1.0,
                    step: 0.1,
                    onEditingChanged: { (changed) in },
                    minimumValueLabel: Text("0.0")
                        .font(.system(.subheadline, design: .rounded)).foregroundColor(Color("accent")),
                    maximumValueLabel: Text("1.0")
                        .font(.system(.subheadline, design: .rounded)).foregroundColor(Color("accent")),
                    label: { Spacer() }
                )
                .frame(width: width * 0.65, alignment: .bottomLeading)
                .accentColor(Color("accent"))

                Spacer()

                Toggle(isOn:
                    viewStore.binding(
                        get: \.isRunningTimer,
                        send: { .toggleTimer($0) }
                    )
                ) {}
                    .tint(Color("accent"))
                .frame(width: width * 0.25, alignment: .bottomTrailing)
            }
        }
    }

    var buttons: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Spacer()
                ThemedButton(text: "Step") {
                    viewStore.send(.stepGrid,
                    animation: .easeInOut(duration: 1.0))
                }
                Spacer()
                ThemedButton(text: "Empty") { viewStore.send(.resetGridToEmpty) }
                Spacer()
                ThemedButton(text: "Random") { viewStore.send(.resetGridToRandom) }
                Spacer()
            }
        }
    }

    func cycleLength(for viewStore: ViewStoreOf<SimulationModel>) -> String {
        guard let cycleLength = viewStore.gridState.history.cycleLength else { return "" }
        return "\(cycleLength)"
    }

    func numberString(for value: Double) -> String {
        "\(formatter.string(from: NSNumber(value: value) ) ?? "")"
    }
}

#Preview {
    let previewState = SimulationModel.State()
    return InstrumentationView(
        store: Store(
            initialState: previewState,
            reducer: SimulationModel.init
        )
    )
}
