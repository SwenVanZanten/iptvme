import SwiftUI
import XtreamCodesKit
import CachedAsyncImage
import CloudKit

struct LiveTvCategoryView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @EnvironmentObject var channelsVM: LiveTVChannelsViewModel
    @Environment(\.openWindow) var openWindow
    @State var showAddChannelSheet = false
    @State var showEpgChannelSheet = false
    @State var showArchiveChannelSheet = false
    @State var search: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                    ForEach(channelsVM.channels.filter({ channel in
                        return self.search == "" ? true : channel.name.lowercased().contains(self.search.lowercased())
                    })) { channel in
                        Button {
                            openPlayable(channel: channel)
                        } label: {
                            ChannelButton(channel: channel) {
                                openPlayable(channel: channel)
                            } epg: {
                                channelsVM.selectedChannel = channel
                                showEpgChannelSheet = true
                            } archive: {
                                channelsVM.selectedChannel = channel
                                showArchiveChannelSheet = true
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(channelsVM.category.name)
        .toolbar {
            ToolbarItem {
                TextField("Search your channel", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .frame(minWidth: 200)
            }
            
            ToolbarItem {
                Button {
                    showAddChannelSheet.toggle()
                } label: {
                    Label("Add channel", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddChannelSheet) {
            AddChannelSheet()
                .environmentObject(channelsVM)
                .environmentObject(contentVM)
        }
        .sheet(isPresented: $showEpgChannelSheet) {
            if let channel = channelsVM.selectedChannel {
                NavigationStack {
                    EpgChannelSheet(media: channel.liveStream)
                }
            }
        }
        .sheet(isPresented: $showArchiveChannelSheet) {
            if let channel = channelsVM.selectedChannel {
                NavigationStack {
                    ArchiveChannelSheet(channel: channel)
                }
            }
        }
    }
    
    func openPlayable(channel: Channel) {
        openWindow(value: Playable(
            name: channel.name,
            url: channel.liveStream.getUrl(
                api: contentVM.api,
                containerExtension: ".m3u8"
            )
        ))
    }
}

struct ChannelButton: View {
    var channel: Channel
    var play: () -> Void
    var epg: () -> Void
    var archive: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                CachedAsyncImage(url: channel.liveStream.icon) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "tv")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 50, height: 40)
                
                Text(channel.liveStream.name)
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .padding(10)
            
            Divider()
            
            HStack() {
                Button {
                    play()
                } label: {
                    Image(systemName: "play.circle")
                    Text("Play")
                        .font(.caption)
                }
                
                Button {
                    epg()
                } label: {
                    Image(systemName: "calendar.circle")
                    Text("EPG")
                        .font(.caption)
                }
                
                if channel.liveStream.tvArchive {
                    Button {
                        archive()
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("\(channel.liveStream.tvArchiveDuration ?? "0")d")
                    }
                }
            }
            .padding(10)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, minHeight: 35, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.primary.opacity(0.1))
        }
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ChannelActionButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct ChannelButton_Previews: PreviewProvider {
    static var previews: some View {
        ChannelButton(channel: .init(name: "Ziggo Sport SELECT", categoryId: CKRecord.ID(recordName: ""), liveSteam: .init(
            id: 1,
            number: 1,
            name: "Ziggo Sport SELECT",
            icon: URL(string: "http://logo.protv.cc/picons/logos/ziggosportselecthd.png")!,
            epgChannelId: "ZiggoSportSelect.nl",
            added: "1443760634",
            categoryId: "3",
            customSid: "0",
            tvArchive: true,
            directSource: "",
            tvArchiveDuration: "3"
        )), play: {
            //
        }, epg: {
            //
        }, archive: {
            //
        })
        .frame(width: 250)
    }
}

//struct LiveTvCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        LiveTvCategoryView().environmentObject(LiveTVChannelsViewModel(category: .init(name: "name", image: "image", color: .orange)))
//    }
//}
