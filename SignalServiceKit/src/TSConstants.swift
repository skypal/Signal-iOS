//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

private protocol TSConstantsProtocol: class {
    var textSecureWebSocketAPI: String { get }
    var textSecureServerURL: String { get }
    var textSecureCDNServerURL: String { get }
    var textSecureServiceReflectorHost: String { get }
    var textSecureCDNReflectorHost: String { get }
    var contactDiscoveryURL: String { get }
    var keyBackupURL: String { get }
    var storageServiceURL: String { get }
    var kUDTrustRoot: String { get }

    var serviceCensorshipPrefix: String { get }
    var cdnCensorshipPrefix: String { get }
    var contactDiscoveryCensorshipPrefix: String { get }
    var keyBackupCensorshipPrefix: String { get }

    var contactDiscoveryEnclaveName: String { get }
    var contactDiscoveryMrEnclave: String { get }

    var keyBackupEnclaveName: String { get }
    var keyBackupMrEnclave: String { get }
    var keyBackupServiceId: String { get }

    var applicationGroup: String { get }

    var serverPublicParamsBase64: String { get }
}

// MARK: -

@objc
public class TSConstants: NSObject {

    @objc
    public static let EnvironmentDidChange = Notification.Name("EnvironmentDidChange")

    // Never instantiate this class.
    private override init() {}

    @objc
    public static var textSecureWebSocketAPI: String { return shared.textSecureWebSocketAPI }
    @objc
    public static var textSecureServerURL: String { return shared.textSecureServerURL }
    @objc
    public static var textSecureCDNServerURL: String { return shared.textSecureCDNServerURL }
    @objc
    public static var textSecureServiceReflectorHost: String { return shared.textSecureServiceReflectorHost }
    @objc
    public static var textSecureCDNReflectorHost: String { return shared.textSecureCDNReflectorHost }
    @objc
    public static var contactDiscoveryURL: String { return shared.contactDiscoveryURL }
    @objc
    public static var keyBackupURL: String { return shared.keyBackupURL }
    @objc
    public static var storageServiceURL: String { return shared.storageServiceURL }
    @objc
    public static var kUDTrustRoot: String { return shared.kUDTrustRoot }

    @objc
    public static var serviceCensorshipPrefix: String { return shared.serviceCensorshipPrefix }
    @objc
    public static var cdnCensorshipPrefix: String { return shared.cdnCensorshipPrefix }
    @objc
    public static var contactDiscoveryCensorshipPrefix: String { return shared.contactDiscoveryCensorshipPrefix }
    @objc
    public static var keyBackupCensorshipPrefix: String { return shared.keyBackupCensorshipPrefix }

    @objc
    public static var contactDiscoveryEnclaveName: String { return shared.contactDiscoveryEnclaveName }
    @objc
    public static var contactDiscoveryMrEnclave: String { return shared.contactDiscoveryMrEnclave }

    @objc
    public static var keyBackupEnclaveName: String { return shared.keyBackupEnclaveName }
    @objc
    public static var keyBackupMrEnclave: String { return shared.keyBackupMrEnclave }
    @objc
    public static var keyBackupServiceId: String { return shared.keyBackupServiceId }

    @objc
    public static var applicationGroup: String { return shared.applicationGroup }

    @objc
    public static var serverPublicParamsBase64: String { return shared.serverPublicParamsBase64 }

    @objc
    public static var isUsingProductionService: Bool {
        return environment == .production
    }

    private enum Environment {
        case production, staging
    }

    private static let serialQueue = DispatchQueue(label: "SystemContactsFetcherQueue")
    private static var _forceEnvironment: Environment?
    private static var forceEnvironment: Environment? {
        get {
            return serialQueue.sync {
                return _forceEnvironment
            }
        }
        set {
            serialQueue.sync {
                _forceEnvironment = newValue
            }
        }
    }

    private static var environment: Environment {
        if let environment = forceEnvironment {
            return environment
        }
        return FeatureFlags.isUsingProductionService ? .production : .staging
    }

    @objc
    public class func forceStaging() {
        forceEnvironment = .staging
    }

    @objc
    public class func forceProduction() {
        forceEnvironment = .production
    }

    private static var shared: TSConstantsProtocol {
        switch environment {
        case .production:
            return TSConstantsProduction()
        case .staging:
            return TSConstantsStaging()
        }
    }
}

// MARK: -

private class TSConstantsProduction: TSConstantsProtocol {

    public let textSecureWebSocketAPI = "wss://textsecure-service.whispersystems.org/v1/websocket/"
    public let textSecureServerURL = "https://textsecure-service.whispersystems.org/"
    public let textSecureCDNServerURL = "https://cdn.signal.org"
    // Use same reflector for service and CDN
    public let textSecureServiceReflectorHost = "europe-west1-signal-cdn-reflector.cloudfunctions.net"
    public let textSecureCDNReflectorHost = "europe-west1-signal-cdn-reflector.cloudfunctions.net"
    public let contactDiscoveryURL = "https://api.directory.signal.org"
    public let keyBackupURL = "https://api.backup.signal.org"
    public let storageServiceURL = "https://storage.signal.org"
    public let kUDTrustRoot = "BXu6QIKVz5MA8gstzfOgRQGqyLqOwNKHL6INkv3IHWMF"

