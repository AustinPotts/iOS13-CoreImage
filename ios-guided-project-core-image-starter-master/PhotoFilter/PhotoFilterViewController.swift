import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class PhotoFilterViewController: UIViewController {

    //MARK: - Properties
    private var originalImage: UIImage? {
        didSet {
            
            guard let originalImage = originalImage else {return}
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale //1x 2x or 3x
            
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            
            
            
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
            
            
            
        }
    }
    
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
            
        }
    }
    //Image
    //5000x3000 pixles
    //Scale the image down so it fits in the bounds of the screen
    
    
    
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
        
       if let scaledImage = scaledImage {
          imageView.image = filterImage(scaledImage)
        } else {
            imageView.image = nil // allows us to clear out the image
        }
        
    }
    
    
    private func presentImagePickerController(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return print("Error the phot library is unavailable")
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
        
        
    }
	 
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		// TODO: show the photo picker so we can choose on-device photos
		// UIImagePickerController + Delegate
        
        
        presentImagePickerController()
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {

        updateImage()
        
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
        updateImage()

	}
	
	@IBAction func saturationChanged(_ sender: Any) {
        updateImage()

	}
}

extension PhotoFilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Picked image")
        
        if let image = info[.originalImage] as? UIImage{
            originalImage = image
        }
        picker.dismiss(animated: true)
    }
    
}
