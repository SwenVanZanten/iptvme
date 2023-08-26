import SwiftUI
import XtreamCodesKit

@main
struct IPTVMeApp: App {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) var dismiss
    @StateObject var subscriptionVM: SubscriptionViewModel = SubscriptionViewModel()
    @StateObject var contentVM: ContentViewModel = ContentViewModel()
    
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
                
                subscriptionVM.selectedSubscription = subscription
                
                openWindow(value: subscription)
            }
            .frame(width: 800, height: 450)
            .environmentObject(subscriptionVM)
            .tint(.red)
        }
        .windowResizability(.contentMinSize)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 450)
        
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
                .tint(.red)
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
                    .tint(.red)
            }
        }
#else
        WindowGroup {
            if let subscription = subscriptionVM.selectedSubscription {
                ContentView(subscription: subscription) {
                    subscriptionVM.selectedSubscription = nil
                }
                    .task {
                        contentVM.api = Api(
                            host: subscription.host,
                            username: subscription.username,
                            password: subscription.password
                        )
                    }
                    .environmentObject(contentVM)
                    .tint(.red)
            } else {
                SubscriptionView { subscription in
                    contentVM.api = Api(
                        host: subscription.host,
                        username: subscription.username,
                        password: subscription.password
                    )
                    
                    self.subscriptionVM.selectedSubscription = subscription
                }
                .environmentObject(subscriptionVM)
                .tint(.red)
            }
        }
#endif
    }
}
