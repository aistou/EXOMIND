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
    @State private var cityWeathers: [WeatherData] = []
    @State private var totalSeconds: Double = 0.0
//    initialise la variable apiCallInterval à 10 secondes
    @State private var apiCallInterval: Int = 10
//     intervalle de temps en secondes entre chaque appel à l'API
    let increment = 10
    @State private var messages: [String] = ["Nous téléchargeons les données…", "C'est presque fini...", "Plus que quelques secondes avant d'avoir le résultat..."]
    @State private var currentIndex: Int = 0
//    delais d'affichage des messages
    let delay = 6.0
    
    
    
    var body: some View {
        VStack {
            VStack (spacing: 30){
                if totalSeconds < 60{
                    TitleBox
                } else {
                    Text("Résultats")
                        .font(.custom("Arial", size: 21))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.6, green: 0.58, blue: 0.8))
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                if totalSeconds == 60{
                        ArrayBox
                }
               
                if totalSeconds < 60 {
                    GaugeBox
                    .onAppear {
                     startUpdatingPercentage()
                    }
                } else {
                    ButtonBox
                }
            }
           if currentPercentage < 100 {
                MessageBox
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { timer in
                            currentIndex = (currentIndex + 1) % messages.count
                        }
                }
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
                currentPercentage = 0.0
                totalSeconds = 0.0
                cityWeathers = []
                       
                   })
            
        }
    }
    
    private var MessageBox: some View {
        VStack{
            Text(messages[currentIndex])
//             permet au texte de s'étendre sur plusieurs lignes
                .fixedSize(horizontal: false, vertical: true)
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
            ForEach(cityWeathers, id: \.name) { weather in
                HStack {
                    Text(weather.name.replacingOccurrences(of: "Arrondissement de ", with: ""))
                        .font(.subheadline)
                        .padding(.horizontal, 8)
                    Spacer()
                    Text("\(Int(weather.main.temp - 273.15))°C")
                        .font(.subheadline)
                        .padding(.horizontal, 8)
                    Image(systemName: getWeatherIcon(for: weather.weather.first?.description ?? "").iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                        .foregroundColor(getWeatherIcon(for: weather.weather.first?.description ?? "").color)
                        .padding(.horizontal, 8)
                }
                Divider()
            }
           
        }.padding()
    }
    
    private var GaugeBox: some View {
        VStack {
                  Gauge(value:currentPercentage, in: 0...100, label: {
                     
                  })
                  .padding()
                  .gaugeStyle(.linearCapacity)
                  .tint(Gradient(colors: [Color(red: 165/255, green: 150/255, blue: 207/255), Color(red: 107/255, green: 116/255, blue: 179/255)]))
                  .scaleEffect(CGSize(width: 1.0, height: 1.5))
                  .overlay(
                    Text("\(currentPercentage, specifier: "%.0f") %")
                          .font(.system(size: 14))
                          .fontWeight(.bold)
                          .foregroundColor(Color(red: 0.6, green: 0.58, blue: 0.8))
                          .offset(x: 150)
                        
                  )
              }
           
    }
    func fetchWeatherData() {
        let cities = ["Rennes", "Paris", "Nantes", "Bordeaux", "Lyon"]
        let apiKey = "3a629d79e54f226d5778cb740a6c7a61"
        var delay = 0
        for city in cities {
            Get_Properties(city: city, apiKey: apiKey) { weatherData, icon, error in
                if let error = error {
                    print("Error fetching weather data for \(city): \(error)")
                    return
                }
                guard let weatherData = weatherData else {
                    print("No weather data for \(city)")
                    return
                }
                print("Weather data for \(city): \(weatherData)")
                if let icon = icon {
                    print("Icon for \(city): \(icon)")
                }
            }
           
            delay += 10
        }
    }
    
    func updatePercentage() {
//         chaque 10 secondes, la jauge doit augmenter de 16.67%
        let increment = 10
        totalSeconds += Double(increment)

        if totalSeconds >= 60 {
            currentPercentage = 100
            print("100%")
            return
        }

        currentPercentage = (totalSeconds / 60) * 100

//         Appel à l'API pour chaque ville pendant chaque intervalle de 10 secondes
        apiCallInterval += increment
        if apiCallInterval >= 60 {
//             réinitialise la variable apiCallInterval à 0
            apiCallInterval = 0
        }
        let cities = ["Rennes", "Paris", "Nantes", "Bordeaux", "Lyon"]
        let apiKey = "3a629d79e54f226d5778cb740a6c7a61"
        let cityIndex = Int(apiCallInterval / increment) - 1
    
        if cityIndex >= 0 && cityIndex < cities.count {
            let city = cities[cityIndex]
            Get_Properties(city: city, apiKey: apiKey) { weatherData, icon, error in
                if let error = error {
                    print("Error fetching weather data for \(city): \(error)")
                    return
                }
                guard let weatherData = weatherData else {
                    print("No weather data for \(city)")
                    return
                }
//                 Ajout des données météorologiques à cityWeathers
                self.cityWeathers.append(weatherData)
                print("Weather data for \(city): \(weatherData)")
                print("Weather \(self.cityWeathers)")
            }
        }
//         met à jour la valeur toutes les 10 secondes
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(increment)) {
            self.updatePercentage()
        }
    }
    
    func startUpdatingPercentage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(increment)) {
//             Initialisation de la valeur à 0
            currentPercentage = 0
//             Initialisation de la valeur à 0
            totalSeconds = 0
//             Initialisation de la valeur à 0
            apiCallInterval = 0
//            Début de la mise à jour du pourcentage chaque 10 secondes
            updatePercentage()
        }
    }
    
    
