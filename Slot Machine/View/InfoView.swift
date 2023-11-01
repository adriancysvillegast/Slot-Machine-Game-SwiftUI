//
//  InfoView.swift
//  Slot Machine
//
//  Created by Adriancys Jesus Villegas Toro on 25/10/23.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section {
                    FormRowView(firstItem: "Application", secoundItem: "Slot Machine")
                    FormRowView(firstItem: "Plataform", secoundItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secoundItem: "Adriancys")
                    FormRowView(firstItem: "Designer", secoundItem: "Rober Petras")
                    FormRowView(firstItem: "Music", secoundItem: "Dua Lipa")
                } header: {
                    Text("About The Application")
                }

            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top,40)
        .overlay (
            Button {
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
                .padding(.top, 30)
                .padding(.trailing, 20)
                .tint(Color.secondary)
            , alignment: .topTrailing
        )
        .onAppear {
            playsound(sound: "background-music", type: "mp3")
        }
    }
}


struct FormRowView: View {
    
    var firstItem: String
    var secoundItem: String
    
    var body: some View {
        HStack{
            Text(firstItem)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(secoundItem)
        }
    }
}



struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}


