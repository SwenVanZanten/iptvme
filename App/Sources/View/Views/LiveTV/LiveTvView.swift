import SwiftUI
import CachedAsyncImage
import AVKit
import XtreamCodesKit

let exampleMedias: [LiveStream] = [
    .init(
        id: 976,
        number: 1,
        name: "NPO 1",
        icon: URL(string: "http://logo.protv.cc/picons/logos/npo1hd.png")!,
        epgChannelId: "NPO1.nl",
        added: "1570789167",
        categoryId: "3",
        customSid: "0",
        tvArchive: true,
        directSource: "",
        tvArchiveDuration: "3"
    ),
    .init(
        id: 956,
        number: 30,
        name: "Ziggo Sport SELECT",
        icon: URL(string: "http://logo.protv.cc/picons/logos/ziggosportselecthd.png")!,
        epgChannelId: "ZiggoSportSelect.nl",
        added: "1443760634",
        categoryId: "3",
        customSid: "0",
        tvArchive: true,
        directSource: "",
        tvArchiveDuration: "3"
    ),
    .init(
        id: 1026,
        number: 39,
        name: "ESPN 1",
        icon: URL(string: "http://logo.protv.cc/picons/logos/espnhd.png")!,
        epgChannelId: "ESPN.nl",
        added: "1443781440",
        categoryId: "3",
        customSid: "0",
        tvArchive: true,
        directSource: "",
        tvArchiveDuration: "3"
    )
]

struct LiveTvView: View {
    @EnvironmentObject var contentData: ContentViewModel
    @Environment(\.openWindow) var openWindow
    @StateObject private var liveTVCategoriesVM: LiveTVCategoriesViewModel
    @State var showAddPinnedModal: Bool = false
    @State var showAddCategorySheet: Bool = false
    @State var search: String = ""
    @State var dragOver: Bool = false
    
    private var subscription: Subscription
    
    init(subscription: Subscription) {
        _liveTVCategoriesVM = StateObject(wrappedValue: LiveTVCategoriesViewModel(subscription: subscription))
        
        self.subscription = subscription
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        NavigationLink(destination: BrowseChannelView()) {
                            Label("Browse", systemImage: "list.triangle")
                        }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "pin.fill")
                        Text("Pinned Channels")
                            .font(.title2.weight(.semibold))
                        
                        Spacer()
                        
                        Button {
                            //
                        } label: {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack(alignment: .top, spacing: 15) {
                        ForEach(exampleMedias, id: \.self) { media in
                            PinnedLiveTvButton(action: {
                                openWindow(value: Playable(
                                    name: media.name,
                                    url: media.getUrl(
                                        api: contentData.api,
                                        containerExtension: ".m3u8"
                                    )
                                ))
                            }, media: media)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "rectangle.3.group.fill")
                        Text("Categories")
                            .font(.title2.weight(.semibold))
                        
                        Spacer()
                        
                        Button {
                            showAddCategorySheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 15)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                        
                        ForEach(liveTVCategoriesVM.categories) { category in
                            NavigationLink(
                                destination: LiveTvCategoryView()
                                    .environmentObject(LiveTVChannelsViewModel(category: category))
                            ) {
                                CategoryButton(category: category)
                                    .onDrag {
                                        liveTVCategoriesVM.currentGrid = category
                                        return NSItemProvider(object: String(category.name) as NSString)
                                    }
                                    .onDrop(of: [.text], delegate: DropViewDelegate(category: category, gridData: liveTVCategoriesVM))
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("Open") {
                                    print("open")
                                }
                                Divider()
                                Button("Delete") {
                                    Task {
                                        do {
                                            try await liveTVCategoriesVM.deleteCategory(category)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $showAddCategorySheet) {
                AddCategorySheet()
            }
            .toolbar {
                ToolbarItem {
                    TextField("Search your channel", text: $search)
                        .textFieldStyle(.roundedBorder)
                        .frame(minWidth: 200)
                }
            }
            .task {
                liveTVCategoriesVM.fetchGategories()
            }
            .environmentObject(liveTVCategoriesVM)
        }
    }
}

struct PinnedLiveTvButton: View {
    @EnvironmentObject var contentData: ContentViewModel
    
    var action: () -> Void
    var media: LiveStream
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    Color.red
                    
                    CachedAsyncImage(url: media.icon) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "tv")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 50, height: 40)
                    .padding()
                    .shadow(radius: 10)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(media.name)
                            .font(.headline.weight(.semibold))
                            .lineLimit(1)
                            .truncationMode(.middle)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red.opacity(0.15))
            }
        }
        .buttonStyle(.plain)
        .shadow(radius: 5)
    }
}

struct CategoryButton: View {
    let category: LiveTVCategory
    
    var body: some View {
        ZStack {
            Image(category.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            HStack {
                Image(systemName: category.systemImage)
                Text(category.name)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .padding()
        }
        .frame(maxHeight: 120)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(category.color)
        }
        .overlay(Rectangle().fill(category.color).frame(width: 5), alignment: .leading)
        .cornerRadius(10)
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .foregroundColor(.white)
    }
}

struct DropViewDelegate: DropDelegate {
    var category: LiveTVCategory
    var gridData: LiveTVCategoriesViewModel
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        let fromIndex = gridData.categories.firstIndex { (category) -> Bool in
            return category.id == gridData.currentGrid?.id
        } ?? 0
        
        let toIndex = gridData.categories.firstIndex { (category) -> Bool in
            return category.id == self.category.id
        } ?? 0
        
        if fromIndex != toIndex{
            withAnimation(.default){
                let fromGrid = gridData.categories[fromIndex]
                gridData.categories[fromIndex] = gridData.categories[toIndex]
                gridData.categories[toIndex] = fromGrid
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

//struct LiveView_Previews: PreviewProvider {
//    static var previews: some View {
//        LiveTvView()
//            .frame(minWidth: 600, minHeight: 400)
//    }
//}
