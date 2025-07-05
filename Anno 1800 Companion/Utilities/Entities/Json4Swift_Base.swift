/* 
Copyright (c) 2025 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Json4Swift_Base : Codable {
	let farmers : Farmers?
	let workers : Workers?
	let artisans : Artisans?
	let engineers : Engineers?
	let investors : Investors?
	let scholars : Scholars?
	let jornaleros : Jornaleros?
	let obreros : Obreros?
	let explorers : Explorers?
	let technicians : Technicians?
	let shepherds : Shepherds?
	let elders : Elders?

	enum CodingKeys: String, CodingKey {

		case farmers = "farmers"
		case workers = "workers"
		case artisans = "artisans"
		case engineers = "engineers"
		case investors = "investors"
		case scholars = "scholars"
		case jornaleros = "jornaleros"
		case obreros = "obreros"
		case explorers = "explorers"
		case technicians = "technicians"
		case shepherds = "shepherds"
		case elders = "elders"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		farmers = try values.decodeIfPresent(Farmers.self, forKey: .farmers)
		workers = try values.decodeIfPresent(Workers.self, forKey: .workers)
		artisans = try values.decodeIfPresent(Artisans.self, forKey: .artisans)
		engineers = try values.decodeIfPresent(Engineers.self, forKey: .engineers)
		investors = try values.decodeIfPresent(Investors.self, forKey: .investors)
		scholars = try values.decodeIfPresent(Scholars.self, forKey: .scholars)
		jornaleros = try values.decodeIfPresent(Jornaleros.self, forKey: .jornaleros)
		obreros = try values.decodeIfPresent(Obreros.self, forKey: .obreros)
		explorers = try values.decodeIfPresent(Explorers.self, forKey: .explorers)
		technicians = try values.decodeIfPresent(Technicians.self, forKey: .technicians)
		shepherds = try values.decodeIfPresent(Shepherds.self, forKey: .shepherds)
		elders = try values.decodeIfPresent(Elders.self, forKey: .elders)
	}

}