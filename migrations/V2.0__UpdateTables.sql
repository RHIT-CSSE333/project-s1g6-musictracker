CREATE TABLE [Order]
(
	ID int PRIMARY KEY IDENTITY(1,1),
	CustomerUsername nvarchar(20) NOT NULL REFERENCES Customer(Username),
	DriverUsername nvarchar(20) NULL REFERENCES Driver(Username),
	[Started] datetime NOT NULL,
	Placed datetime NULL,
	Delivered datetime NULL
);

CREATE TABLE OrderIncludes
(
	OrderID int REFERENCES [Order](ID),
	MenuItemID int REFERENCES MenuItem(MenuItemID),
	Quantity int NOT NULL CHECK (Quantity > 0),
	PricePerItem money NOT NULL CHECK (PricePerItem >= 0.00),
	PRIMARY KEY(OrderID, MenuItemID)
);

INSERT INTO [Order]
(CustomerUsername, DriverUsername, [Started], Placed, Delivered)
SELECT CustomerUsername, DriverUsername, OrderDateTime, OrderDateTime, OrderDateTime
FROM Orders;

INSERT INTO OrderIncludes
(OrderID, MenuItemID, Quantity, PricePerItem) -- Assumes prices haven't changed.
SELECT new.ID as OrderID,
mi.MenuItemID, Quantity, mi.Price
FROM Orders o
JOIN MenuItem mi on o.MenuItemID = mi.MenuItemID
--NOTE: THE JOIN BELOW WILL NOT OFTEN BE POSSIBLE 
--This works because we know that no orders have multiple items
--(it is possible here because the data is a bit rigged
--in more complex DBs, you may need cursors for this. We don't 
-- plan to cover this, but if you think you need it, please ask.)
JOIN [Order] new on o.CustomerUsername = new.CustomerUsername and 
o.DriverUsername = new.DriverUsername and
o.OrderDateTime = new.Placed -- CAREFUL, THIS WILL NOT OFTEN WORK

ALTER TABLE Reviews
	ADD CONSTRAINT CHK_Stars CHECK (Stars > 0 AND Stars <= 5);

Drop Table [Orders]