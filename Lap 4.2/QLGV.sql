--1. Tìm danh sách các giáo viên có mức lương cao nhất trong mỗi khoa, kèm theo tên khoa và hệ số lương.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, KETQUATHI.DIEM
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE KETQUATHI.MAMH = 'CSDL' AND KETQUATHI.DIEM > 5;

--2. Liệt kê danh sách các học viên có điểm trung bình cao nhất trong mỗi lớp, kèm theo tên lớp và mã lớp.
SELECT MONHOC.TENMH
FROM MONHOC
JOIN DIEUKIEN ON MONHOC.MAMH = DIEUKIEN.MAMH_TRUOC
WHERE DIEUKIEN.MAMH = 'CSDL';

--3. Tính tổng số tiết lý thuyết (TCLT) và thực hành (TCTH) mà mỗi giáo viên đã giảng dạy trong 
--năm học 2023, sắp xếp theo tổng số tiết từ cao xuống thấp.
SELECT GIAOVIEN.HOTEN, GIAOVIEN.MAGV
FROM GIAOVIEN
JOIN GIANGDAY ON GIAOVIEN.MAGV = GIANGDAY.MAGV
JOIN MONHOC ON GIANGDAY.MAMH = MONHOC.MAMH
WHERE MONHOC.TENMH = 'THDC' AND GIANGDAY.NAM = 2006;

--4. Tìm những học viên thi cùng một môn học nhiều hơn 2 lần nhưng chưa bao giờ đạt điểm trên 7, kèm theo mã học viên và mã môn học.
SELECT LOP.TENLOP, LOP.SISO
FROM LOP
WHERE LOP.SISO >= 30;

--5. Xác định những giáo viên đã giảng dạy ít nhất 3 môn học khác nhau trong cùng một năm học,kèm theo năm học và số lượng môn giảng dạy.
SELECT MONHOC.TENMH, MONHOC.TCTH
FROM MONHOC
WHERE MONHOC.TCTH >= 3;

--6. Tìm những học viên có sinh nhật trùng với ngày thành lập của khoa mà họ đang theo học, kèmtheo tên khoa và ngày sinh của học viên.
SELECT GIAOVIEN.HOTEN, GIAOVIEN.MAGV, LOP.TENLOP
FROM GIAOVIEN
JOIN LOP ON GIAOVIEN.MAGV = LOP.MAGVCN;

--7. Liệt kê các môn học không có điều kiện tiên quyết (không yêu cầu môn học trước), kèm theo mã môn và tên môn học.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, KETQUATHI.DIEM
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE KETQUATHI.MAMH = 'CTRR' AND KETQUATHI.DIEM > 6;

--8. Tìm danh sách các giáo viên dạy nhiều môn học nhất trong học kỳ 1 năm 2006, kèm theo sốlượng môn học mà họ đã dạy.
SELECT TOP 1 GIAOVIEN.HOTEN, GIAOVIEN.MUCLUONG
FROM GIAOVIEN
WHERE GIAOVIEN.MAKHOA = 'KHMT'
ORDER BY GIAOVIEN.MUCLUONG DESC;

--9. Tìm những giáo viên đã dạy cả môn “Co So Du Lieu” và “Cau Truc Roi Rac” trong cùng mộthọc kỳ, kèm theo học kỳ và năm học.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN
WHERE HOCVIEN.MAHV NOT IN (SELECT DIEUKIEN.MAMH_TRUOC
                            FROM DIEUKIEN
                            WHERE DIEUKIEN.MAMH = 'CTDLGT');

--10. Liệt kê danh sách các môn học mà tất cả các giáo viên trong khoa “CNTT” đều đã giảng dạy ít nhất một lần trong năm 2006.
SELECT MONHOC.TENMH
FROM MONHOC
WHERE NOT EXISTS (
    SELECT 1
    FROM GIAOVIEN
    WHERE GIAOVIEN.MAKHOA = 'CNTT'
    AND GIAOVIEN.MAGV NOT IN (
        SELECT GIANGDAY.MAGV
        FROM GIANGDAY
        WHERE GIANGDAY.MAMH = MONHOC.MAMH
        AND GIANGDAY.NAM = 2006
    )
)
GROUP BY MONHOC.TENMH;

--11. Tìm những giáo viên có hệ số lương cao hơn mức lương trung bình của tất cả giáo viên trong
--khoa của họ, kèm theo tên khoa và hệ số lương của giáo viên đó.
SELECT GIAOVIEN.HOTEN, GIAOVIEN.HOCVI, GIAOVIEN.HESOLUONG, KHOA.TENKHOA
FROM GIAOVIEN
JOIN KHOA ON GIAOVIEN.MAKHOA = KHOA.MAKHOA
WHERE GIAOVIEN.HESOLUONG > (
    SELECT AVG(GIAOVIEN.HESOLUONG)
    FROM GIAOVIEN
    WHERE GIAOVIEN.MAKHOA = KHOA.MAKHOA
);

