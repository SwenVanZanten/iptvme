import SwiftUI
import XtreamCodesKit

struct ContentView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    
    let subscription: Subscription
    var switchSubscription: (() -> Void)? = nil
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                List {
                    NavigationLink(destination: LiveTvView(subscription: subscription)) {
                        Label("Live TV", systemImage: "tv")
                    }
                    
                    NavigationLink(destination: Text("Movies")) {
                        Label("Movies", systemImage: "popcorn.fill")
                    }
                    
                    NavigationLink(destination: Text("Series")) {
                        Label("Series", systemImage: "film.stack.fill")
                    }
                }

                #if os(macOS)
                Spacer()
                #endif
                
                Divider()
                
                HStack {
                    Button {
                        // close window
                        // open subscription window
                        switchSubscription?()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right.circle")
                            .foregroundColor(.red)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Subscription:")
                            .font(.caption)
                        Text(subscription.name)
                            .bold()
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.primary.opacity(0.05))
            }
        } detail: {
            LiveTvView(subscription: subscription)
        }
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(subscription: .init(
            name: "",
            username: "",
            password: "",
            host: ""
        ))
        .environmentObject(ContentViewModel())
    }
}
