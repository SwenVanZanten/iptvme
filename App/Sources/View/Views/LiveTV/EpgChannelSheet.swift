import SwiftUI
import XtreamCodesKit

struct EpgChannelSheet: View {
    @EnvironmentObject var contentData: ContentViewModel
    @Environment(\.dismiss) var dismiss
    @State var epgItems: [EpgItem] = []
    @State var loading: Bool = true
    
    var media: LiveStream

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if epgItems.count == 0 && !loading {
                    Text("No programming found")
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.secondary.opacity(0.15))
                        }
                } else if loading {
                    ProgressView()
                }
                
                ForEach(epgItems) { epgItem in
                    HStack (spacing: 10) {
                        let isLive = (epgItem.start ... epgItem.end) ~= Date.now
                        let startDate = epgItem.start.timeIntervalSince1970
                        let endDate = epgItem.end.timeIntervalSince1970
                        let currentDate = Date.now.timeIntervalSince1970
                        let percentage = (currentDate - startDate) / (endDate - startDate)
                        
                        VStack(alignment: .leading) {
                            Text(epgItem.startTime)
                                .fontWeight(isLive ? .bold : .regular)
                                .foregroundColor(isLive ? .yellow : .secondary)
                                .frame(minWidth: 75, alignment: .leading)
                            Text(epgItem.endTime)
                                .foregroundColor(.secondary)
                                .frame(minWidth: 75, alignment: .leading)
                        }
                        
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
                            
                            Text(epgItem.description)
                            
                            if isLive {
                                ProgressView(value: percentage)
                                    .tint(.yellow)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.secondary.opacity(0.15))
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(width: 700, height: 400)
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
        .task {
            do {
                let epgList = try await contentData.api.epgList(liveStream: media)
                epgItems = epgList.epgListings
                
                loading = false
            } catch {
                print(error)
            }
        }
        .navigationTitle("Programming")
    }
}

struct EpgChannelSheet_Previews: PreviewProvider {
    static var previews: some View {
        EpgChannelSheet(media: .init(
            id: 976,
            number: 1,
            name: "NL| NPO 1 HD",
            icon: URL(string: "http://logo.protv.cc/picons/logos/npo1hd.png")!,
            epgChannelId: "NPO1.nl",
            added: "1570789167",
            categoryId: "3",
            customSid: "0",
            tvArchive: true,
            directSource: "",
            tvArchiveDuration: "3"
        ))
    }
}
