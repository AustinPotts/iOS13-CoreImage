import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class PhotoFilterViewController: UIViewController {

    //MARK: - Properties
    private var originalImage: UIImage?
    private var context = CIContext(options: nil)
    
	@IBOutlet weak var brightnessSlider: UISlider!
	@IBOutlet weak var contrastSlider: UISlider!
	@IBOutlet weak var saturationSlider: UISlider!
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

        
        let filter = CIFilter.colorControls()
        
        print(filter)
        print(filter.attributes)
        
        // Storyboard placeholder image
        originalImage = imageView.image
        
    
        
	}
    
    func filterImage(_ image: UIImage) -> UIImage? {
        
        // UImage > CGImage > CIIMage
        
        guard let cgImage = image.cgImage else {return nil}
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.brightness = brightnessSlider.value
        filter.contrast = contrastSlider.value
        filter.saturation = saturationSlider.value
        
        guard let outputCIimage = filter.outputImage else { return nil }
        
        
        
        // Then you will have to do the reverse
        
        //Render the image (apply the filter to the image) i.e baking cookies in overn
        
        guard let outputCGImage = context.createCGImage(outputCIimage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return nil }
        
        
        return UIImage(cgImage: outputCGImage)
    }
    
    
    private func updateImage(){
        
       if let originalImage = originalImage {
       
        } else {
            imageView.image = nil // allows us to clear out the image
        }
        
    }
	 
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		// TODO: show the photo picker so we can choose on-device photos
		// UIImagePickerController + Delegate
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {

	}
	
	@IBAction func contrastChanged(_ sender: Any) {

	}
	
	@IBAction func saturationChanged(_ sender: Any) {

	}
}

