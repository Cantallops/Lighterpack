//
//  ContentView.swift
//  Shared
//
//  Created by acantallops on 2020/08/18.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(
      entity: DBItem.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \DBItem.name, ascending: true)
      ]
    ) var items: FetchedResults<DBItem>


    var body: some View {
        TabView {
            NavigationView {
                GearListsScreen()
            }
                .tabItem {
                    Icon(.lists)
                    Text("Lists")
                }

            NavigationView {
                ItemsListScreen()
            }
                .tabItem {
                    Icon(.gearList)
                    Text("Gear")
                }

            NavigationView {
                ProfileScreen()
            }
                .tabItem {
                    Icon(.profile)
                    Text("Profile")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}