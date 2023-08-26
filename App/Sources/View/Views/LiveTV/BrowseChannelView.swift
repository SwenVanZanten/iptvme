import SwiftUI
import XtreamCodesKit

struct BrowseChannelView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        NavigationSplitView {
            BrowseCategories()
                .navigationDestination(for: CategoryItem.self) { category in
                    BrowseChannels(category: category) { liveStream in
                        openPlayable(liveStream: liveStream)
                    }
                }
        } detail: {
            Text("Select Category")
        }
    }
    
    func openPlayable(liveStream: LiveStream) {
        openWindow(value: Playable(
            name: liveStream.name,
            url: liveStream.getUrl(
                api: contentVM.api,
                containerExtension: ".m3u8"
            )
        ))
    }
}

struct BrowseCategories: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @State var categories: [CategoryItem] = []
    
    var body: some View {
        ChooseCategoryView(categories: $categories)
            .task {
                do {
                    categories = try await contentVM.api.liveTvCategories()
                } catch {
                    print(error)
                }
            }
    }
}

struct BrowseChannels: View {
    var category: CategoryItem
    
    @EnvironmentObject var contentVM: ContentViewModel
    @State var channels: [LiveStream] = []
    var selected: (_ liveStream: LiveStream) -> Void
    
    var body: some View {
        ChooseChannelView(channels: $channels, selected: selected)
            .task {
                do {
                    channels = try await contentVM.api.liveTvCategory(category: category.id)
                } catch {
                    print(error)
                }
            }
    }
}

struct BrowseChannelView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseChannelView()
    }
}
