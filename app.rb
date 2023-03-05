require_relative 'lib/database_connection'

require_relative './lib/item_repository'
require_relative './lib/order_repository'

class Application

  # The Application class initializer
  # takes four arguments:
  #  * The database name to call `DatabaseConnection.connect`
  #  * the Kernel object as `io` (so we can mock the IO in our tests)
  #  * the ItemRepository object (or a double of it)
  #  * the OrderRepository object (or a double of it)
  def initialize(database_name, io, item_repository, order_repository)
    DatabaseConnection.connect(database_name)
    @io = io
    @item_repository = item_repository
    @order_repository = order_repository
  end

  def run
    # "Runs" the terminal application
    # so it can ask the user to enter some input
    # and then decide to run the appropriate action
    # or behaviour.
    @io.puts "Welcome to the shop management program!"
    @io.puts "What do you want to do?
    1 = list all shop items
    2 = create a new item
    3 = list all orders
    4 = create a new order"
    choice = @io.gets.chomp

    case choice
    when "1"
      @io.puts "Here's a list of all shop items:"
      repo = ItemRepository.new
      items = repo.all
      items.each do |record|
        id = record.id
        name = record.name
        price = record.price
        quantity = record.quantity
        @io.puts "##{id} #{name} - Unit Price: #{price} - Quantity: #{quantity}"
      end   
    when "3"
      @io.puts "Here's a list of all orders:"
      repo = OrderRepository.new
      orders = repo.all
      orders.each do |record|
        id = record.id
        name = record.customer_name
        date = record.order_date
        item_id = record.item_id
        @io.puts "##{id} Name: #{name} - Date: #{date} - Item ID: #{item_id}"
      end
    end 
    
    # Use `@io.puts` or `@io.gets` to
    # write output and ask for user input.
  end
end

# Don't worry too much about this if statement. It is basically saying "only
# run the following code if this is the main file being run, instead of having
# been required or loaded by another file.
# If you want to learn more about __FILE__ and $0, see here: https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants#Pre-defined_Variables
if __FILE__ == $0
  app = Application.new(
    'shop_manager',
    Kernel,
    ItemRepository.new,
    OrderRepository.new
  )
  app.run
end