--12. Xác định những lớp có sĩ số lớn hơn 40 nhưng không có giáo viên nào dạy quá 2 môn trong học kỳ 1 năm 2006, kèm theo tên lớp và sĩ số.
SELECT LOP.TENLOP, LOP.SISO
FROM LOP
WHERE LOP.SISO > 40
AND NOT EXISTS (
    SELECT 1
    FROM GIANGDAY
    JOIN LOP ON GIANGDAY.MALOP = LOP.MALOP
    WHERE GIANGDAY.NAM = 2006 AND GIANGDAY.HOCKY = 1
    GROUP BY GIANGDAY.MAGV
    HAVING COUNT(DISTINCT GIANGDAY.MAMH) > 2
);

--13. Tìm những môn học mà tất cả các học viên của lớp “K11” đều đạt điểm trên 7 trong lần thi 
--cuối cùng của họ, kèm theo mã môn và tên môn học.
SELECT KETQUATHI.MAMH, MONHOC.TENMH
FROM KETQUATHI
JOIN MONHOC ON KETQUATHI.MAMH = MONHOC.MAMH
JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE HOCVIEN.TENLOP = 'K11'
GROUP BY KETQUATHI.MAMH, MONHOC.TENMH
HAVING MIN(KETQUATHI.DIEM) > 7;

--14. Liệt kê danh sách các giáo viên đã dạy ít nhất một môn học trong mỗi học kỳ của năm 2006,
--kèm theo mã giáo viên và số lượng học kỳ mà họ đã giảng dạy.
SELECT GIANGDAY.MAGV, COUNT(DISTINCT GIANGDAY.HOCKY) AS SO_HOCKY
FROM GIANGDAY
WHERE GIANGDAY.NAM = 2006
GROUP BY GIANGDAY.MAGV
HAVING COUNT(DISTINCT GIANGDAY.HOCKY) = 2; -- giả sử có 2 học kỳ trong năm

--15. Tìm những giáo viên vừa là trưởng khoa vừa giảng dạy ít nhất 2 môn khác nhau trong năm
--2006, kèm theo tên khoa và mã giáo viên.
SELECT GIAOVIEN.HOTEN, GIAOVIEN.MAGV, KHOA.TENKHOA
FROM GIAOVIEN
JOIN KHOA ON GIAOVIEN.MAKHOA = KHOA.MAKHOA
WHERE GIAOVIEN.VAITRO = 'Trưởng khoa'
AND EXISTS (
    SELECT 1
    FROM GIANGDAY
    WHERE GIANGDAY.MAGV = GIAOVIEN.MAGV
    AND GIANGDAY.NAM = 2006
    GROUP BY GIANGDAY.MAMH
    HAVING COUNT(DISTINCT GIANGDAY.MAMH) >= 2
);

--16. Xác định những môn học mà tất cả các lớp do giáo viên chủ nhiệm “Nguyen To Lan” đều phải
--học trong năm 2006, kèm theo mã lớp và tên lớp.
SELECT LOP.MALOP, LOP.TENLOP, MONHOC.TENMH
FROM LOP
JOIN GIAOVIEN ON LOP.MAGVCN = GIAOVIEN.MAGV
JOIN MONHOC ON MONHOC.MAMH = LOP.MAMH
WHERE GIAOVIEN.HOTEN = 'Nguyen To Lan'
AND LOP.NAM = 2006
GROUP BY LOP.MALOP, LOP.TENLOP, MONHOC.TENMH
HAVING COUNT(DISTINCT MONHOC.MAMH) = (SELECT COUNT(*) FROM MONHOC WHERE MONHOC.NAM = 2006);

--17. Liệt kê danh sách các môn học mà không có điều kiện tiên quyết (không cần phải học trước
--bất kỳ môn nào), nhưng lại là điều kiện tiên quyết cho ít nhất 2 môn khác nhau, kèm theo mã môn và tên môn học.
SELECT MONHOC.MAMH, MONHOC.TENMH
FROM MONHOC
WHERE MONHOC.MAMH NOT IN (SELECT DIEUKIEN.MAMH_TRUOC FROM DIEUKIEN)
AND MONHOC.MAMH IN (
    SELECT DIEUKIEN.MAMH
    FROM DIEUKIEN
    GROUP BY DIEUKIEN.MAMH
    HAVING COUNT(DISTINCT DIEUKIEN.MAMH_TRUOC) >= 2
);

