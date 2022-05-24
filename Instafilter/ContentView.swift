//
//  ContentView.swift
//  Instafilter
//
//  Created by Gokhan Bozkurt on 22.05.2022.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showImagePicker = false
    @State private var inputImages: UIImage?
    
    @State private var currentFilter = CIFilter.sepiaTone()
    let context  = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                    
                }
                .onTapGesture {
                    showImagePicker.toggle()
                }
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in applyProcessing() }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        // change filter
                    }
                    Spacer()
                    
                    Button("Save",action: savePhoto)
                }
                
            }
            .padding([.horizontal,.bottom ])
            .navigationTitle("Instafilter")
            .onChange(of: inputImages) { _ in loadImages()}
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImages)
            }
        }
    }
    func loadImages() {
        guard let inputImages = inputImages else { return }
       let beginImage = CIImage(image: inputImages)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        

    }
    func savePhoto() {
        
    }
    func applyProcessing() {
        currentFilter.intensity = Float(filterIntensity)
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
