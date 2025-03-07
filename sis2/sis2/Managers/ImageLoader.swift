import UIKit

class ImageLoader {
    weak var delegate: ImageLoaderDelegate?
    
    // Используем `[weak self]` в замыкании, чтобы избежать retain cycle
    var completionHandler: ((UIImage?) -> Void)?

    func loadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Проверяем, что `self` все еще существует
            guard let self = self else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let error = error {
                    self.delegate?.imageLoader(self, didFailWith: error)
                    self.completionHandler?(nil)
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    self.delegate?.imageLoader(self, didLoad: image)
                    self.completionHandler?(image)
                } else {
                    self.completionHandler?(nil)
                }
            }
        }.resume()
    }
}