--18. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng
--chưa thi lại môn này và cũng chưa thi bất kỳ môn nào khác sau lần đó.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE KETQUATHI.MAMH = 'CSDL'
AND KETQUATHI.LAN = 1
AND KETQUATHI.DIEM < 5
AND NOT EXISTS (
    SELECT 1
    FROM KETQUATHI AS KQ2
    WHERE KQ2.MAHV = HOCVIEN.MAHV
    AND (KQ2.MAMH = 'CSDL' AND KQ2.LAN > 1) OR KQ2.LAN > 1
);

--19. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào trong năm 2006, nhưng đã từng giảng dạy trước đó.
SELECT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS (
    SELECT 1
    FROM GIANGDAY
    WHERE GIANGDAY.MAGV = GIAOVIEN.MAGV
    AND GIANGDAY.NAM = 2006
)
AND EXISTS (
    SELECT 1
    FROM GIANGDAY
    WHERE GIANGDAY.MAGV = GIAOVIEN.MAGV
    AND GIANGDAY.NAM < 2006
);

--20. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào
--thuộc khoa giáo viên đó phụ trách trong năm 2006, nhưng đã từng giảng dạy các môn khác của khoa khác.
SELECT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS (
    SELECT 1
    FROM GIANGDAY
    JOIN MONHOC ON GIANGDAY.MAMH = MONHOC.MAMH
    WHERE GIANGDAY.MAGV = GIAOVIEN.MAGV
    AND MONHOC.MAKHOA = GIAOVIEN.MAKHOA
    AND GIANGDAY.NAM = 2006
)
AND EXISTS (
    SELECT 1
    FROM GIANGDAY
    JOIN MONHOC ON GIANGDAY.MAMH = MONHOC.MAMH
    WHERE GIANGDAY.MAGV = GIAOVIEN.MAGV
    AND MONHOC.MAKHOA != GIAOVIEN.MAKHOA
);

--21. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn "Khong dat", nhưng có điểm trung bình tất cả các môn khác trên 7.
SELECT HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE HOCVIEN.TENLOP = 'K11'
AND KETQUATHI.LAN > 3
AND KETQUATHI.DIEM < 5
AND NOT EXISTS (
    SELECT 1
    FROM KETQUATHI AS KQ2
    WHERE KQ2.MAHV = HOCVIEN.MAHV
    AND KQ2.DIEM <= 7
    AND KQ2.MAMH != KETQUATHI.MAMH
);

--22. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn "Khong dat" và thi
--lần thứ 2 của môn CTRR đạt đúng 5 điểm, nhưng điểm trung bình của tất cả các môn khác đều dưới 6.
SELECT HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE HOCVIEN.TENLOP = 'K11'
AND KETQUATHI.LAN > 3
AND KETQUATHI.DIEM < 5
AND EXISTS (
    SELECT 1
    FROM KETQUATHI AS KQ2
    WHERE KQ2.MAHV = HOCVIEN.MAHV
    AND KQ2.LAN = 2
    AND KQ2.MAMH = 'CTRR'
    AND KQ2.DIEM = 5
)
AND NOT EXISTS (
    SELECT 1
    FROM KETQUATHI AS KQ3
    WHERE KQ3.MAHV = HOCVIEN.MAHV
    AND KQ3.DIEM >= 6
    AND KQ3.MAMH != 'CTRR'
);

--23. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học và có tổng số tiết giảng dạy (TCLT + TCTH) lớn hơn 30 tiết.
SELECT GIAOVIEN.HOTEN
FROM GIAOVIEN
JOIN GIANGDAY ON GIAOVIEN.MAGV = GIANGDAY.MAGV
JOIN MONHOC ON GIANGDAY.MAMH = MONHOC.MAMH
WHERE MONHOC.TENMH = 'CTRR'
AND GIANGDAY.NAM = 2006
AND GIANGDAY.HOCKY = 1
GROUP BY GIAOVIEN.HOTEN
HAVING COUNT(DISTINCT GIANGDAY.MALOP) >= 2
AND SUM(GIANGDAY.TCLT + GIANGDAY.TCTH) > 30;

--24. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng), kèm theo số lần thi của mỗi học viên cho môn này.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, MAX(KETQUATHI.DIEM) AS DIEM_CSDL, COUNT(KETQUATHI.LAN) AS SO_LAN_THI
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE KETQUATHI.MAMH = 'CSDL'
GROUP BY HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN;

--25. Danh sách học viên và điểm trung bình tất cả các môn (chỉ lấy điểm của lần thi sau cùng), 
--kèm theo số lần thi trung bình cho tất cả các môn mà mỗi học viên đã tham gia
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, AVG(KETQUATHI.DIEM) AS DIEM_TRUNG_BINH, AVG(KETQUATHI.LAN) AS SO_LAN_THI_TB
FROM HOCVIEN
JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
GROUP BY HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN;
