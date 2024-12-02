--1. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1, đồng thời lọc ra những kỹ năng có cấp độ thấp hơn 3.
SELECT kn.TenKyNang, ckn.CapDo
FROM ChuyenGia_KyNang ckn
JOIN KyNang kn ON ckn.MaKyNang = kn.MaKyNang
WHERE ckn.MaChuyenGia = 1 AND ckn.CapDo >= 3;

--2. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2 và có ít nhất 2 kỹ năng khác nhau.
SELECT cg.HoTen
FROM ChuyenGia_DuAn cda
JOIN ChuyenGia cg ON cda.MaChuyenGia = cg.MaChuyenGia
WHERE cda.MaDuAn = 2
GROUP BY cg.HoTen
HAVING 
    COUNT(DISTINCT cg.MaChuyenGia) >= 2;

--3. Hiển thị tên công ty và tên dự án của tất cả các dự án, sắp xếp theo tên công ty và số lượng chuyên gia tham gia dự án.
SELECT ct.TenCongTy, da.TenDuAn, COUNT(cda.MaChuyenGia) AS SoChuyenGia
FROM DuAn da
JOIN CongTy ct ON da.MaCongTy = ct.MaCongTy
LEFT JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
GROUP BY ct.TenCongTy, da.TenDuAn
ORDER BY ct.TenCongTy, SoChuyenGia DESC;

--4. Đếm số lượng chuyên gia trong mỗi chuyên ngành và hiển thị chỉ những chuyên ngành có hơn 5 chuyên gia.
SELECT ChuyenNganh, COUNT(*) AS SoLuongChuyenGia
FROM ChuyenGia
GROUP BY ChuyenNganh
HAVING 
    COUNT(*) > 5;

--5. Tìm chuyên gia có số năm kinh nghiệm cao nhất và hiển thị cả danh sách kỹ năng của họ.
SELECT cg.HoTen, cg.NamKinhNghiem, kn.TenKyNang, ckn.CapDo
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ckn ON cg.MaChuyenGia = ckn.MaChuyenGia
JOIN KyNang kn ON ckn.MaKyNang = kn.MaKyNang
WHERE cg.NamKinhNghiem = (SELECT MAX(NamKinhNghiem) FROM ChuyenGia);

--6. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia, đồng thời tính toán tỷ lệ phần trăm so với tổng số dự án trong hệ thống.
SELECT cg.HoTen, COUNT(cda.MaDuAn) AS SoDuAnThamGia,(COUNT(cda.MaDuAn) * 100 / (SELECT COUNT(*) FROM DuAn)) AS TiLePhanTram
FROM ChuyenGia cg
LEFT JOIN ChuyenGia_DuAn cda ON cg.MaChuyenGia = cda.MaChuyenGia
GROUP BY cg.HoTen;

--7. Hiển thị tên công ty và số lượng dự án của mỗi công ty, bao gồm cả những công ty không có dự án nào.
SELECT ct.TenCongTy, COUNT(da.MaDuAn) AS SoDuAn
FROM CongTy ct
LEFT JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
GROUP BY ct.TenCongTy;

--8. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất, đồng thời hiển thị số lượng chuyên gia sở hữu kỹ năng đó.
SELECT kn.TenKyNang, COUNT(DISTINCT ckn.MaChuyenGia) AS SoLuongChuyenGia
FROM KyNang kn
JOIN ChuyenGia_KyNang ckn ON kn.MaKyNang = ckn.MaKyNang
GROUP BY kn.TenKyNang
ORDER BY SoLuongChuyenGia DESC;

--9. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên, đồng thời tìm kiếm những người cũng có kỹ năng 'Java'.
SELECT DISTINCT cg.HoTen
FROM ChuyenGia_KyNang ckn1
JOIN KyNang kn1 ON ckn1.MaKyNang = kn1.MaKyNang
JOIN ChuyenGia cg ON ckn1.MaChuyenGia = cg.MaChuyenGia
WHERE kn1.TenKyNang = 'Python' AND ckn1.CapDo >= 4
AND 
    EXISTS (
        SELECT 1 
        FROM ChuyenGia_KyNang ckn2
        JOIN KyNang kn2 ON ckn2.MaKyNang = kn2.MaKyNang
        WHERE ckn2.MaChuyenGia = ckn1.MaChuyenGia AND kn2.TenKyNang = 'Java'
    );

