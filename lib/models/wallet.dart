class WalletModel {

    int balance = 0;
    int deposited = 0;

    WalletModel({
        required this.balance,
        required this.deposited
    });

    @override
    String toString() {
        return "Total value with interest: $balance, from $deposited deposited";
    }

}