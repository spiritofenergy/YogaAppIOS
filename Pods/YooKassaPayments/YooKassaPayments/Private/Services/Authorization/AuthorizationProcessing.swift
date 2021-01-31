import class When.Promise
import enum YooKassaWalletApi.AuthType
import struct YooKassaWalletApi.AuthTypeState
import struct YooKassaWalletApi.MonetaryAmount

enum AuthorizationProcessingError: Error {
    case passportNotAuthorized
}

protocol AuthorizationProcessing {
    func getMoneyCenterAuthToken() -> String?

    func setMoneyCenterAuthToken(
        _ token: String
    )

    func getWalletToken() -> String?

    func hasReusableWalletToken() -> Bool

    func logout()

    func setWalletDisplayName(
        _ walletDisplayName: String?
    )

    func getWalletDisplayName() -> String?

    // MARK: - Wallet 2FA

    func loginInWallet(
        merchantClientAuthorization: String,
        amount: MonetaryAmount,
        reusableToken: Bool,
        tmxSessionId: String?
    ) -> Promise<WalletLoginResponse>

    func startNewAuthSession(
        merchantClientAuthorization: String,
        contextId: String,
        authType: AuthType
    ) -> Promise<AuthTypeState>

    func checkUserAnswer(
        merchantClientAuthorization: String,
        authContextId: String,
        authType: AuthType,
        answer: String,
        processId: String
    ) -> Promise<WalletLoginResponse>
}
