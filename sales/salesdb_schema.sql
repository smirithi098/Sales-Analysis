CREATE DATABASE sales_db;

USE sales_db;

ALTER TABLE [inventory] WITH CHECK ADD CONSTRAINT [FK_inventory_products] FOREIGN KEY([Product_ID])
REFERENCES [products] ([Product_ID])

ALTER TABLE [inventory] WITH CHECK ADD CONSTRAINT [FK_inventory_stores] FOREIGN KEY([Store_ID])
REFERENCES [stores] ([Store_ID])

ALTER TABLE [sales] WITH CHECK ADD CONSTRAINT [FK_sales_stores] FOREIGN KEY([Store_ID])
REFERENCES [stores] ([Store_ID])

ALTER TABLE [sales] WITH CHECK ADD CONSTRAINT [FK_sales_products] FOREIGN KEY([Product_ID])
REFERENCES [products] ([Product_ID])
