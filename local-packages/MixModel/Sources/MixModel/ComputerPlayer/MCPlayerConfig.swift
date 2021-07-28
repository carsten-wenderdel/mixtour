import Foundation

/// The rawValue is the number of iterations the Monte Carlo player should use for evaluation.
/// Adjacent configs should lead to an ELO difference of 150.
/// According to https://en.wikipedia.org/wiki/Elo_rating_system
/// the weaker player should win 29.6615% of all games for a rating difference of 150,
/// the stronger player should win 70.3385% of all games.
/// After trying out various values for the number of iterations, these values work as an educated guess.
public enum MCPlayerConfig: Int, CaseIterable {

    case beginner1 = 45
    case beginner2 = 80
    case advanced1 = 175
    case advanced2 = 417
    case expert1 = 1_000

    public var eloRating: Int {
        switch self {
        case .beginner1:
            return 1000
        case .beginner2:
            return 1150
        case .advanced1:
            return 1300
        case .advanced2:
            return 1450
        case .expert1:
            return 1600
        }
    }
}


// These are the results of PlayerEvaluation.swift, letting different iteration values competing against each other.
// Goal is always to have an ELO difference of 150, the stronger player should win 70.3385% of all games.



// Vs 80. So we picked 45.

//        let player2 = MonteCarloPlayer(numberOfIterations: 46)
//        16112.0 iterations
//        combined: 69.61271102284012

//        let player2 = MonteCarloPlayer(numberOfIterations: 45)
//        8366.0 iterations
//        combined: 70.77456371025579

//        let player2 = MonteCarloPlayer(numberOfIterations: 41)
//        2245.0 iterations
//        combined: 74.26503340757239

//        let player2 = MonteCarloPlayer(numberOfIterations: 37)
//        2106.0 iterations
//        combined: 77.18423551756885



// Versus 175. So we picked 80

//        let player2 = MonteCarloPlayer(numberOfIterations: 80)
//        3027.0 iterations
//        combined: 70.34192269573836

//        let player2 = MonteCarloPlayer(numberOfIterations: 76)
//        3024.0 iterations
//        combined: 71.78406084656085

//        let player2 = MonteCarloPlayer(numberOfIterations: 73)
//        6112.0 iterations
//        combined: 72.0345222513089



// Versus 417. So we picked 175


//        let player2 = MonteCarloPlayer(numberOfIterations: 177)
//        3681.0 iterations
//        combined: 69.47840260798696

//        let player2 = MonteCarloPlayer(numberOfIterations: 176)
//        3009.0 iterations
//        combined: 69.8570953805251

        //        let player2 = MonteCarloPlayer(numberOfIterations: 175)
        //        4316.0 iterations
        //        combined: 70.51668211306766

//        let player2 = MonteCarloPlayer(numberOfIterations: 175)
//        2611.0 iterations
//        combined: 71.0455764075067

//        let player2 = MonteCarloPlayer(numberOfIterations: 174)
//        3006.0 iterations
//        combined: 70.60878243512974



// When competing against 1000 iterations. So we picked 417

//        let player2 = MonteCarloPlayer(numberOfIterations: 450)
//        450.0 iterations
//        combined: 69.55555555555556

//        let player2 = MonteCarloPlayer(numberOfIterations: 440)
//        1193.0 iterations
//        combined: 69.55155071248952

//        let player2 = MonteCarloPlayer(numberOfIterations: 430)
//        756.0 iterations
//        combined: 69.1137566137566

//        let player2 = MonteCarloPlayer(numberOfIterations: 420)
//        1014.0 iterations
//        combined: 71.00591715976331

//        let player2 = MonteCarloPlayer(numberOfIterations: 418)
//        1011.0 iterations
//        combined: 69.8813056379822
//
//        let player2 = MonteCarloPlayer(numberOfIterations: 417)
//        2015.0 iterations
//        combined: 70.03722084367246

//        let player2 = MonteCarloPlayer(numberOfIterations: 416)
//        2039.0 iterations
//        combined: 71.44433545855811

//        let player2 = MonteCarloPlayer(numberOfIterations: 415)
//        1078.0 iterations
//        combined: 69.68923933209648

//        let player2 = MonteCarloPlayer(numberOfIterations: 414)
//        2007.0 iterations
//        combined: 71.52466367713005

//        let player2 = MonteCarloPlayer(numberOfIterations: 413)
//        1134.0 iterations
//        combined: 71.05379188712521

//        let player2 = MonteCarloPlayer(numberOfIterations: 412)
//        1023.0 iterations
//        combined: 70.89442815249267

//        let player2 = MonteCarloPlayer(numberOfIterations: 410)
//        775.0 iterations
//        combined: 73.7741935483871

//        let player2 = MonteCarloPlayer(numberOfIterations: 400)
//        377.0 iterations
//        combined: 73.74005305039788


// When competing against 1000 iterations. So we picked 417

//        let player2 = MonteCarloPlayer(numberOfIterations: 450)
//        450.0 iterations
//        combined: 69.55555555555556

//        let player2 = MonteCarloPlayer(numberOfIterations: 440)
//        1193.0 iterations
//        combined: 69.55155071248952

//        let player2 = MonteCarloPlayer(numberOfIterations: 430)
//        756.0 iterations
//        combined: 69.1137566137566

//        let player2 = MonteCarloPlayer(numberOfIterations: 420)
//        1014.0 iterations
//        combined: 71.00591715976331

//        let player2 = MonteCarloPlayer(numberOfIterations: 418)
//        1011.0 iterations
//        combined: 69.8813056379822
//
//        let player2 = MonteCarloPlayer(numberOfIterations: 417)
//        2015.0 iterations
//        combined: 70.03722084367246

//        let player2 = MonteCarloPlayer(numberOfIterations: 416)
//        2039.0 iterations
//        combined: 71.44433545855811

//        let player2 = MonteCarloPlayer(numberOfIterations: 415)
//        1078.0 iterations
//        combined: 69.68923933209648

//        let player2 = MonteCarloPlayer(numberOfIterations: 414)
//        2007.0 iterations
//        combined: 71.52466367713005

//        let player2 = MonteCarloPlayer(numberOfIterations: 413)
//        1134.0 iterations
//        combined: 71.05379188712521

//        let player2 = MonteCarloPlayer(numberOfIterations: 412)
//        1023.0 iterations
//        combined: 70.89442815249267

//        let player2 = MonteCarloPlayer(numberOfIterations: 410)
//        775.0 iterations
//        combined: 73.7741935483871

//        let player2 = MonteCarloPlayer(numberOfIterations: 400)
//        377.0 iterations
//        combined: 73.74005305039788
