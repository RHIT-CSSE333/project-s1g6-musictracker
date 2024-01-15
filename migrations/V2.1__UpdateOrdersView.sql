CREATE OR ALTER VIEW OrdersWithAddressAndItems
AS
select o.ID, o.Placed, o.Delivered, p.Username, p.LastName, p.FirstName, p.Address, 
	p.City, p.State, p.ZipCode, 
	r.Name as RestName, r.Address as RestAddress, r.City as RestCity, 
	mi.Name, oi.Quantity
from [Order] o
JOIN Customer c on c.Username = o.CustomerUsername
JOIN Person p on c.Username = p.Username
JOIN OrderIncludes oi on oi.OrderID = o.ID
JOIN MenuItem mi on mi.MenuItemID = oi.MenuItemID
JOIN Restaurant r on r.ID = mi.RestID
GO

CREATE VIEW UndeliveredOrders
AS
select o.ID, o.Placed, o.Delivered, p.Username, p.LastName, p.FirstName, p.Address, 
	p.City, p.State, p.ZipCode, 
	r.Name as RestName, r.Address as RestAddress, r.City as RestCity, 
	mi.Name, oi.Quantity
from [Order] o
JOIN Customer c on c.Username = o.CustomerUsername
JOIN Person p on c.Username = p.Username
JOIN OrderIncludes oi on oi.OrderID = o.ID
JOIN MenuItem mi on mi.MenuItemID = oi.MenuItemID
JOIN Restaurant r on r.ID = mi.RestID
WHERE o.Delivered is null
GO