--10. Tìm dự án có nhiều chuyên gia tham gia nhất và hiển thị danh sách tên các chuyên gia tham gia vào dự án đó.
SELECT da.TenDuAn, cg.HoTen
FROM DuAn da
JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
JOIN ChuyenGia cg ON cda.MaChuyenGia = cg.MaChuyenGia
WHERE da.MaDuAn IN (
    SELECT TOP 1 MaDuAn
    FROM ChuyenGia_DuAn
    GROUP BY MaDuAn
    ORDER BY COUNT(MaChuyenGia) DESC
)
ORDER BY cg.HoTen;

--11. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia, đồng thời lọc ra những người có ít nhất 5 kỹ năng.
SELECT cg.HoTen, COUNT(ckn.MaKyNang) AS SoLuongKyNang
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ckn ON cg.MaChuyenGia = ckn.MaChuyenGia
GROUP BY cg.HoTen
HAVING COUNT(ckn.MaKyNang) >= 5;

--12. Tìm các cặp chuyên gia làm việc cùng dự án và hiển thị thông tin về số năm kinh nghiệm của từng cặp.
SELECT 
    cg1.HoTen AS ChuyenGia1, cg1.NamKinhNghiem AS KinhNghiem1,
    cg2.HoTen AS ChuyenGia2, cg2.NamKinhNghiem AS KinhNghiem2,
    da.TenDuAn
FROM ChuyenGia_DuAn cda1
JOIN ChuyenGia_DuAn cda2 ON cda1.MaDuAn = cda2.MaDuAn AND cda1.MaChuyenGia < cda2.MaChuyenGia
JOIN ChuyenGia cg1 ON cda1.MaChuyenGia = cg1.MaChuyenGia
JOIN ChuyenGia cg2 ON cda2.MaChuyenGia = cg2.MaChuyenGia
JOIN DuAn da ON cda1.MaDuAn = da.MaDuAn;

--13. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ, đồng thời tính toán tỷ lệ phần trăm so với tổng số kỹ năng mà họ sở hữu.
SELECT 
    cg.HoTen,
    COUNT(CASE WHEN ckn.CapDo = 5 THEN 1 END) AS SoKyNangCapDo5,
    (COUNT(CASE WHEN ckn.CapDo = 5 THEN 1 END) * 100.0 / COUNT(ckn.MaKyNang)) AS TiLePhanTram
FROM ChuyenGia cg
LEFT JOIN ChuyenGia_KyNang ckn ON cg.MaChuyenGia = ckn.MaChuyenGia
GROUP BY cg.HoTen;

--14. Tìm các công ty không có dự án nào và hiển thị cả thông tin về số lượng nhân viên trong mỗi công ty đó.
SELECT ct.TenCongTy, ct.SoNhanVien
FROM CongTy ct
LEFT JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
WHERE da.MaDuAn IS NULL;

--15. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào, sắp xếp theo tên chuyên gia.
SELECT cg.HoTen, da.TenDuAn
FROM ChuyenGia cg
LEFT JOIN ChuyenGia_DuAn cda ON cg.MaChuyenGia = cda.MaChuyenGia
LEFT JOIN DuAn da ON cda.MaDuAn = da.MaDuAn
ORDER BY cg.HoTen;

--16. Tìm các chuyên gia có ít nhất 3 kỹ năng, đồng thời lọc ra những người không có bất kỳ kỹ năng nào ở cấp độ cao hơn 3.
SELECT cg.HoTen
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ckn ON cg.MaChuyenGia = ckn.MaChuyenGia
GROUP BY cg.HoTen
HAVING COUNT(ckn.MaKyNang) >= 3 AND MAX(ckn.CapDo) <= 3;

--17. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó, chỉ hiển thị những công ty có tổng số năm kinh nghiệm lớn hơn 10 năm.
SELECT ct.TenCongTy, SUM(cg.NamKinhNghiem) AS TongNamKinhNghiem
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
JOIN ChuyenGia cg ON cda.MaChuyenGia = cg.MaChuyenGia
GROUP BY ct.TenCongTy
HAVING SUM(cg.NamKinhNghiem) > 10;

--18. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python', đồng thời hiển thị danh sách các dự án mà họ đã tham gia.
SELECT cg.HoTen, da.TenDuAn
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ckn1 ON cg.MaChuyenGia = ckn1.MaChuyenGia
JOIN KyNang kn1 ON ckn1.MaKyNang = kn1.MaKyNang AND kn1.TenKyNang = 'Java'
LEFT JOIN ChuyenGia_KyNang ckn2 ON cg.MaChuyenGia = ckn2.MaChuyenGia
LEFT JOIN KyNang kn2 ON ckn2.MaKyNang = kn2.MaKyNang AND kn2.TenKyNang = 'Python'
LEFT JOIN ChuyenGia_DuAn cda ON cg.MaChuyenGia = cda.MaChuyenGia
LEFT JOIN DuAn da ON cda.MaDuAn = da.MaDuAn
WHERE ckn2.MaKyNang IS NULL;

