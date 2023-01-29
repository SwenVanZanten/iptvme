import SwiftUI
import XtreamCodesKit
import AVKit
import CachedAsyncImage

struct LiveTvPlayerView: View {
    @EnvironmentObject var contentData: ContentViewModel
    
    let playable: Playable
    let player: AVPlayer = AVPlayer()
    
    var body: some View {
        GeometryReader { proxy in
            AVVideoPlayer(player: player)
                .onAppear() {
                    player.replaceCurrentItem(with: AVPlayerItem(url: playable.url))
                    player.preventsDisplaySleepDuringVideoPlayback = true
                    player.play()
                }
                .onDisappear() {
                    player.pause()
                }
                .frame(maxWidth: .infinity, idealHeight: proxy.size.width / (16/9))
                .navigationTitle(playable.name)
        }
    }
}

struct LiveTvPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        LiveTvPlayerView(playable: .init(name: "NPO 1", url: URL(string: "http://975")!))
    }
}
