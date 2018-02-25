# ynab_to_ledger

Convert a YNAB ([You Need a Budget](https://www.youneedabudget.com)) export to a [Ledger](http://ledger-cli.org) journal.

## Usage

First, export your data from YNAB:

* Go to My Budget -> Export budget data
* Download and unzip the archive

Next, run `ynab_to_ledger.rb` to output the converted filet to stdout:
`$ ruby ynab_to_ledger.rb My\ Budget\ as\ of\ 2016-10-02\ 1007\ PM\ -\ Register.csv`

You can write to a file using standard shell syntax:
`$ ruby ynab_to_ledger.rb My\ Budget\ as\ of\ 2016-10-02\ 1007\ PM\ -\ Register.csv > ledger.dat`

## TODO

- Align amounts in result
- Handle split transactions automatically
- Smarter sort
- Allow some configurable control over output
