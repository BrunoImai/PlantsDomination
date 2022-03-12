//
//  Plant.swift
//  Plantinhas
//
//  Created by Bruno Imai on 28/01/22.
//

import Foundation
import SpriteKit

class Plant: NSObject, NSCoding  {
    
    public let node : SKSpriteNode
    public let name : String
    public let oxygenProduction : Double
    public var tinyDesc : String
    public var desc : String
    
    init(name: String, oxygeProduction: Double) {
        self.name = name
        self.node = SKSpriteNode(imageNamed: name)
        if name != "seed" {
            self.node.name = name
        } else {
            self.node.name = "seed"
        }
        self.oxygenProduction = oxygeProduction
        self.tinyDesc = ""
        self.desc = ""
    }
    
    init(name: String, oxygeProduction: Double, node: SKSpriteNode) {
        self.name = name
        self.node = node
        if name != "seed" {
            self.node.name = name
        } else {
            self.node.name = "seed"
        }
        self.oxygenProduction = oxygeProduction
        self.tinyDesc = ""
        self.desc = ""
    }
    required convenience init(coder aDecoder: NSCoder) {
        let node = aDecoder.decodeObject(forKey: "node") as! SKSpriteNode
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let oxygeProduction = aDecoder.decodeDouble(forKey: "oxygeProduction")
        
        self.init(name: name, oxygeProduction: oxygeProduction, node: node)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(node, forKey: "node")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(oxygenProduction, forKey: "oxygeProduction")
    }
    
    func setDesc() {
        switch name {
        case "Sprouty":
            tinyDesc = "” ... ”"
            desc = """
            "Congratulations on your first plant! The Sprouty is a mutant plant project, sourced from Mutacorp! It doesn't have many differentials yet but it has a lot of potential, we are sure that we will clean the world one day with it!"
            """
        
        case "Happea":
            tinyDesc = "”awnma, awnma awnma?”"
            desc = """
            " It was a surprise to everyone in the lab when we saw that in the experimental planting zone there was a small life form running around happily and making cute noises, we gave the nickname Happea to the "Happys Peas", its existence is still a mystery, it would be a mutation that was not controlled? Or an evolution of Sprouty?"
            """
        
        case "Bloom":
            tinyDesc = "”awnma, awnma!”"
            desc = "Bloom or “Peas Blooms” is simple, charismatic and perfect. By greatly improving the air quality of the environment with its flower, it can be the perfect balance of beauty and utility!"
        
        case "Puppea":
            tinyDesc = "”Woof? Woof?”"
            desc = "After Blooms became common presences in homes around the world, another mutation occurred, it is not known if because they were in an environment with many domestic animals, but the next generation of plants took on a pet-like form, the ”Domesticus Plantae” isn't it cute?"
        
        case "Manguspeaker":
            tinyDesc = "”No, Nooo!”"
            desc = """
                    Manguspeaker or "Mangus Falantis" was the first mutation to speak, and also the first to stop being completely obedient, sometimes refusing to take orders from its owners...

                    When he's in a good mood, he produces a delicious juice capable of making anyone sweat oxygen!
                    """
        
        case "Madmato":
            tinyDesc = "'Don't mess with me buddy...'"
            
            desc = """
            According to scientific studies, the species "Tomatus Doidus" has a powerful mutation. Also known for its fury, it is an important plant for those who wish to conquer the planet as it releases a good amount of oxygen due to its tantrums.
                        
            A great ally, however, be careful, you don't want to fall victim to the insane tomato and its fury.
            """
        
        case "Farmushroom":
            tinyDesc = "”I can help with something?”"
            desc = """
            Everyone who has a Farmushroom in their house knows how incredible his help is, he helps in the garden, in the kitchen and even goes to the market! "Gumelo serventis" produces a lot of oxygen through its spore explosions, but there is still no information on how this can affect humans...
            """
        
        case "Farmeradish":
            tinyDesc = "”Let's plant more!”"
            desc = """
                    Farmeradish are excellent farmers and gardeners and can make a vegetable garden grow up to 50 times faster! They love to plant, they do it even without anyone asking! The species ”Rabanetus Plantae” is the first mutation to be able to cultivate other mutant plants, making the production of oxygen even more efficient.
            """
        
        case "Melearner":
            tinyDesc = "”Can you show me how this was done?”"
            desc = """
            
            There is nothing more curious than a Melearner, they ask and question without stopping always looking for more knowledge.

            The “Studere Melantus” in its infinite thirst for knowledge learns as much as possible about everything, during the process it releases monumental amounts of oxygen.
            
            """
            
        case "Pumpkazam":
            tinyDesc = "”Would you like to see a trick?”"
            desc = """
            
            Need a trick, a charm or a spell? Pumpkazam can do it for you! Manipulating reality in a charming way is the greatest pleasure of this magical plant!

            The "Magicae Cucurbita" can transform anything into oxygen, the limits of the anomalous effects of this mutation are still unknown, much less how they are carried out...
            
            """
        case "Carrunner":
            tinyDesc = "”Orange power baby!”"
            desc = """
            Possibly the strongest plant the world has ever seen! popularly known as Carrots, the "Cenourus Bombadus" is a master at lifting heavy things. Widely used for manual work, it came to replace cranes and can lift more than 5 tons with one arm! and by the way, she is a great personal trainer...
            
                Carrunners exude oxygen during their activities, a little gross, but very good for the environment!
            """
        
        case "Spike":
            tinyDesc = "”Sting, sting, STING!”"
            desc = """
            
            Spike is the first intelligent cactus. With very little sense of humor, he will throw many truths in your face, because sincerity is his greatest characteristic. But be careful! he gets annoyed very easily, you don't want him to poke you with his sharp thorns...

            Spiky's spikes penetrate any material, even bulletproof ones, but when they hit them, it's release large amounts of oxygen.
            
            """
        
        case "Rockmush":
            tinyDesc = "”Let's rock and roll!”"
            desc = """
            Mushrooms are back but this time much bolder. Rockmush is angry and rocker, a born musician, writes songs very easily. However, he is not good at dealing with human beings and becomes very angry when thwarted. But he has a great view of society.

            Rockmush's anomalous songs manage to alter the biology of other beings, making them produce oxygen, a creepy music power.
            """
        
        case "Talkdator":
            tinyDesc = "”Would you like a cookie, sweetie? (Your mother's voice)”"
            desc = """
            With two talking heads, this mutation starts to make humans very scared. With an insatiable appetite, the incredible ability to repeat everything that is said to her, perfectly mimicking her voice, the "Predatorius Plantae" eats everything in front of her, so be very careful what you leave in her way...

            Everything eaten by this ferocious plant has its mass converted into oxygen, in the same amount.
            
            """
        
        case "Carnivore King":
            tinyDesc = "”Kneel before the king!”"
            desc = """
            
            The Carnivore King is the biggest and most powerful plant ever created among all mutations, it doesn't produce any oxygen, but its power to destroy and subjugate humanity is perfect for one thing... DOMINATION!
            
            """
        
        default:
            tinyDesc = "erro"
            desc = "erro"
        }
    }
}
