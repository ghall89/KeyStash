import Foundation

enum SortOptions: String, CaseIterable {
	case byName = "Name"
	case byAddedDt = "Date Added"
	case byUpdatedDt = "Date Updated"
}

enum OrderOptions: String, CaseIterable {
	case asc = "Ascending"
	case desc = "Descending"
}

func sortBy(sort: SortOptions, order: OrderOptions) -> ((License, License) -> Bool) {
	switch order {
		case .asc:
			switch sort {
				case .byName:
					return { license1, license2 in
						license1.softwareName.lowercased() < license2.softwareName.lowercased()
					}
				case .byAddedDt:
					return { license1, license2 in
						license1.createdDate < license2.createdDate
					}
				case .byUpdatedDt:
					return { license1, license2 in
						let updatedDate1 = license1.updatedDate ?? Date(timeIntervalSince1970: 0)
						let updatedDate2 = license2.updatedDate ?? Date(timeIntervalSince1970: 0)
						return updatedDate1 < updatedDate2
					}
			}
		case .desc:
			switch sort {
				case .byName:
					return { license1, license2 in
						license1.softwareName.lowercased() > license2.softwareName.lowercased()
					}
				case .byAddedDt:
					return { license1, license2 in
						license1.createdDate > license2.createdDate
					}
				case .byUpdatedDt:
					return { license1, license2 in
						let updatedDate1 = license1.updatedDate ?? Date(timeIntervalSince1970: 0)
						let updatedDate2 = license2.updatedDate ?? Date(timeIntervalSince1970: 0)
						return updatedDate1 > updatedDate2
					}
			}
	}
}
