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
    @State private var filterRadius = 3.0
    @State private var filterScale = 5.0

    
    @State private var showImagePicker = false
    @State private var inputImages: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var showingFilterSheet = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
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
       
                VStack {
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                                Text("Intensity")
                            Slider(value: $filterIntensity)
                                    .onChange(of: filterIntensity) { _ in applyProcessing() }
                        }
                    }
                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                                Text("Radius")
                            Slider(value: $filterRadius, in: 0.1...200)
                                    .onChange(of: filterRadius) { _ in applyProcessing() }
                        }
                    }
                    if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                        HStack {
                                Text("Scale")
                            Slider(value: $filterScale, in: 0.1...10)
                                    .onChange(of: filterScale) { _ in applyProcessing() }
                        }
                    }
      
                }
                .padding(.vertical)
                   
                HStack {
                    Button("Change Filter") {
                        // change filter
                        showingFilterSheet = true
                    }
                    Spacer()
                    
                    Button("Save",action: savePhoto)
                        .disabled(image == nil)
                }
                
            }
            .padding([.horizontal,.bottom ])
            .navigationTitle("Instafilter")
            .onChange(of: inputImages) { _ in loadImages()}
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImages)
            }
            .confirmationDialog("Select a filer", isPresented: $showingFilterSheet) {
                Group {
                    Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                    Button("Edges") { setFilter(CIFilter.edges()) }
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                    Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                    Button("Vignette") { setFilter(CIFilter.vignette()) }
                    Button("Pointillize") { setFilter(CIFilter.pointillize()) }
                    Button("Bloom") { setFilter(CIFilter.bloom()) }
                    Button("Noir") { setFilter(CIFilter.photoEffectNoir()) }

                 
                }
                Group {
                    Button("Cancel", role: .cancel) { }
                }
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
        guard let processedImage = processedImage else { return }
        let imageSaver = ImageSaver()
      
        
        imageSaver.succesHandler = {
            print("Success!")
        }
        imageSaver.errorHandler = {
            print("Oooopppps \($0.localizedDescription)")
            
        }

        imageSaver.writeToPhotoAlbum(image: processedImage)
        withAnimation(.easeInOut(duration: 2.0)) {
            image = nil
        }
    }
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale, forKey: kCIInputScaleKey) }

      
      //  currentFilter.intensity = Float(filterIntensity)
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
            
        }
    }
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImages()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
