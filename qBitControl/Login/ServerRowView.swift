//
//  ServerRowView.swift
//  TorrentAttempt
//
//  Created by Michał Grzegoszczyk on 30/10/2022.
//

import SwiftUI

struct ServerRowView: View {
    
    @State var id: String
    
    @State var friendlyName: String
    @State var ip: String
    @State var username: String
    @State var password: String
    
    private let defaults = UserDefaults.standard
    
    @Binding var servers: [Server]
    
    func refreshServers() -> Void {
        if let server = defaults.object(forKey: "servers") as? Data {
            let decoder = JSONDecoder()
            do {
                servers = try decoder.decode([Server].self, from: server)
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        HStack() {
            if friendlyName != "" {
                Text(friendlyName)
            } else {
                Text(ip)
            }
            Spacer()
            Image(systemName: "rectangle.portrait.and.arrow.right")
        }
        .contextMenu() {
            Button {
                var loadedServers: [Server] = []
                
                if let servers = defaults.object(forKey: "servers") as? Data {
                    let decoder = JSONDecoder()
                    do {
                        loadedServers = try decoder.decode([Server].self, from: servers)
                    } catch {
                        print(error)
                    }
                }
                
                var newServers: [Server] = []
                
                loadedServers.forEach() {
                    server in
                    if server.id != id {
                        newServers.append(server)
                    }
                }
                
                let encoder = JSONEncoder()
                
                do {
                    let encodedServers = try encoder.encode(newServers)
                    defaults.set(encodedServers, forKey: "servers")
                    refreshServers()
                } catch {
                    print(error)
                }
            } label: {
                Image(systemName: "trash")
                Text("Delete")
            }
        }
    }
}

struct ServerRowView_Previews: PreviewProvider {
    static var previews: some View {
        ServerRowView(id: "test", friendlyName: "", ip: "http://192.168.1.106:8080", username: "admin", password: "adminadmin", servers: .constant([]))
    }
}
