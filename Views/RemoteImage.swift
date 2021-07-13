//
//  RemoteImage.swift
//  NBAStats
//
//  Created by President Raindas on 09/07/2021.
//

import SwiftUI

struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }
    
    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading
        
        init(url: String) {
            var checkedURL = url
            if checkedURL == "" {
                checkedURL = "https://drive.google.com/uc?id=1b5GRPAof51japA3K3MDNiHZRBa2tjGDP"
            }
            
            guard let parsedURL = URL(string: checkedURL) else {
                fatalError("Invalid URL: \(checkedURL)")
            }
            
            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    print("Data 1 -> \(self.data)")
                    self.data = data
                    print("Data 2 -> \(self.data)")
                    self.state = .success
                    print("State -> \(self.state)")
                } else {
                    self.state = .failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
        
    }
    
    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image
    
    var body: some View {
        selectImage()
            .resizable()
    }
    
    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }
    
    private func selectImage() -> Image {
        let str = String(decoding: loader.data, as: UTF8.self)
        print("Select image -> \(str)")
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}

