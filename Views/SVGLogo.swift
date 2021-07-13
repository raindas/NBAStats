//
//  SVGLogo.swift
//  NBAStats
//
//  Created by President Raindas on 09/07/2021.
//

import SwiftUI
import SVGKit

struct SVGLogo: UIViewRepresentable {
    
    var SVGUrl: String
    let frameWidth: Int
    let frameHeight: Int
    
    func makeUIView(context: Context) -> UIImageView {
        
        let svg = URL(string: SVGUrl)!
        let data = try? Data(contentsOf: svg)
        
        let imgViewObj = UIImageView()
        let logoSVG:SVGKImage = SVGKImage(data: data)
        
        logoSVG.scaleToFit(inside: CGSize(width: self.frameWidth, height: self.frameHeight))
        
        imgViewObj.contentMode = .scaleAspectFit
        
        imgViewObj.image = logoSVG.uiImage
        
        return imgViewObj
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
    
}

