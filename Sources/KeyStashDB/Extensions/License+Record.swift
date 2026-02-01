import GRDB
import KeyStashModels

extension License: FetchableRecord, PersistableRecord {
	public enum Columns {
		static let id = Column(CodingKeys.id)
		static let softwareName = Column(CodingKeys.softwareName)
		static let icon = Column(CodingKeys.icon)
		static let licenseKey = Column(CodingKeys.licenseKey)
		static let registeredToName = Column(CodingKeys.registeredToName)
		static let registeredToEmail = Column(CodingKeys.registeredToEmail)
		static let downloadURLString = Column(CodingKeys.downloadURLString)
		static let notes = Column(CodingKeys.notes)
		static let createdDate = Column(CodingKeys.createdDate)
		static let updatedDate = Column(CodingKeys.updatedDate)
		static let inTrash = Column(CodingKeys.inTrash)
		static let trashDate = Column(CodingKeys.trashDate)
		static let expirationDt = Column(CodingKeys.expirationDt)
		static let purchaseDt = Column(CodingKeys.purchaseDt)
		static let version = Column(CodingKeys.version)
	}
}
