# priv/repo/seeds.exs
{:ok, _} = Application.ensure_all_started(:shared)

alias Shared.Repo
alias Shared.{Product, Customer, SalesOrder, SalesOrderLineItem, ProductInventory}

# Check if there are already entries in the database
if Repo.exists?(Product) or Repo.exists?(Customer) or Repo.exists?(SalesOrder) or Repo.exists?(SalesOrderLineItem) do
  IO.puts("Database already contains data. Exiting without seeding.")
else
  # Inserting Products
  product1 = Repo.insert!(%Product{
    name: "Product A",
    description: "Description for Product A",
    price: 101.00
  })

  product2 = Repo.insert!(%Product{
    name: "Product B",
    description: "Description for Product B",
    price: 220.00
  })

  product3 = Repo.insert!(%Product{
    name: "Product C",
    description: "Description for Product C",
    price: 319.00
  })

  # Inserting Customers
  customer1 = Repo.insert!(%Customer{
    first_name: "John",
    last_name: "Doe"
  })

  customer2 = Repo.insert!(%Customer{
    first_name: "Jane",
    last_name: "Smith"
  })

  # Inserting Sales Orders
  sales_order1 = Repo.insert!(%SalesOrder{
    customer_id: customer1.id,
    date: ~N[2024-08-11 10:00:00]
  })

  sales_order2 = Repo.insert!(%SalesOrder{
    customer_id: customer2.id,
    date: ~N[2024-08-11 12:00:00]
  })

  # Inserting Sales Order Line Items
  Repo.insert!(%SalesOrderLineItem{
    sales_order_id: sales_order1.id,
    product_id: product1.id,
    quantity: 2,
    subtotal: 2 * product1.price
  })

  Repo.insert!(%SalesOrderLineItem{
    sales_order_id: sales_order1.id,
    product_id: product2.id,
    quantity: 1,
    subtotal: 1 * product2.price
  })

  Repo.insert!(%SalesOrderLineItem{
    sales_order_id: sales_order2.id,
    product_id: product3.id,
    quantity: 3,
    subtotal: 3 * product3.price
  })

  # Inserting Product Inventory (if applicable)
  Repo.insert!(%ProductInventory{
    product_id: product1.id,
    quantity_reserved: 5,
    quantity_onhand: 20
  })

  Repo.insert!(%ProductInventory{
    product_id: product2.id,
    quantity_reserved: 3,
    quantity_onhand: 15
  })

  Repo.insert!(%ProductInventory{
    product_id: product3.id,
    quantity_reserved: 10,
    quantity_onhand: 30
  })

  IO.puts("Database seeded successfully.")
end
