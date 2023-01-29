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
    @StateObject var liveTvCategoriesVM = LiveTVCategoriesViewModel()
    @State var showAddPinnedModal: Bool = false
    @State var showAddCategorySheet: Bool = false
    @State var search: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                if exampleMedias.count > 0 {
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
                    
                    ForEach(liveTvCategoriesVM.categories) { category in
                        NavigationLink(
                            destination: LiveTvCategoryView()
                            .environmentObject(LiveTVChannelsViewModel(category: category))
                        ) {
                            CategoryButton(category: category)
                        }.buttonStyle(.borderless)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showAddCategorySheet) {
            AddCategorySheet()
                .environmentObject(liveTvCategoriesVM)
        }
        .toolbar {
            ToolbarItem {
                TextField("Search your channel", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 200)
            }
        }
        .task {
            liveTvCategoriesVM.fetchGategories()
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
//                    StreamThumbnail(url: media.getUrl(api: contentData.api, containerExtension: ".m3u8"))
                    
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
        .cornerRadius(10)
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .foregroundColor(.white)
    }
}

struct LiveView_Previews: PreviewProvider {
    static var previews: some View {
        LiveTvView()
            .frame(minWidth: 600, minHeight: 400)
    }
}
