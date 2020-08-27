//
//  ContentView.swift
//  Shared
//
//  Created by acantallops on 2020/08/18.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var sessionStore: SessionStore

    var body: some View {
        if sessionStore.isLoggedIn {
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
        } else {
            NavigationView {
                LoginScreen()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