//    fonction qui retourne une icône en fonction de la dessription reçu de lors de l'appel de l'API
    func getWeatherIcon(for weatherDescription: String) -> (iconName: String, color: Color, cloudColor: Color) {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        
        let isDaytime = hour >= 6 && hour < 20
        
        switch weatherDescription {
        case let x where x.contains("clear") && x.contains("cloud"):
            return ("cloud.sun.fill", isDaytime ? .yellow : .gray, isDaytime ? .gray : .blue)
        case let x where x.contains("partly") && x.contains("cloud"):
            return ("cloud.sun.fill", isDaytime ? .yellow : .gray, isDaytime ? .gray : .blue)
        case let x where x.contains("overcast"):
            return ("cloud.fill", isDaytime ? .gray : .blue, isDaytime ? .white : .gray)
        case let x where x.contains("scattered") && x.contains("cloud"):
            return ("cloud", isDaytime ? .gray : .blue, isDaytime ? .white : .gray)
        case let x where x.contains("broken") && x.contains("cloud"):
                return ("cloud.drizzle.fill", isDaytime ? .gray : .blue, isDaytime ? .white : .gray)
        case let x where x.contains("light") && x.contains("rain"):
            return ("cloud.drizzle.fill", isDaytime ? .gray : .blue, isDaytime ? .white : .gray)
        case let x where x.contains("clear"):
            return (isDaytime ? "sun.max.fill" : "moon.stars.fill", isDaytime ? .yellow : .gray, isDaytime ? .white : .gray)
        case let x where x.contains("cloud"):
            return ("cloud.fill", isDaytime ? .gray : .blue, isDaytime ? .white : .gray)
        case let x where x.contains("rain") || x.contains("drizzle"):
            return ("cloud.rain.fill", .blue, isDaytime ? .white : .gray)
        case let x where x.contains("thunderstorm"):
            return ("cloud.bolt.rain.fill", .purple, isDaytime ? .white : .gray)
        case let x where x.contains("snow"):
            return ("snow", .white, isDaytime ? .gray : .blue)
        case let x where x.contains("mist") || x.contains("smoke") || x.contains("haze") || x.contains("fog") || x.contains("dust") || x.contains("sand"):
            return ("cloud.fog.fill", isDaytime ? .gray : .blue, isDaytime ? .white : .gray)
        default:
            return ("questionmark.diamond.fill", .red, isDaytime ? .white : .gray)
        }
    }
    
}
