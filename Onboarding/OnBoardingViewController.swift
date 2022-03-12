//
//  OnBoardingViewController.swift
//  Plantinhas
//
//  Created by Deborah Santos on 10/02/22.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Start", for:.normal)
            } else{
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    var slides: [OnboardingSlide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides =  [
            
            OnboardingSlide(title:"Hello farmer!", description:"Thanks for agreeing to grow with our new Mutacorp experimental plants! Grow and produce as much oxygen as possible!", image: UIImage.init(named: "Sprouty")!),
            
            OnboardingSlide(title:"The magic seeds will emerge!", description:"Click on them for the first plants to sprout", image: UIImage.init(named: "seed")!),
            
            OnboardingSlide(title:"Drag and join!", description:"Fuse same plants to form new plant mutations that generate more oxygen! Buy upgrades with oxygen to go even further!", image: UIImage.init(named: "Farmushroom")!),
        
        ]
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if currentPage == slides.count - 1 {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
        
}


extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slide: slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int (scrollView.contentOffset.x / width)
    }
    
}


