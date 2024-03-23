# Data Model - for yum-quick

## Firestore

### Collections

* `users`
* `products`
* `orders` (Subcollection within `users`)
* `cart` (Subcollection within `users`)

### Document IDs

* `users`: `<user_id>`
* `products`: `<product_id>`
* `orders`: `<order_id>` within `users/<user_id>` subcollection
* `cart`: `users/<user_id>` subcollection

### Fields

#### users

* `id` (String): Unique identifier for the user.
* `username` (String): User's chosen username.
* `email` (String, optional): User's email address (optional).
* `cartId` (String): Reference to the user's cart document ID.
* `orders` (Subcollection): List of order documents associated with the user.

#### orders

* `id` (String): Unique identifier for the order.
* `userId` (String): Reference to the user document ID.
* `deliveryDate` (Timestamp): Date and time for scheduled delivery.
* `totalPrice` (double): Total cost of the order items.
* `quantity` (int): Total number of items in the order.
* `status` (String): Current status of the order (pending, ongoing, completed, cancelled).
* `items` (Array of objects): List of ordered items with references to products.
* `formattedDate` (String, optional): Formatted date string for user display.

#### products

* `id` (String): Unique identifier for the product.
* `name` (String): Product name.
* `price` (double): Product price per unit.
* `description` (String, optional): Detailed product description (optional).
* `imageUrl` (String): URL for the product image.
* `category` (String): Product category (e.g., shawarma, pizza, burger, yogurt).
* `averageRating` (double): Average customer rating for the product.
* `inventory` (int): Available stock of the product.
* `isFavorite` (bool): Indicates whether the product is marked as a favorite by the user.

#### cart

* `userId` (String): Reference to the user document ID.
* `items` (Array of objects): List of items added to the cart with references to products.
* `deliveryCost` (double): Cost of delivery associated with the cart.
* `subtotal` (double): Total cost of the cart items before delivery.
* `total` (double): Final cost of the cart including delivery.

### Notes

* References between documents are done using document IDs.
* This data model is a basis and can be extended with additional collections and fields as needed.
* Adjust the format and details to fit your specific requirements and project needs.


## (RDBMS)

```sql
-- Users Table
CREATE TABLE Users (
  id INT PRIMARY KEY,
  username VARCHAR(255) UNIQUE,
  email VARCHAR(255)
);

-- Products Table
CREATE TABLE Products (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  price DECIMAL(10,2),
  description TEXT,
  image_url VARCHAR(255),
  category VARCHAR(255),
  inventory INT
);

-- Carts Table
CREATE TABLE Carts (
  id INT PRIMARY KEY,
  user_id INT FOREIGN KEY REFERENCES Users(id),
  subtotal DECIMAL(10,2),
  delivery_cost DECIMAL(10,2),
  total DECIMAL(10,2)
);

-- Cart_Items Table
CREATE TABLE Cart_Items (
  id INT PRIMARY KEY,
  cart_id INT FOREIGN KEY REFERENCES Carts(id),
  product_id INT FOREIGN KEY REFERENCES Products(id),
  quantity INT,
  price DECIMAL(10,2)
);

-- Orders Table
CREATE TABLE Orders (
  id INT PRIMARY KEY,
  user_id INT FOREIGN KEY REFERENCES Users(id),
  cart_id INT FOREIGN KEY REFERENCES Carts(id),
  delivery_date DATETIME,
  status ENUM('pending', 'ongoing', 'completed', 'cancelled'),
  total_price DECIMAL(10,2)
);

-- Relationships
ALTER TABLE Carts
ADD CONSTRAINT UNIQUE_CART_PER_USER UNIQUE (user_id);

ALTER TABLE Orders
ADD CONSTRAINT ONE_CART_PER_ORDER UNIQUE (cart_id);

-- Optional Notes
- This is a basic model and can be extended.
- Use appropriate data types based on your RDBMS.
- Consider using triggers/stored procedures for complex operations.


