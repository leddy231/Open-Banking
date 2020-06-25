
let sebData = {
    "resourceId": "8386f81a-10a3-4b8a-a10d-de58adf4706d",
    "iban": "SE8050000000052800025220",
    "bban": "52800025220",
    "currency": "SEK",
    "ownerName": "Berit Demosson",
    "ownerId": "40073144970009",
    "balances": [
      {
        "balanceType": "interimAvailable",
        "creditLimitIncluded": false,
        "balanceAmount": {
          "currency": "SEK",
          "amount": "102.34"
        }
      }
    ],
    "creditLine": "50000.00",
    "product": "Privatkonto",
    "name": "Lönekonto",
    "status": "deleted",
    "statusDate": "2017-10-10",
    "bic": "ESSESESS",
    "bicAddress": "SEB, 106 40 Stockholm",
    "accountInterest": "0.0",
    "cardLinkedToTheAccount": true,
    "paymentService": false,
    "bankgiroNumber": "1254",
    "accountOwners": {
      "name": "Callie Wilson"
    },
    "aliases": [
      {
        "id": 9008004,
        "type": "bgnr"
      }
    ],
    "interests": {
      "posted": [
        {
          "interestCapitalizationPostingDate": "2018-12-30",
          "transactionAccountId": "5XXXXXXXXXX",
          "interestCapitalizationAccountId": "5XXXXXXXXXX",
          "interestType": "Credit",
          "interestCapitalizationAmount": "152,160",
          "pdAccountability": "External"
        }
      ],
      "accrued": [
        {
          "interestDate": "2019-04-01",
          "accruedDebitInterestAmount": "-153,25",
          "accruedCreditInterestAmount": "15,12",
          "accruedPenaltyInterestAmount": "-250,00",
          "accruedDebitInterestAmountAdjusted": "-100,00",
          "accruedCreditInterestAmountAdjusted": "0,00",
          "accruedPenaltyInterestAmountAdjusted": "0,00",
          "accruedPenaltyInterestAmountLP": "-250,00",
          "accruedPenaltyInterestAmountAdjustedLP": "0,00",
          "pdAccountability": "External",
          "accruedCreditInterestIndicator": "Y",
          "accruedDebitInterestIndicator": "Y"
        }
      ]
    },
    "interestConditions": {
      "interests": [
        {
          "interestType": "Credit",
          "interestRateType": "BaseRate",
          "calculationBase": "Per band",
          "pdAccountability": "External",
          "tiers": [
            {
              "upperBalance": 100000,
              "effectiveDate": "2019-02-01",
              "absoluteRate": "majappuk",
              "interestRate": "0.5",
              "referenceRateType": "SEBBaseRate",
              "interestCapitalizationFrequence": 1,
              "dayCountConvention": "1/ACT",
              "pegAmount": "10.000"
            }
          ]
        }
      ]
    },
    "limits": {
      "intraDayLimit": "25000.000",
      "intraDayLimitDate": "2019-11-12",
      "endOfDayLimit": "25000.000",
      "endOfDayLimitDate": "2019-11-12"
    },
    "_links": {
      "transactions": {
        "href": "/accounts/8386f81a-10a3-4b8a-a10d-de58adf4706d/transactions?bookingStatus=booked"
      }
    }
}

let nordeaData = {
    "country": "SE",
    "account_numbers": [
        {
        "value": "41351300039",
        "_type": "BBAN_SE"
        },
        {
        "value": "SE8030000000041351300039",
        "_type": "IBAN"
        }
    ],
    "currency": "SEK",
    "account_name": "Margit Alros",
    "product": "PERSONKONTO",
    "account_type": "Current",
    "available_balance": "56594.75",
    "booked_balance": "56594.75",
    "value_dated_balance": "34215.15",
    "bank": {
        "name": "Nordea",
        "bic": "NDEASESS",
        "country": "SE"
    },
    "status": "OPEN",
    "credit_limit": "1000.00",
    "latest_transaction_booking_date": "2020-06-24",
    "_links": [
        {
        "rel": "details",
        "href": "/v4/accounts/SE41351300039-SEK"
        },
        {
        "rel": "transactions",
        "href": "/v4/accounts/SE41351300039-SEK/transactions"
        }
    ],
    "_id": "SE41351300039-SEK"
    }
