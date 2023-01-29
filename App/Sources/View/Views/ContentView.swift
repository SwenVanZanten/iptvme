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
                    NavigationLink(destination:
                                    LiveTvView()) {
                        Label("Live TV", systemImage: "tv")
                    }
                                    .controlSize(.large)
                    
                    NavigationLink(destination: Text("Movies")) {
                        Label("Movies", systemImage: "popcorn.fill")
                    }
                    .controlSize(.large)
                    
                    NavigationLink(destination: Text("Series")) {
                        Label("Series", systemImage: "film.stack.fill")
                    }
                    .controlSize(.large)
                }
#if os(macOS)
                    Spacer()
                    
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
#endif
            }
//            VStack(spacing: 0) {
//                VStack {
//                    TabButton(
//                        title: "Live TV",
//                        image: "tv",
//                        selectedTab: $contentVM.selectedTab
//                    )
//
//                    TabButton(
//                        title: "Movies",
//                        image: "popcorn.fill",
//                        selectedTab: $contentVM.selectedTab
//                    )
//
//                    TabButton(
//                        title: "Series",
//                        image: "film.stack.fill",
//                        selectedTab: $contentVM.selectedTab
//                    )
//                }
//                .padding()
//
//                Spacer()
//
//                Divider()
//
//                HStack {
//                    Button {
//                        // close window
//                        // open subscription window
//                        switchSubscription?()
//                    } label: {
//                        Image(systemName: "arrow.left.arrow.right.circle")
//                            .foregroundColor(.red)
//                    }
//
//                    VStack(alignment: .leading) {
//                        Text("Subscription:")
//                            .font(.caption)
//                        Text(subscription.name)
//                            .bold()
//                    }
//                }
//                .padding(10)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(.primary.opacity(0.05))
//            }
        } detail: {
            LiveTvView()
//            NavigationStack {
//                ZStack(alignment: .bottom) {
//                    switch contentVM.selectedTab {
//                    case "Live TV":
//                        LiveTvView()
//                    case "Movies":
//                        Text("Movies")
//                    case "Series":
//                        Text("Series")
//                    default: Text("")
//                    }
//                }
//            }
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
