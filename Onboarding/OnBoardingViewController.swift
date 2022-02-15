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
                nextButton.setTitle("começar", for:.normal)
            } else{
                nextButton.setTitle("Próximo", for: .normal)
            }
        }
    }
    
    var slides: [OnboardingSlide] = [
        
        OnboardingSlide(title:"Plant Domination", description:"Olá fazendeiro! Domine o mundo e conquiste novas fazendas  com suas plantas mutantes", image:#imageLiteral(resourceName: "plant3.pdf")),
        
        OnboardingSlide(title:"As sementes mágicas vão surgir", description:"Clique nelas para as primeiras plantas brotarem", image:#imageLiteral(resourceName: "seedUpgradeIcon.pdf")),
        
        OnboardingSlide(title:"Arrate e junte", description:"as plantas iguais para formar novas mutações de plantas que geram mais oxigenio. Quanto mais plantas mais o mundo será dominado!", image:#imageLiteral(resourceName: "plant4.pdf")),
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        print("clicou")
        if currentPage == slides.count - 1 {
        
            _ = storyboard? .instantiateViewController(withIdentifier: "GameViewController") as! UINavigationController
            
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


