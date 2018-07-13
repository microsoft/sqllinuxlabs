select c.Name, c.Contact, STRING_AGG(p.Name,',') as Products
from Company c
	join Product p on c.CompanyID = p.CompanyID
group by c.CompanyID, c.Name, c.Contact

select c.Name, c.Contact,
		'[' + STRING_AGG('"' + STRING_ESCAPE(p.Name) + '"',',') + ']' as Products
from Company c
	join Product p on c.CompanyID = p.CompanyID
group by c.CompanyID, c.Name, c.Contact

select c.Name, c.Contact,
		JSON_QUERY('[' + STRING_AGG('"' + STRING_ESCAPE(p.Name) + '"',',') + ']') as Products
from Company c
	join Product p on c.CompanyID = p.CompanyID
group by c.CompanyID, c.Name, c.Contact
for json path;

WITH CustomerAlsoBuy as (
select p.ProductID, p2.Name, p2.ProductID as RelatedProductID,
	ROW_NUMBER() OVER (PARTITION BY p.ProductID ORDER BY count(ol2.OrderID) desc) orders
from Product p
	join OrderLines ol1
		on p.ProductID = ol1.ProductID
	join OrderLines ol2
		on ol1.OrderID = ol2.OrderID
		and ol1.ProductID <> ol2.ProductID
	join Product p2
		on ol2.ProductID = p2.ProductID
group by p.ProductID, p.Name, p2.ProductID, p2.Name
)
select ProductID,
 '['+STRING_AGG(
		CONCAT('{"ProductID":',RelatedProductID,',"Product":"',STRING_ESCAPE(Name,'json'),'"}'),',') + ']' Products
from CustomerAlsoBuy
where orders <= 5
group by ProductID
