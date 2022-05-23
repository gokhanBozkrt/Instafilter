//
//  PwrapperToStruct.swift
//  Instafilter
//
//  Created by Gokhan Bozkurt on 22.05.2022.
//

import SwiftUI

struct PwrapperToStruct: View {
    @State private var blurAmount = 0.0
    /*
    {
     
        didSet {
            print("New Value is \(blurAmount)")
        }
      
    }
     */
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { newValue in
                    print("New Value is \(newValue)")
                }
                    
                
             
            
            Button("Rando Blur") {
                self.blurAmount = Double.random(in: 0...20)
            }
        }
        .padding(.horizontal)
    }
}

struct PwrapperToStruct_Previews: PreviewProvider {
    static var previews: some View {
        PwrapperToStruct()
    }
}
