//
//  WeatherReportView.swift
//  EXOMIND
//
//  Created by aistou 💕 on 20/03/2023.
//

import SwiftUI
import GaugeKit


struct WeatherReportView: View {
//     Ajouter la variable d'environnement presentationMode
    @Environment(\.presentationMode) var presentationMode
//    Variable du pourcentage en cours
    @State private var currentPercentage: Double = 0.0
    
    
    var body: some View {
        VStack {
            VStack (spacing: 30){
                TitleBox
                GaugeBox
            }
        }
        .navigationTitle("Météo")
//         cacher le bouton de retour
        .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
//                 Ajouter une action pour le bouton de retour personnalisé qui appelle dismiss sur la vue présentée
                    presentationMode.wrappedValue.dismiss()
                }) {
//                     Ajouter une image pour le bouton de retour personnalisé
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
        )
    }
}

struct WeatherReportView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherReportView()
    }
}
// Composants de la vue et fonctions
extension WeatherReportView {
    
    private var TitleBox: some View {
        VStack{
            Text("Résultats dans quelques secondes, veuillez patienter s'il vous plaît ...")
                .font(.custom("Arial", size: 21))
                .foregroundColor(Color(red: 0.6, green: 0.58, blue: 0.8))
                .multilineTextAlignment(.center)
//             permet au texte de s'étendre sur plusieurs lignes
                .fixedSize(horizontal: false, vertical: true)
                .padding()
        }
    }
    
    private var ButtonBox: some View {
        VStack{
            CustomButton(label: Text("Recommencer"), action: {
//                Code à exécuter lors du clic sur le bouton
               
                       
                   })
            
        }
    }
    
    private var MessageBox: some View {
        VStack{
            
        }.frame(height: UIScreen.main.bounds.height * 0.1) // Ajout de la contrainte de hauteur maximale
    }
    
//    Tableau du résultat météo
    private var ArrayBox: some View {
        VStack {
            HStack {
                            Text("Ville")
                    .font(.headline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 9)
                            Spacer()
                            Text("Température")
                    .font(.headline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 9)
                            Text("Ciel")
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 9)
            }
            Divider()
                   
           
        }.padding()
    }
    
    private var GaugeBox: some View {
        VStack {
                  Gauge(value:currentPercentage, in: 0...100, label: {
                     
                  }, currentValueLabel: {
                      Text(currentPercentage.formatted(.percent))
                        //  .font(.system(size: 40))
                  }, minimumValueLabel: {
                       Text("0%")
                  }, maximumValueLabel: {
                       Text("100%")
                  })
                  .padding()
                  .gaugeStyle(.linearCapacity)
                  .tint(Gradient(colors: [Color(red: 155/255, green: 150/255, blue: 207/255), Color(red: 107/255, green: 116/255, blue: 179/255)]))
                  .scaleEffect(CGSize(width: 1.0, height: 1.5))
                  .overlay(
                    Text("\(currentPercentage, specifier: "%.0f")%")
                          .font(.system(size: 14))
                          .fontWeight(.bold)
                          .foregroundColor(Color(red: 0.6, green: 0.58, blue: 0.8))
                          .offset(x: 150)
                        
                  )
              }
           
    }
    
}
