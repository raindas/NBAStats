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
        
    func makeUIView(context: Context) -> UIImageView {
        
        //var SVGData = Data()
        
        let svg = URL(string: SVGUrl)!
         let data = try? Data(contentsOf: svg)
        
        let imgViewObj = UIImageView()
        let logoSVG:SVGKImage = SVGKImage(data: data)
        
        imgViewObj.image = logoSVG.uiImage
        
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//         imgViewObj.frame.size = CGSize(width: containerView.frame.width, height: containerView.frame.height)
        
        imgViewObj.contentMode = .scaleAspectFit
        
        
        // resize svg, doesn't work
               
        
        return imgViewObj
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        
        // update element if needed
        
    }
    
}

