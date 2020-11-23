SELECT * FROM SH.products p WHERE p.prod_id = (SELECT s.prod_id FROM SH.sales "
      "s WHERE s.cust_id = 100996 AND s.quantity_sold = 1 ) select;
