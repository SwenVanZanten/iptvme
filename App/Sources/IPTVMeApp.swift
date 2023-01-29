import SwiftUI
import XtreamCodesKit

@main
struct IPTVMeApp: App {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) var dismiss
    @StateObject var contentVM: ContentViewModel = ContentViewModel()
    
    @State var showContentView: Bool = false
    @State var subscription: Subscription? = nil
    
    var body: some Scene {
        #if os(macOS)
        WindowGroup("", id: "select-subscription") {
            SubscriptionView { subscription in
                NSApplication.shared.keyWindow?.close()
                
                contentVM.api = Api(
                    host: subscription.host,
                    username: subscription.username,
                    password: subscription.password
                )
                
                openWindow(value: subscription)
            }
        }
        .defaultSize(width: 300, height: 500)
        
        WindowGroup(for: Subscription.self) { $subscription in
            if let subscription = subscription {
                ContentView(subscription: subscription, switchSubscription: {
                    NSApplication.shared.keyWindow?.close()
                    
                    openWindow(id: "select-subscription")
                })
                .task {
                    contentVM.api = Api(
                        host: subscription.host,
                        username: subscription.username,
                        password: subscription.password
                    )
                }
                .frame(minWidth: 900, minHeight: 600)
                .environmentObject(contentVM)
            }
        }
        .defaultSize(width: 900, height: 600)
        
        WindowGroup(for: Playable.self) { $playable in
            if let playable = playable {
                LiveTvPlayerView(playable: playable)
                    .environmentObject(contentVM)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1)) {
                            
                            if let window = NSApplication.shared.windows.last {
                                window.toggleFullScreen(nil)
                            }
                        }
                    }
            }
        }
        #else
        WindowGroup {
            NavigationStack {
                SubscriptionView { subscription in
                    contentVM.api = Api(
                        host: subscription.host,
                        username: subscription.username,
                        password: subscription.password
                    )
                    
                    self.subscription = subscription
                    showContentView = true
                }
                .navigationDestination(isPresented: $showContentView) {
                    if let subscription = self.subscription {
                        ContentView(subscription: subscription)
                        .task {
                            contentVM.api = Api(
                                host: subscription.host,
                                username: subscription.username,
                                password: subscription.password
                            )
                        }
                        .environmentObject(contentVM)
                    }
                }
            }
        }
        #endif
    }
}
