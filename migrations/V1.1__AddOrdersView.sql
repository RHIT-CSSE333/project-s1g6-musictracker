CREATE VIEW OrdersWithAddressAndItems
AS
select o.OrderDateTime, p.Username, p.LastName, p.FirstName, p.Address, 
	p.City, p.State, p.ZipCode, 
	r.Name as RestName, r.Address as RestAddress, r.City as RestCity, 
	mi.Name, o.Quantity
from Orders o
JOIN Customer c on c.Username = o.CustomerUsername
JOIN Person p on c.Username = p.Username
JOIN MenuItem mi on mi.MenuItemID = o.MenuItemID
JOIN Restaurant r on r.ID = mi.RestID
GO
