import SwiftUI
import XtreamCodesKit

struct ArchiveChannelSheet: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @Environment(\.dismiss) var dismiss
    @State var loading: Bool = true
    @State var archiveList: [String: [EpgItem]] = [:]
    @State var selectedDate: String? = nil
    
    let channel: Channel
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedDate) {
                ForEach(Array(archiveList.keys.sorted().enumerated()), id: \.element) { _, date in
                    ScrollView {
                        VStack {
                            if loading {
                                ProgressView()
                            }
                            
                            ForEach(archiveList[date] ?? []) { item in
                                ArchiveChannelSheetButton(channel: channel, item: item)
                            }
                        }
                        .padding()
                    }
                    .tabItem {
                        Text(date)
                    }
                    .tag(date)
                }
            }
            .padding()
        }
        .frame(width: 700, height: 400)
        .task {
            do {
                let currentDate = Date.now.timeIntervalSince1970
                let epgList = try await contentVM.api.archiveList(liveStream: channel.liveStream)
                let filteredArchiveList = epgList.epgListings.filter { item in
                    return item.hasArchive && item.start.timeIntervalSince1970 < currentDate
                }
                
                archiveList = Dictionary(grouping: filteredArchiveList, by: { $0.startDate })
                selectedDate = archiveList.keys.first
                
                loading = false
            } catch {
                print(error)
            }
        }
        .navigationTitle("Archive")
        .toolbar {
            ToolbarItem {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct ArchiveChannelSheetButton: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @Environment(\.openWindow) var openWindow
    
    let channel: Channel
    let item: EpgItem
    
    var body: some View {
        Button {
            print(item.start.formatted(date: .long, time: .standard))
            
            openWindow(value: Playable(
                name: item.title,
                url: channel.liveStream.getTimeshiftUrl(
                    api: contentVM.api,
                    startTime: item.start,
                    minutes: 120,
                    containerExtension: ".ts"
                )
            ))
        } label: {
            HStack (spacing: 10) {
                VStack(alignment: .leading) {
                    Text(item.startTime)
                        .foregroundColor(.secondary)
                        .frame(minWidth: 75, alignment: .leading)
                    Text(item.endTime)
                        .foregroundColor(.secondary)
                        .frame(minWidth: 75, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text(item.description)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.secondary.opacity(0.15))
            }
            .contentShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(.plain)
    }
}

//struct ArchiveChannelSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        ArchiveListView()
//    }
//}
