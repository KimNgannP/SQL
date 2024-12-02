--15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
CREATE TRIGGER CAU15_UPDATE_HOCVIEN
ON KETQUATHI
FOR UPDATE
AS
BEGIN
    DECLARE @MAHV VARCHAR(10), @MAMH VARCHAR(10), @DIEM FLOAT, @LAN INT;
    SELECT @MAHV = MAHV, @MAMH = MAMH, @DIEM = DIEM, @LAN = LAN FROM inserted;
    IF (@LAN > 3 AND @DIEM < 5) OR 
       (@MAMH = 'CTRR' AND @LAN = 2 AND @DIEM = 5)
    BEGIN
        PRINT N'Học viên thi quá 3 lần không đạt hoặc thi lần 2 môn CTRR được 5 điểm';
        ROLLBACK TRAN;
    END
    ELSE
    BEGIN
        PRINT N'Cập nhật điểm thi thành công';
    END
END;

--16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
CREATE TRIGGER CAU16_UPDATE_GIAOVIEN
ON GIANGDAY
FOR UPDATE
AS
BEGIN
    DECLARE @MAGV VARCHAR(10), @MAMH VARCHAR(10), @HOCKY INT, @NAM INT;
    SELECT @MAGV = MAGV, @MAMH = MAMH, @HOCKY = HOCKY, @NAM = NAM FROM inserted;
    IF (@MAMH = 'CTRR')
    BEGIN
        IF (EXISTS (
            SELECT 1
            FROM GIANGDAY
            WHERE MAGV = @MAGV
              AND MAMH = 'CTRR'
              AND HOCKY = @HOCKY
              AND NAM = @NAM
            GROUP BY HOCKY, NAM
            HAVING COUNT(DISTINCT MALOP) >= 2
        ))
        BEGIN
            PRINT N'Giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ';
        END
        ELSE
        BEGIN
            PRINT N'Giáo viên không dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ';
            ROLLBACK TRAN;
        END
    END
END;

--17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
CREATE TRIGGER CAU17_UPDATE_CSDL
ON KETQUATHI
FOR UPDATE
AS
BEGIN
    DECLARE @MAHV VARCHAR(10), @MAMH VARCHAR(10), @DIEM FLOAT;
    SELECT @MAHV = MAHV, @MAMH = MAMH, @DIEM = DIEM FROM inserted;
    IF (@MAMH = 'CSDL')
    BEGIN
        UPDATE KETQUATHI
        SET DIEM = @DIEM
        WHERE MAHV = @MAHV AND MAMH = 'CSDL' AND LAN = (SELECT MAX(LAN) FROM KETQUATHI WHERE MAHV = @MAHV AND MAMH = 'CSDL');
    END
    PRINT N'Cập nhật điểm thi môn CSDL thành công';
END;

--18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
CREATE TRIGGER CAU18_UPDATE_CSDL
ON KETQUATHI
FOR UPDATE
AS
BEGIN
    DECLARE @MAHV VARCHAR(10), @MAMH VARCHAR(10), @DIEM FLOAT;
    SELECT @MAHV = MAHV, @MAMH = MAMH, @DIEM = DIEM FROM inserted;
    IF (@MAMH = 'Co So Du Lieu')
    BEGIN
        UPDATE KETQUATHI
        SET DIEM = (SELECT MAX(DIEM) FROM KETQUATHI WHERE MAHV = @MAHV AND MAMH = 'Co So Du Lieu')
        WHERE MAHV = @MAHV AND MAMH = 'Co So Du Lieu';
    END
    PRINT N'Cập nhật điểm thi môn Co So Du Lieu thành công';
END;

--19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
CREATE TRIGGER TRG_Khoa_ThanhLap_Som_Nhat
ON Khoa
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @NgayThanhLap DATETIME;
    SELECT @NgayThanhLap = MIN(NgayThanhLap) FROM Khoa;
    
    PRINT 'Khoa được thành lập sớm nhất là: ';
    SELECT MãKhoa, TênKhoa FROM Khoa WHERE NgayThanhLap = @NgayThanhLap;
END;

--20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
CREATE TRIGGER TRG_Khoa_ThanhLap_Som_Nhat
ON Khoa
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @NgayThanhLap DATETIME;
    SELECT @NgayThanhLap = MIN(NgayThanhLap) FROM Khoa;
    
    PRINT 'Khoa được thành lập sớm nhất là: ';
    SELECT MãKhoa, TênKhoa FROM Khoa WHERE NgayThanhLap = @NgayThanhLap;
END;

--21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
CREATE TRIGGER TRG_GV_HocVi
ON GiangVien
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MãKhoa VARCHAR(10);
    SELECT @MãKhoa = MãKhoa FROM inserted;
    
    PRINT 'Số lượng giáo viên trong khoa ' + @MãKhoa + ' có học vị CN, KS, Ths, TS, PTS là: ';
    SELECT Khoa.MãKhoa, Khoa.TênKhoa, COUNT(*) AS SoLuongGV
    FROM GiangVien
    INNER JOIN Khoa ON GiangVien.MãKhoa = Khoa.MãKhoa
    WHERE GiangVien.HocVi IN ('CN', 'KS', 'Ths', 'TS', 'PTS')
    GROUP BY Khoa.MãKhoa, Khoa.TênKhoa;
END;

--22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
CREATE TRIGGER TRG_ThongKe_HocVien_KetQua
ON KetQuaThi
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MãMH VARCHAR(10);
    SELECT @MãMH = MãMH FROM inserted;
    
    PRINT 'Số lượng học viên đạt và không đạt môn ' + @MãMH + ' là:';
    SELECT MãMH, 
           SUM(CASE WHEN KetQua = 'Dat' THEN 1 ELSE 0 END) AS SoLuongDat,
           SUM(CASE WHEN KetQua = 'Khong Dat' THEN 1 ELSE 0 END) AS SoLuongKhongDat
    FROM KetQuaThi
    WHERE MãMH = @MãMH
    GROUP BY MãMH;
END;

--23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cholớp đó ít nhất một môn học.
CREATE TRIGGER TRG_GV_CoChucVu_CoMonHoc
ON LopHoc
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MãGV VARCHAR(10), @MãLop VARCHAR(10);
    SELECT @MãGV = MãGV, @MãLop = MãLop FROM inserted;
    
    PRINT 'Giáo viên chủ nhiệm và dạy ít nhất một môn trong lớp ' + @MãLop + ' là: ';
    SELECT GV.MãGV, GV.HoTen
    FROM GiangVien GV
    INNER JOIN GiangVien_LopHoc GLH ON GV.MãGV = GLH.MãGV
    WHERE GLH.MãLop = @MãLop;
END;

--24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
CREATE TRIGGER TRG_LopTruong_SiSoCaoNhat
ON LopHoc
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @SiSoMax INT;
    SELECT @SiSoMax = MAX(SiSo) FROM LopHoc;
    
    PRINT 'Lớp có sĩ số cao nhất là:';
    SELECT L.MãLop, L.TênLop, L.SiSo, LV.HoTen AS LopTruong
    FROM LopHoc L
    JOIN LopTruong LT ON L.MãLop = LT.MãLop
    JOIN GiangVien LV ON LT.MãGV = LV.MãGV
    WHERE L.SiSo = @SiSoMax;
END;
