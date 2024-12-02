--1. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số 
--lượng từ 10 đến 20, và tổng trị giá hóa đơn lớn hơn 500.000.
SELECT DISTINCT hd.SOHD
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
WHERE (cthd.MASP = 'BB01' OR cthd.MASP = 'BB02')
  AND cthd.SL BETWEEN 10 AND 20
  AND hd.TRIGIA > 500000;

--2. Tìm các số hóa đơn mua cùng lúc 3 sản phẩm có mã số “BB01”, “BB02” và “BB03”, mỗi sản 
--phẩm mua với số lượng từ 10 đến 20, và ngày mua hàng trong năm 2023.
SELECT DISTINCT hd.SOHD
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
WHERE ((cthd.MASP = 'BB01' OR cthd.MASP = 'BB02' OR cthd.MASP = 'BB03') 
  AND cthd.SL BETWEEN 10 AND 20)
  AND hd.NGHD BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY hd.SOHD
HAVING COUNT(DISTINCT cthd.MASP) = 3;

--3. Tìm các khách hàng đã mua ít nhất một sản phẩm có mã số “BB01” với số lượng từ 10 đến 20, và 
--tổng trị giá tất cả các hóa đơn của họ lớn hơn hoặc bằng 1 triệu đồng.
SELECT DISTINCT hd.MAKH
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
WHERE cthd.MASP = 'BB01' 
  AND cthd.SL BETWEEN 10 AND 20
GROUP BY hd.MAKH
HAVING SUM(hd.TRIGIA) >= 1000000;

--4. Tìm các nhân viên bán hàng đã thực hiện giao dịch bán ít nhất một sản phẩm có mã số “BB01” 
--hoặc “BB02”, mỗi sản phẩm bán với số lượng từ 15 trở lên, và tổng trị giá của tất cả các hóa đơn mà 
--nhân viên đó xử lý lớn hơn hoặc bằng 2 triệu đồng.
SELECT DISTINCT hd.MANV
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
WHERE (cthd.MASP = 'BB01' OR cthd.MASP = 'BB02')
  AND cthd.SL >= 15
GROUP BY hd.MANV
HAVING SUM(hd.TRIGIA) >= 2000000;

--5. Tìm các khách hàng đã mua ít nhất hai loại sản phẩm khác nhau với tổng số lượng từ tất cả các hóa 
--đơn của họ lớn hơn hoặc bằng 50 và tổng trị giá của họ lớn hơn hoặc bằng 5 triệu đồng.
SELECT DISTINCT hd.MAKH
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
GROUP BY hd.MAKH
HAVING COUNT(DISTINCT cthd.MASP) >= 2
   AND SUM(cthd.SL) >= 50
   AND SUM(hd.TRIGIA) >= 5000000;

--6. Tìm những khách hàng đã mua cùng lúc ít nhất ba sản phẩm khác nhau trong cùng một hóa đơn và mỗi sản phẩm đều có số lượng từ 5 trở lên.
SELECT DISTINCT hd.MAKH
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
WHERE cthd.SL >= 5
GROUP BY hd.SOHD, hd.MAKH
HAVING COUNT(DISTINCT cthd.MASP) >= 3;

--7. Tìm các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất và đã được bán ra ít nhất 5 lần trong năm 2007
SELECT sp.MASP, sp.TENSP
FROM SANPHAM sp
JOIN CTHD cthd ON sp.MASP = cthd.MASP
JOIN HOADON hd ON cthd.SOHD = hd.SOHD
WHERE sp.NUOCSX = 'Trung Quoc'
  AND hd.NGHD BETWEEN '2007-01-01' AND '2007-12-31'
GROUP BY sp.MASP, sp.TENSP
HAVING COUNT(cthd.SOHD) >= 5;

--8. Tìm các khách hàng đã mua ít nhất một sản phẩm do “Singapore” sản xuất trong năm 2006 
--và tổng trị giá hóa đơn của họ trong năm đó lớn hơn 1 triệu đồng.
SELECT DISTINCT hd.MAKH
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
JOIN SANPHAM sp ON cthd.MASP = sp.MASP
WHERE sp.NUOCSX = 'Singapore'
  AND hd.NGHD BETWEEN '2006-01-01' AND '2006-12-31'
GROUP BY hd.MAKH
HAVING SUM(hd.TRIGIA) > 1000000;

--9. Tìm những nhân viên bán hàng đã thực hiện giao dịch bán nhiều nhất các sản phẩm do “Trung Quoc” sản xuất trong năm 2006.
SELECT hd.MANV
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
JOIN SANPHAM sp ON cthd.MASP = sp.MASP
WHERE sp.NUOCSX = 'Trung Quoc' 
  AND hd.NGHD BETWEEN '2006-01-01' AND '2006-12-31'
GROUP BY hd.MANV
ORDER BY COUNT(cthd.SOHD) DESC
LIMIT 1;

--10. Tìm những khách hàng chưa từng mua bất kỳ sản phẩm nào do “Singapore” sản xuất nhưng đã mua ít nhất một sản phẩm do “Trung Quoc” sản xuất.
SELECT DISTINCT hd.MAKH
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
JOIN SANPHAM sp ON cthd.MASP = sp.MASP
WHERE sp.NUOCSX = 'Trung Quoc'
  AND hd.MAKH NOT IN (
      SELECT hd.MAKH
      FROM HOADON hd
      JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
      JOIN SANPHAM sp ON cthd.MASP = sp.MASP
      WHERE sp.NUOCSX = 'Singapore'
  );

--11. Tìm những hóa đơn có chứa tất cả các sản phẩm do “Singapore” sản xuất và trị giá hóa đơn lớn hơn tổng trị giá trung bình của tất cả các hóa đơn trong hệ thống.
SELECT hd.SOHD
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
JOIN SANPHAM sp ON cthd.MASP = sp.MASP
WHERE sp.NUOCSX = 'Singapore'
GROUP BY hd.SOHD
HAVING COUNT(DISTINCT sp.MASP) = (SELECT COUNT(DISTINCT MASP) 
                                   FROM SANPHAM 
                                   WHERE NUOCSX = 'Singapore')
  AND hd.TRIGIA > (SELECT AVG(TRIGIA) FROM HOADON);

--12. Tìm danh sách các nhân viên có tổng số lượng bán ra của tất cả các loại sản phẩm vượt quá số lượng trung bình của tất cả các nhân viên khác.
SELECT hd.MANV
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
GROUP BY hd.MANV
HAVING SUM(cthd.SL) > (
    SELECT AVG(total)
    FROM (
        SELECT SUM(cthd.SL) AS total
        FROM HOADON hd
        JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
        GROUP BY hd.MANV
    ) AS subquery
);

--13. Tìm danh sách các hóa đơn có chứa ít nhất một sản phẩm từ mỗi nước sản xuất khác nhau có trong hệ thống.
SELECT DISTINCT hd.SOHD
FROM HOADON hd
JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
JOIN SANPHAM sp ON cthd.MASP = sp.MASP
GROUP BY hd.SOHD
HAVING COUNT(DISTINCT sp.NUOCSX) = (SELECT COUNT(DISTINCT NUOCSX) FROM SANPHAM);
