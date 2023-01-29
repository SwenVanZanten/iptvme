import SwiftUI

struct GroupView<Content>: View where Content: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct GroupRow<Content>: View where Content: View {
    var border: Bool = true

    @ViewBuilder var content: Content
    
    var body: some View {
        HStack {
            content
                .textFieldStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            if border {
                Rectangle()
                    .frame(
                        width: nil,
                        height: 1,
                        alignment: .top
                    )
                    .foregroundColor(
                        Color.primary.opacity(0.1)
                    )
            }
        }
    }
}

//struct GroupBackground: View {
//    var body: some View {
//       RoundedRectangle(cornerRadius: 10)
//           .fill(Color.secondary.opacity(0.1))
//           .overlay(
//               RoundedRectangle(cornerRadius: 10)
//                   .stroke(Color.primary.opacity(0.1), lineWidth: 1)
//           )
//           .clipShape(RoundedRectangle(cornerRadius: 10))
//    }
//}
//
//struct GroupRow: ViewModifier {
//    var border: Bool = true
//
//    func body(content: Content) -> some View {
//        HStack {
//            content
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding()
//        .contentShape(Rectangle())
//        .overlay(alignment: .bottom) {
//            if border {
//                Rectangle()
//                    .frame(
//                        width: nil,
//                        height: 1,
//                        alignment: .top
//                    )
//                    .foregroundColor(
//                        Color.primary.opacity(0.1)
//                    )
//            }
//        }
//    }
//}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView {
            GroupRow {
                TextField("Test", text: .constant(""), prompt: Text("Test"))
            }
            GroupRow(border: false) {
                HStack {
                    Text("With Chevron")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                }
            }
        }
        .padding()
    }
}
