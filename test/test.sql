SELECT
    o.id,
    c.name AS customer_name,
    c.email,
    p.name AS product_name,
    p.price,
    cat.category_name,
    s.name AS supplier_name,
    o.order_date,
    o.total_amount,
    (SELECT COUNT(*) FROM order_items oi WHERE oi.order_id = o.id) AS item_count,
    (SELECT SUM(p2.price * oi2.quantity)
     FROM order_items oi2
     JOIN products p2 ON p2.id = oi2.product_id
     WHERE oi2.order_id = o.id) AS recalculated_total
FROM orders o
LEFT JOIN customers c ON LOWER(c.id::text) = LOWER(o.customer_id::text)
LEFT JOIN order_items oi ON oi.order_id = o.id
LEFT JOIN products p ON p.id = oi.product_id
LEFT JOIN categories cat ON cat.id = p.category_id
LEFT JOIN suppliers s ON s.id = p.supplier_id
WHERE
    DATE(o.order_date) >= DATE('2024-01-01')
    AND UPPER(c.email) LIKE '%GMAIL.COM%'
    AND o.total_amount > (
        SELECT AVG(total_amount)
        FROM orders
        WHERE status <> 'cancelled'
    )
ORDER BY
    o.order_date DESC,
    c.name ASC;