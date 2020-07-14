# YukonMatchedGeometry

A reimplementation of SwiftUIs `matchedGeometryEffect` for iOS 13.

Example:
```swift
import SwiftUI
import YukonMatchedGeometry

struct ContentView: View {

    @State var left: Bool = true
    @Namespace var namespace: Namespace.ID

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Color.red.opacity(0.5)
                        .frame(width: 100, height: 200)
                        .matchedGeometryEffect(id: "1", in: namespace, isSource: left)
                    Color.orange.opacity(0.5)
                        .frame(width: 30, height: 100)
                        .matchedGeometryEffect(id: left ? "" : "1", in: namespace, isSource: false)
                    Spacer()
                    Color.green.opacity(0.5)
                        .frame(width: 70, height: 40)
                        .matchedGeometryEffect(id: "1", in: namespace, isSource: !left)
                }
            }
            Button(action: {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                    self.left.toggle()
                }
            }, label: {
                Text("Toggle")
            })
        }
    }
}
```