import class YooKassaPaymentsApi.PaymentOption

protocol YooMoneyAuthInteractorInput: class, AnalyticsTrackable {
    func fetchYooMoneyPaymentMethods(
        moneyCenterAuthToken: String,
        walletDisplayName: String?
    )
}

protocol YooMoneyAuthInteractorOutput: class {
    func didFetchYooMoneyPaymentMethods(
        _ paymentMethods: [PaymentOption]
    )
    func didFetchYooMoneyPaymentMethods(
        _ error: Error
    )
}
