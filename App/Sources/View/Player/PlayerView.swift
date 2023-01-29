import SwiftUI
import XtreamCodesKit
import AVKit

struct PlayerView: View {
    @EnvironmentObject var contentData: ContentViewModel

    var media: any MediaObject
    
    let player: AVPlayer = AVPlayer()
    @State var epgItems: [EpgItem] = []

    var body: some View {
        GeometryReader { proxy in
            VStack {
                VideoAndInfo(proxy: proxy)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .toolbar {
            ToolbarItem(placement: .navigation) {

                Button {
                    contentData.minifiedPlayer = true
                } label: {
                    Image(systemName: "chevron.down")
                }
            }
        }
        .navigationTitle(media.name)
    }
    
    @ViewBuilder
    func VideoAndInfo(proxy: GeometryProxy) -> some View {
        HStack (alignment: .top, spacing: 15) {
            AVVideoPlayer(player: player)
                .frame(maxWidth: .infinity, minHeight: 500)
                .onAppear() {
                    player.preventsDisplaySleepDuringVideoPlayback = true
                    player.play()
                }
                .onDisappear() {
                    player.pause()
                }
        }
    }
    
    @ViewBuilder
    func EPGList(proxy: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            if epgItems.count == 0 {
                Text("No programming found")
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white.opacity(0.2))
                    }
            } else {
                Text("Programming")
                    .font(.title3.bold())
            }

            ForEach(epgItems) { epgItem in
                HStack (spacing: 10) {
                    let isLive = (epgItem.start ... epgItem.end) ~= Date.now
                    let startDate = epgItem.start.timeIntervalSince1970
                    let endDate = epgItem.end.timeIntervalSince1970
                    let currentDate = Date.now.timeIntervalSince1970
                    let percentage = (currentDate - startDate) / (endDate - startDate)
                    
                    Text(epgItem.startTime)
                        .fontWeight(isLive ? .bold : .regular)
                        .foregroundColor(isLive ? .yellow : .secondary)
                        .frame(minWidth: 75, alignment: .leading)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            if isLive {
                                Text("LIVE")
                                    .foregroundColor(.pink)
                                    .fontWeight(.bold)
                            }
                            
                            Text(epgItem.title)
                                .fontWeight(.bold)
                        }
                        
                        if isLive {
                            Text(epgItem.description)
                            
                            ProgressView(value: percentage)
                                .tint(.yellow)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(isLive ? 10 : 0)
                    .background {
                        if isLive {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.pink.opacity(0.1))
                        }
                    }
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white.opacity(0.2))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func fetchEpg() {
        Task {
            guard let liveStream = media as? LiveStream else {
                return
            }
            
            do {
                let epgList = try await contentData.api.epgList(liveStream: liveStream)
                epgItems = epgList.epgListings
            } catch {
                print(error)
            }
        }
    }
}

#if os(macOS)
struct AVVideoPlayer: NSViewControllerRepresentable {
    var player: AVPlayer

    func makeNSViewController(context: Context) -> AVPlayerViewController {
        let view = AVPlayerView()
        view.player = player
        view.allowsPictureInPicturePlayback = true
        view.showsFullScreenToggleButton = true

        let vc = AVPlayerViewController()
        vc.view = view

        return vc
    }
    
    func updateNSViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
    
}

class AVPlayerViewController: NSViewController {
    override func loadView() {
        self.view = NSView()
    }
}
#else
struct AVVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = player
        vc.allowsPictureInPicturePlayback = true
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }
}
#endif

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(
            media: LiveStream(
                id: 17397,
                number: 17397,
                name: "Ziggo Sport Select",
                icon: URL(string: "http://logos.iptvurban.com/ziggosportselect.png")!,
                epgChannelId: "Ziggo.Sport.Select.nl",
                added: "1654695112",
                categoryId: "54",
                customSid: "",
                tvArchive: false,
                directSource: "http://31.43.191.59:8080/WHT1344/zNAqmDwYC4/3921",
                tvArchiveDuration: "0"
            )
        )
        .frame(minWidth: 900, minHeight: 600)
    }
}
