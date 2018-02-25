require 'csv'
require 'pp'

class Entry

  attr_reader :payee, :category, :category_group, :account, :memo,
              :inflow, :outflow, :cleared, :month, :day, :year

  def initialize(row)
    #@row = row
    @payee = clean_string(row["Payee"])
    @category = clean_string(row["Category"])
    @category_group = clean_string(row["Category Group"])
    @account = clean_string(row["Account"])
    @memo = clean_string(row["Memo"])
    @inflow = blank_if_zero(row["Inflow"])
    @outflow = blank_if_zero(row["Outflow"])
    @cleared = cleared_string(row["Cleared"])
    @month, @day, @year = month_day_year(row["Date"])
  end

  # TODO: More precise whitespace formatting
  def to_transaction
    return if inflow.empty? && outflow.empty?

    if payee.include?("Transfer :")
      return if outflow.empty?
      source = payee.split(":").last.strip
    else
      source = ""
      source += "#{category_group}:" unless category_group.empty?
      source += category unless category.empty?
    end

    return if source.empty?

    result = ""
    result += "#{year}/#{month}/#{day} #{cleared} #{payee}\n"
    result += "     ; #{memo}\n" unless memo.empty?
    result += "     #{source}              #{outflow}\n"
    result += "     #{account}             #{inflow}\n"
  end

  private

  def cleared_string(cleared)
    cleared == "Uncleared" ? "!" : "*"
  end

  def month_day_year(date)
    date ? date.split("/") : Tuple.new("", "", "")
  end

  def clean_string(str)
    str ? str.strip : ""
  end

  def blank_if_zero(amount)
    amount =~ /\A\$?0.00\z/ ? "" : amount
  end
end


def main
  filepath = ARGV.first

  # Read entries from file
  entries = CSV.read(filepath, headers: true, encoding: "BOM|UTF-8").map do |row|
    Entry.new row
  end

  # Create ledger transactiosn for each entry
  # TODO: Handle splits automatically
  transactions = entries.map do |entry|
    begin
      entry.to_transaction
    rescue => e
      puts e
      pp entry
    end
  end

  # Write transactions to file
  # TODO: smarter sorting, currently assumes reverse order
  puts transactions.compact.reverse.join("\n")
end

main if __FILE__ == $0