    public let serviceCensorshipPrefix = "service"
    public let cdnCensorshipPrefix = "cdn"
    public let contactDiscoveryCensorshipPrefix = "directory"
    public let keyBackupCensorshipPrefix = "backup"

    public let contactDiscoveryEnclaveName = "cd6cfc342937b23b1bdd3bbf9721aa5615ac9ff50a75c5527d441cd3276826c9"
    public var contactDiscoveryMrEnclave: String {
        return contactDiscoveryEnclaveName
    }

    public let keyBackupEnclaveName = "f2e2a5004794a6c1bac5c4949eadbc243dd02e02d1a93f10fe24584fb70815d8"
    public let keyBackupMrEnclave = "f51f435802ada769e67aaf5744372bb7e7d519eecf996d335eb5b46b872b5789"
    public var keyBackupServiceId: String {
        return keyBackupEnclaveName
    }

    public let applicationGroup = "group.org.whispersystems.signal.group"

    // GroupsV2 TODO: This is for staging. We need the production values.
    //
    // We need to discard all profile key credentials if these values ever change.
    // See: VersionedProfiles.clearProfileKeyCredentials(...)
    public let serverPublicParamsBase64 = "Mmngo/SFRpC5kRLUKE8sXnpUx0QhQGcxUGI3b5eQXUX0kgK6SSL7XWcmjQv2ZsL5qKqyADTfhBakDSSfVEr2dHheAw/6JYMjgXnYZAn1845KOk9gHwWGaISIZWR55u4xpHdqZhZBdUyQ2MuDpIurLWifw8Jq/W6pumywOTg6zAeegHWx9MwyGaQD4R35nAAcPgqWuKrlIBX/z7kCYDwEFCaZwW+KmB0HluyEN362MzuzgGv+zK1SZR2aIpBmtsFYeG7FAV7aXXwB0aqB+5kDBJYCdhrzxWAqnWHC0Gm0JFASX3yaxmIWElacrfYtqLAP9KZcfViLRa4IiBIx3w9OAQ=="
}

// MARK: -

private class TSConstantsStaging: TSConstantsProtocol {

    public let textSecureWebSocketAPI = "wss://textsecure-service-staging.whispersystems.org/v1/websocket/"
    public let textSecureServerURL = "https://textsecure-service-staging.whispersystems.org/"
    public let textSecureCDNServerURL = "https://cdn-staging.signal.org"
    public let textSecureServiceReflectorHost = "europe-west1-signal-cdn-reflector.cloudfunctions.net"
    public let textSecureCDNReflectorHost = "europe-west1-signal-cdn-reflector.cloudfunctions.net"
    public let contactDiscoveryURL = "https://api-staging.directory.signal.org"
    public let keyBackupURL = "https://api-staging.backup.signal.org"
    public let storageServiceURL = "https://storage-staging.signal.org"
    public let kUDTrustRoot = "BbqY1DzohE4NUZoVF+L18oUPrK3kILllLEJh2UnPSsEx"

    public let serviceCensorshipPrefix = "service-staging"
    public let cdnCensorshipPrefix = "cdn-staging"
    public let contactDiscoveryCensorshipPrefix = "directory-staging"
    public let keyBackupCensorshipPrefix = "backup-staging"

    // CDS uses the same EnclaveName and MrEnclave
    public let contactDiscoveryEnclaveName = "e0f7dee77dc9d705ccc1376859811da12ecec3b6119a19dc39bdfbf97173aa18"
    public var contactDiscoveryMrEnclave: String {
        return contactDiscoveryEnclaveName
    }

    public let keyBackupEnclaveName = "b5a865941f95887018c86725cc92308d34a3084dc2b4e7bd2de5e5e1690b50c6"
    public let keyBackupMrEnclave = "f51f435802ada769e67aaf5744372bb7e7d519eecf996d335eb5b46b872b5789"
    public var keyBackupServiceId: String {
        return keyBackupEnclaveName
    }

    public let applicationGroup = "group.org.whispersystems.signal.group.staging"

    // We need to discard all profile key credentials if these values ever change.
    // See: VersionedProfiles.clearProfileKeyCredentials(...)
    public let serverPublicParamsBase64 = "Mmngo/SFRpC5kRLUKE8sXnpUx0QhQGcxUGI3b5eQXUX0kgK6SSL7XWcmjQv2ZsL5qKqyADTfhBakDSSfVEr2dHheAw/6JYMjgXnYZAn1845KOk9gHwWGaISIZWR55u4xpHdqZhZBdUyQ2MuDpIurLWifw8Jq/W6pumywOTg6zAeegHWx9MwyGaQD4R35nAAcPgqWuKrlIBX/z7kCYDwEFCaZwW+KmB0HluyEN362MzuzgGv+zK1SZR2aIpBmtsFYeG7FAV7aXXwB0aqB+5kDBJYCdhrzxWAqnWHC0Gm0JFASX3yaxmIWElacrfYtqLAP9KZcfViLRa4IiBIx3w9OAQ=="
}