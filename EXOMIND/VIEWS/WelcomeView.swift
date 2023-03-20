//
//  ContentView.swift
//  EXOMIND
//
//  Created by aistou 💕 on 20/03/2023.
//

import SwiftUI

//Page d'accueil
struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                TitleBox
                ButtonBox
            }
            .padding()
            .navigationTitle("Accueil")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
//Composants de la vue 
extension WelcomeView {
    private var TitleBox: some View {
        VStack{
            Text("Bienvenue sur notre application!")
                           .font(.largeTitle)
                           .fontWeight(.bold)
                           .multilineTextAlignment(.center)
                           .padding()
        }
    }
    private var ButtonBox: some View {
        VStack{
            CustomButton(label: Text("C'est parti !"), destination: AnyView(WeatherReportView()))
        }
    }
}
