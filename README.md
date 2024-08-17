# My_App (UmbrellaApp)

## First Run:

    docker-compose up -d
    mix ecto.create
    mix ecto.migrate
    iex -S mix
    Code.eval_file("apps/shared/priv/repo/seeds.exs")
	

## Seeded data info:

	Products: 2
	Customers: 2
	
	

## IEX order placement:


    OrderProducer.OrderService.create_sales_order(customer_id, [{product_a_id, product_a_quantity_purchased}, {product_b_id, product_b_quantity_purchased}])

## Happy Path (IEX):


    OrderProducer.OrderService.create_sales_order(1, [{1, 1}, {2, 1}])


## Failure Paths (IEX):

    OrderProducer.OrderService.create_sales_order(319, [{1, 1}, {2, 1}]) #bad customer id
    OrderProducer.OrderService.create_sales_order(1, [{100, 1}, {2, 1}]) #bad product id
    OrderProducer.OrderService.create_sales_order(1, [{1, 1000}, {2, 1}]) #too many items

## Restock:
Run the following to modify inventory levels. The example increases the stock of each product by 100.
	

    Shared.restock(100)