--19. Tìm chuyên gia có số lượng kỹ năng nhiều nhất và hiển thị cả danh sách các dự án mà họ đã tham gia.
WITH MaxSkills AS (
    SELECT MaChuyenGia, COUNT(MaKyNang) AS SoKyNang
    FROM ChuyenGia_KyNang
    GROUP BY MaChuyenGia
),
TopExpert AS (
    SELECT MaChuyenGia
    FROM MaxSkills
    WHERE SoKyNang = (SELECT MAX(SoKyNang) FROM MaxSkills)
)
SELECT cg.HoTen, da.TenDuAn
FROM ChuyenGia cg
JOIN ChuyenGia_DuAn cda ON cg.MaChuyenGia = cda.MaChuyenGia
JOIN DuAn da ON cda.MaDuAn = da.MaDuAn
WHERE cg.MaChuyenGia IN (SELECT MaChuyenGia FROM TopExpert);



--20. Liệt kê các cặp chuyên gia có cùng chuyên ngành và hiển thị thông tin về số năm kinh nghiệm của từng người trong cặp đó.
SELECT 
    cg1.HoTen AS ChuyenGia1, cg1.NamKinhNghiem AS KinhNghiem1,
    cg2.HoTen AS ChuyenGia2, cg2.NamKinhNghiem AS KinhNghiem2
FROM ChuyenGia cg1
JOIN ChuyenGia cg2 ON cg1.ChuyenNganh = cg2.ChuyenNganh AND cg1.MaChuyenGia < cg2.MaChuyenGia;

--21. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất và hiển thị danh sách tất cả các dự án mà công ty đó đã thực hiện.
SELECT ct.TenCongTy, da.TenDuAn
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
JOIN ChuyenGia cg ON cda.MaChuyenGia = cg.MaChuyenGia
GROUP BY ct.MaCongTy, ct.TenCongTy
HAVING 
    SUM(cg.NamKinhNghiem) = (
        SELECT MAX(SUM(cg.NamKinhNghiem))
        FROM CongTy ct2
        JOIN DuAn da2 ON ct2.MaCongTy = da2.MaCongTy
        JOIN ChuyenGia_DuAn cda2 ON da2.MaDuAn = cda2.MaDuAn
        JOIN ChuyenGia cg2 ON cda2.MaChuyenGia = cg2.MaChuyenGia
        GROUP BY ct2.MaCongTy
    );


--22. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia và hiển thị danh sách chi tiết về từng chuyên gia sở hữu kỹ năng đó cùng với cấp độ của họ.
SELECT kn.TenKyNang, cg.HoTen, ckn.CapDo
FROM KyNang kn
JOIN ChuyenGia_KyNang ckn ON kn.MaKyNang = ckn.MaKyNang
JOIN ChuyenGia cg ON ckn.MaChuyenGia = cg.MaChuyenGia
WHERE kn.MaKyNang IN (
        SELECT kn.MaKyNang
        FROM KyNang kn
        JOIN ChuyenGia_KyNang ckn ON kn.MaKyNang = ckn.MaKyNang
        GROUP BY kn.MaKyNang
        HAVING COUNT(DISTINCT ckn.MaChuyenGia) = (SELECT COUNT(*) FROM ChuyenGia)
    );


--23. Tìm tất cả các chuyên gia có ít nhất 2 kỹ năng thuộc cùng một lĩnh vực và hiển thị tên chuyên gia cùng với tên lĩnh vực đó.
SELECT cg.HoTen, kn.LoaiKyNang
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ckn ON cg.MaChuyenGia = ckn.MaChuyenGia
JOIN KyNang kn ON ckn.MaKyNang = kn.MaKyNang
GROUP BY cg.HoTen, kn.LoaiKyNang
HAVING COUNT(kn.MaKyNang) >= 2;


--24. Hiển thị tên các dự án và số lượng chuyên gia tham gia cho mỗi dự án, chỉ hiển thị những dự án có hơn 3 chuyên gia tham gia.
SELECT da.TenDuAn, COUNT(cda.MaChuyenGia) AS SoLuongChuyenGia
FROM DuAn da
JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
GROUP BY da.TenDuAn
HAVING COUNT(cda.MaChuyenGia) > 3;

