// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract investment {

  uint balanceAmount;
  uint depositValue;
  uint thresholdAmount;
  uint returnOnInvesment;

  event BalanceChange(uint depositAmount, uint balanceAmount);

  constructor() {
    thresholdAmount = 12;
    returnOnInvesment = 3;
  }

  function getWallet() public view returns(uint _balanceAmount, uint _depositValue) {
    return (_balanceAmount = balanceAmount, _depositValue = depositValue);
  }

  function addDepositAmount(uint _deposit) public {
    depositValue += _deposit;
    balanceAmount += _deposit;

    if(depositValue >= thresholdAmount) {
      balanceAmount += returnOnInvesment;
    }
    emit BalanceChange(depositValue, balanceAmount);

  }

  function withdrawAmount(uint _withdraw) public {
    require(balanceAmount > _withdraw, 'Not enough balance');
    balanceAmount -= _withdraw;
    depositValue -= _withdraw;

    emit BalanceChange(depositValue, balanceAmount);
  }


}
