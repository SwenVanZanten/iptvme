//
//  AddSubscriptionView.swift
//  IPTV Me
//
//  Created by Swen van Zanten on 13/02/2023.
//

import SwiftUI

struct AddSubscriptionView: View {
    @State var showAddSubscriptionSheet: Bool = false
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .padding(.bottom, 20)
            
            Text("Welcome to IPTV Me")
                .font(.largeTitle)
            
            Text("Version 1.20")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            AddSubscriptionButton(icon: "plus.square", title: "Add a new subscription", caption: "Add your IPTV provider of choice and start watching") {
                showAddSubscriptionSheet.toggle()
            }
        
            AddSubscriptionButton(icon: "square.and.arrow.up", title: "Import a subscription", caption: "Import your previously exported subscription") {
                print("nice")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(.background)
        .sheet(isPresented: $showAddSubscriptionSheet) {
            AddSubscriptionSheet()
        }
    }
}

struct AddSubscriptionButton: View {
    var icon: String
    var title: String
    var caption: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack() {
                Image(systemName: icon)
                    .font(.title)
                VStack(alignment: .leading) {
                    Text(title)
                        .bold()
                    Text(caption)
                        .font(.caption)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct AddSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSubscriptionView()
    }
}