--25.Tìm công ty có số lượng dự án lớn nhất và hiển thị tên công ty cùng với số lượng dự án.
SELECT ct.TenCongTy, COUNT(da.MaDuAn) AS SoLuongDuAn
FROM CongTy ct
LEFT JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
GROUP BY ct.TenCongTy
HAVING COUNT(da.MaDuAn) >= ALL (
        SELECT COUNT(da2.MaDuAn)
        FROM DuAn da2
        GROUP BY da2.MaCongTy
    );

--26. Liệt kê tên các chuyên gia có kinh nghiệm từ 5 năm trở lên và có ít nhất 4 kỹ năng khác nhau.
SELECT cg.HoTen
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ckn ON cg.MaChuyenGia = ckn.MaChuyenGia
GROUP BY cg.HoTen, cg.NamKinhNghiem
HAVING cg.NamKinhNghiem >= 5 AND COUNT(ckn.MaKyNang) >= 4;

--27. Tìm tất cả các kỹ năng mà không có chuyên gia nào sở hữu.
SELECT kn.TenKyNang
FROM KyNang kn
LEFT JOIN ChuyenGia_KyNang ckn ON kn.MaKyNang = ckn.MaKyNang
WHERE ckn.MaChuyenGia IS NULL;

--28. Hiển thị tên chuyên gia và số năm kinh nghiệm của họ, sắp xếp theo số năm kinh nghiệm giảm dần.
SELECT cg.HoTen, cg.NamKinhNghiem
FROM ChuyenGia cg
ORDER BY cg.NamKinhNghiem DESC;

--29. Tìm tất cả các cặp chuyên gia có ít nhất 2 kỹ năng giống nhau.
SELECT cg1.HoTen AS ChuyenGia1, cg2.HoTen AS ChuyenGia2
FROM ChuyenGia cg1
JOIN ChuyenGia_KyNang ckn1 ON cg1.MaChuyenGia = ckn1.MaChuyenGia
JOIN ChuyenGia_KyNang ckn2 ON ckn1.MaKyNang = ckn2.MaKyNang AND cg1.MaChuyenGia < ckn2.MaChuyenGia
JOIN ChuyenGia cg2 ON ckn2.MaChuyenGia = cg2.MaChuyenGia
GROUP BY cg1.HoTen, cg2.HoTen
HAVING COUNT(ckn1.MaKyNang) >= 2;

--30. Tìm các công ty có ít nhất một chuyên gia nhưng không có dự án nào.
SELECT ct.TenCongTy
FROM CongTy ct
LEFT JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
WHERE da.MaDuAn IS NULL;

--31. Liệt kê tên các chuyên gia cùng với số lượng kỹ năng cấp độ cao nhất mà họ sở hữu.
SELECT cg.HoTen, MAX(ckn.CapDo) AS CapDoCaoNhat, COUNT(*) AS SoLuong
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ckn ON cg.MaChuyenGia = ckn.MaChuyenGia
WHERE ckn.CapDo = (SELECT MAX(CapDo) FROM ChuyenGia_KyNang WHERE MaChuyenGia = cg.MaChuyenGia)
GROUP BY cg.HoTen;

--32. Tìm dự án mà tất cả các chuyên gia đều tham gia và hiển thị tên dự án cùng với danh sách tên chuyên gia tham gia.
SELECT da.TenDuAn, cg.HoTen
FROM DuAn da
JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
JOIN ChuyenGia cg ON cda.MaChuyenGia = cg.MaChuyenGia
WHERE da.MaDuAn IN (
        SELECT da1.MaDuAn
        FROM DuAn da1
        JOIN ChuyenGia_DuAn cda1 ON da1.MaDuAn = cda1.MaDuAn
        GROUP BY da1.MaDuAn
        HAVING COUNT(DISTINCT cda1.MaChuyenGia) = (SELECT COUNT(*) FROM ChuyenGia)
    );

--33. Tìm tất cả các kỹ năng mà ít nhất một chuyên gia sở hữu nhưng không thuộc về nhóm kỹ năng 'Python' hoặc 'Java'.
SELECT kn.TenKyNang
FROM KyNang kn
JOIN ChuyenGia_KyNang ckn ON kn.MaKyNang = ckn.MaKyNang
WHERE kn.TenKyNang NOT IN ('Python', 'Java');

   
