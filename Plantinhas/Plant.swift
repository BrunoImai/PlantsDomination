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
        case "Brotinho":
            tinyDesc = "” ... ”"
            desc = """
            "Parabéns pela sua primeira planta! O Brotin é um projeto de planta mutante, proveniente da Mutacorp! Não possui muitos diferenciais ainda mas tem muito potencial, temos certeza que logo limparemos o mundo um dia com ela!
            """
        
        case "Brotervilha":
            tinyDesc = "”awnma, awnma awnma?”"
            desc = " Foi um espanto para todos no laboratório quando vimos que na zona de plantio experimental havia uma pequena forma de vida correndo alegre e fazendo barulhos fofos, demos o apelido de Brotervilha para o ”Brotus Ervilhescus”, ainda é um mistério seu surgimento, seria uma mutacao que não fora controlada? Ou uma evolução dos Brotin?"
        
        case "Florervilha":
            tinyDesc = "”awnma, awnma!”"
            desc = "Florervilha ou “Florae Ervilhescus” é simples, carismatica e perfeita. Melhorando muito a qualidade do ar do ambiente com sua flor ela consegue ser o perfeito equilibrio de beleza e utilidade!"
        
        case "Plantapet":
            tinyDesc = "”Woof? Woof?”"
            desc = "Após as Florervilhas se tornarem presenças comuns nas casas ao redor do mundo, mais uma mutação ocorreu, não se sabe se por estarem e ambiente com muitos animais domesticos a próxima geração de plantas assumiu uma forma parecida com um pet, a ”Domesticus Plantae” não é fofa?"
        
        case "Mangandante":
            tinyDesc = "”Naum, naum!”"
            desc = """
                        Mangandante ou “Mangus Falantis” foi a primeira mutação a falar, e também a primeira a deixar de ser completamente obediente, as vezes recusando a receber ordens de seus donos...

                        Quando está de bom humor produz um delicioso suco capaz de fazer qualquer um transpirar oxigênio!
                    """
        
        case "Doidomate":
            tinyDesc = "'nao mexe comigo naum meu filho'"
            
            desc = """
            Segundo estudos científicos, a especie ”Tomatus Doidus” surge de uma mutacao poderosa. Também conhecido por sua fúria, é uma planta importante para aqueles que desejam conquistar o planeta pois libera uma boa quantidade de Oxigenio devido seus acessos de raiva.
            
            Um ótimo aliado, porém, muito cuidado, voce nao vai querer ser vítima do Tomate Doido e sua fúria.
            """
        
        case "Fazengumelo":
            tinyDesc = "”Posso ajudar em algo?”"
            desc = """
            Todos que possum um Fazengumelo em sua casa sabem o quão incrivel é a sua ajuda, ele ajuda no jardim, na cozinha e até vai ao mercado!  O ”Gumelo serventis”  produz muito oxigênio atravez das suas explosões de esporos, porém ainda não há informações sobre como isso pode afetar humanos.
            """
        
        case "Cultivanete":
            tinyDesc = "”Vamos plantar mais!”"
            desc = """
            Os Cultivanetes são excelentes agricultores e jardineiros podendo fazer uma horta crescer até 50 vezes mais rápido! Eles amam plantar, fazem isso até mesmo sem ninguém pedir!  A espécie ”Rabanetus Plantae” é a primeira mutação a conseguir cultivar outras plantas mutantes, fazendo a produção de oxigênio ser ainda mais eficaz.
            """
        
        case "Melanprendiz":
            tinyDesc = "”Pode me mostrar como isso foi feito?”"
            desc = """
            Não há nada mais curioso que um Melanprendiz, eles perguntam  e questionam sem parar sempre a procura de mais conhecimento.

            O ”Studere Melantus” em sua sede infinita por conhecimento aprende o máximo possível sobre tudo, durante esse processo ele libera quantidades monumentais de oxigênio.
            """
            
        case "Magibóbora":
            tinyDesc = "”Gostaria de ver um truque?”"
            desc = """
            Precisa de um truque, um encanto ou uma magia? A Magibóbora pode fazer para você! Manipular a realidade de maneira encantadora é o maior prazer dessa mágica planta!

            A ”Magicae Cucurbita” consegue transformar qualquer coisa em oxigênio, ainda não se sabe os limites dos efeitos anômalos dessa mutação, muito menos como sa2o realizados...
            """
        
        default:
            tinyDesc = "deu ruim"
            desc = "deu ruim"
        }
    }
}
