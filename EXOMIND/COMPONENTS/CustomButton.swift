//
//  CustomButton.swift
//  EXOMIND
//
//  Created by aistou 💕 on 20/03/2023.
//

import SwiftUI

// Définit un bouton nommée CustomButton, qui prend un Label peut être utiliser comme un bouton qui fait une action,  une redirection,  une action et une redirection
struct CustomButton<Label: View>: View {
//     Définit une propriété label qui est une vue générique Label
    var label: Label
//    Définit une propriété optionnelle action qui est une closure ne renvoyant rien
    var action: (() -> Void)? = nil
//    Définit une propriété optionnelle destination qui est une vue encapsulée dans une AnyView
    var destination: AnyView? = nil
    
//     Définit le contenu principal de la vue
    var body: some View {
//        Utilise GeometryReader pour obtenir des informations sur la taille disponible de la vue parente
        GeometryReader { geo in
//             Vérifie si l'option action a été définie
            if let action = action {
//                 Si oui, crée un bouton avec l'action définie
                Button(action: action) {
//                     Utilise la propriété label pour définir le contenu du bouton
                    label
//                         Définit la police de caractères, la couleur de la police et la taille du bouton pour remplir l'espace disponible
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10.0)
                }
//                 Applique un style personnalisé au bouton
                .buttonStyle(CustomButtonStyle())
//             Vérifie si l'option destination a été définie
            } else if let destination = destination {
//                Si oui, crée un lien de navigation vers la destination définie
                NavigationLink(destination: destination) {
//                     Utilise la propriété label pour définir le contenu du bouton
                    label
//                         Définit la police de caractères, la couleur de la police et la taille du bouton pour remplir l'espace disponible
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10.0)
                }
//                Applique un style personnalisé au bouton
                .buttonStyle(CustomButtonStyle())
//             Si aucune option n'est définie, crée simplement un bouton avec le contenu de la propriété label
            } else {
                label
//                     Définit la police de caractères, la couleur de la police et la taille du bouton pour remplir l'espace disponible
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10.0)
            }
        }
//         Définit une taille spécifique pour le bouton
        .frame(width: 150, height: 50)
    }
}

// Définit un style personnalisé pour les boutons
struct CustomButtonStyle: ButtonStyle {
//     Modifie l'apparence du bouton en fonction de son état (appuyé ou non)
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

// Définit une preview pour la vue CustomButton

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(label: Text("Start"))
    }
}

