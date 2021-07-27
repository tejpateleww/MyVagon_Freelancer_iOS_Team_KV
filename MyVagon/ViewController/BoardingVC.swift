//
//  BoardingVC.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import UIKit


struct BoardingSlidesModel  {
    let title:String
    let description:String
    let image:UIImage
}

class BoardingCell: UICollectionViewCell {
    
    static let identifier = String(describing: BoardingCell.self)
    
    
    @IBOutlet weak var ImgView_Width_Constraints: NSLayoutConstraint!
    @IBOutlet weak var slideImageView: UIImageView!
    
    @IBOutlet weak var slidetitlelabel: UILabel!
    @IBOutlet weak var slideDescriptionLabel: UILabel!
    
    
    func setup(_ slides:BoardingSlidesModel) {
        slideImageView.image = slides.image
        slidetitlelabel.text = slides.title
        slideDescriptionLabel.text = slides.description
     
        slidetitlelabel.font = CustomFont.PoppinsBold.returnFont(16)
        slideDescriptionLabel.font = CustomFont.PoppinsRegular.returnFont(16)
    }
    
    
}


class BoardingVC: BaseViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!//9154D8
    @IBOutlet weak var BtnNext: UIButton!
    @IBOutlet weak var BoardingCollectionView: UICollectionView!
    
   
    //Get started using MyVagon!
    
    var progess : CGFloat = 1.0
    var slides : [BoardingSlidesModel] = []
    var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                BtnNext.setTitle("Get Started", for: .normal)
                progressBar.progress = 1.0
                setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [NavItemsRight.none.value], isTranslucent: true)
                
              
            }else {
                BtnNext.setTitle("Next", for: .normal)
                if currentPage == 0 {
                    progressBar.progress = 0.333
                    setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [NavItemsRight.skip.value], isTranslucent: true)
                    
                }
                else if currentPage == 1 {
                    progressBar.progress = 0.666
                    setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [NavItemsRight.skip.value], isTranslucent: true)
                   
                }else if currentPage == 2 {
                    progressBar.progress = 1.0
                    setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [NavItemsRight.none.value], isTranslucent: true)
                    
                }
                
            }
        }
    }
    //MARK:-viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [NavItemsRight.skip.value], isTranslucent: true)
       
        initSetup()
        
      
        slides = [BoardingSlidesModel(title: "Easy to Book", description: "There are many variations of passages of lorem ipsum available,but the majority have suffered alteration in some form", image: #imageLiteral(resourceName: "Truck_1")),BoardingSlidesModel(title:"On Demand Truck", description: "There are many variations of passages of lorem ipsum available,but the majority have suffered alteration in some form", image:#imageLiteral(resourceName: "Truck_2")),BoardingSlidesModel(title:"Heavy Loading", description: "There are many variations of passages of lorem ipsum available,but the majority have suffered alteration in some form", image: #imageLiteral(resourceName: "Truck_3"))]
      
     }
    
    func initSetup(){
        
        
        
        progressBar.progress = 0.33
        progressBar.progressTintColor = colors.progesBarTrack.value
        progressBar.trackTintColor = colors.progessBarTintColor.value
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 4
        progressBar.subviews[1].clipsToBounds = true
        
      
        BtnNext.titleLabel?.font = CustomFont.PoppinsBold.returnFont(16)
    }
    
    
    @IBAction func SkipBtnClicked(_ sender: Any) {
        appDel.NavigateToLogin()
        
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        if currentPage == slides.count - 1 {
            print("Get Started")
            progressBar.progress = 1.0
            setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [NavItemsRight.none.value], isTranslucent: true)
            
           
            appDel.NavigateToLogin()
            
            
            
        }else {
            setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: "", rightImages: [NavItemsRight.skip.value], isTranslucent: true)
            currentPage += 1
            if currentPage == 1 {
                progressBar.progress = 0.666
            }else if currentPage == 2 {
                progressBar.progress = 1.0
            }
            let indexPath = IndexPath(item: currentPage, section: 0)
            BoardingCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let width = view.frame.width
        print("scrollView",width)
        currentPage = Int(scrollView.contentOffset.x / width)
        print(currentPage)
    }
    
    
    
    
    
}


extension BoardingVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardingCell.identifier, for: indexPath) as! BoardingCell
        cell.setup(slides[indexPath.row])
        
        cell.ImgView_Width_Constraints.constant = collectionView.frame.width
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("Width",BoardingCollectionView.frame.width)
        return CGSize(width: BoardingCollectionView.frame.width, height: BoardingCollectionView.frame.height)
    }
    
    
    
    
}
extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
