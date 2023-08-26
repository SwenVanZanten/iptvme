import SwiftUI
import XtreamCodesKit

struct ChooseChannelView: View {
    @Binding var channels: [LiveStream]
    var selected: ((_ channel: LiveStream) -> Void)? = nil
    
    @State var channel: String = ""

    var body: some View {
        VStack(spacing: -1) {
            HStack {
                TextField("Channel name", text: $channel)
                    .textFieldStyle(.roundedBorder)
                    .padding(3)
            }
            .border(Color("sheetSeparator"))
            List(channels.filter({ channel in
                if (self.channel == "") {
                    return true
                }
                
                return channel.name.lowercased().contains(self.channel.lowercased())
            })) { channel in
                Button {
                    if let selected = selected {
                        selected(channel)
                    }
                } label: {
                    NavigationLink(channel.name, value: channel)
                }
                .buttonStyle(.plain)
            }
            #if os(macOS)
            .listStyle(.bordered(alternatesRowBackgrounds: true))
            #else
            .listStyle(.inset)
            #endif
            .border(Color("sheetSeparator"))
        }
    }
}

//struct ChooseChannelView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseChannelView(category: .init(id: "", name: "nice", parent: 0), channels: [])
//    }
//}
