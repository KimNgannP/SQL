-- 1. Tao database
CREATE DATABASE ONTAP_DE2
GO

USE ONTAP_DE2
GO

CREATE TABLE PHONGBAN (
    MaPhong CHAR(5) PRIMARY KEY, 
    TenPhong VARCHAR(25),
    TruongPhong CHAR(5)
);

CREATE TABLE NHANVIEN (
    MaNV CHAR(5) PRIMARY KEY,
    HoTen VARCHAR(20),
    NgayVL SMALldatetime,
    HSLuong NUMERIC(4, 2),
    MaPhong CHAR(5),
    FOREIGN KEY (MaPhong) REFERENCES PHONGBAN(MaPhong)
);

CREATE TABLE XE (
    MaXe CHAR(5) PRIMARY KEY,
    LoaiXe VARCHAR(20),
    SoChoNgoi INT,
    NamSX INT
);

CREATE TABLE PHANCONG (
    MaPC CHAR(5) PRIMARY KEY,
    MaNV CHAR(5),
    MaXe CHAR(5),
    NgayDi SMALldatetime,
    NgayVe SMALldatetime,
    NoiDen VARCHAR(25),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
    FOREIGN KEY (MaXe) REFERENCES XE(MaXe)
);

-- 2. Hiện thực các ràng buộc toàn vẹn sau:  
-- 2.1. Năm sản xuất của xe loại Toyota phải từ năm 2006 trở về sau.   
ALTER TABLE XE
ADD CONSTRAINT CHK_NamSX_Toyota CHECK (
    (LoaiXe = 'Toyota' AND NamSX >= 2006) OR LoaiXe != 'Toyota'
);

-- 2.2. Nhân viên thuộc phòng lái xe “Ngoại thành” chỉ được phân công lái xe loại Toyota. 
GO
CREATE TRIGGER TRG_CHK_NGOAITHANH
ON PHANCONG
AFTER INSERT
AS
BEGIN
    DECLARE @MaNV char(5), @MaPhong char(5), @MaXe char(5), @LoaiXe varchar(20);

    SELECT @MaNV = MaNV, @MaXe = MaXe
    FROM INSERTED;

    SELECT @MaPhong = MaPhong
    FROM NHANVIEN
    WHERE MaNV = @MaNV;
  
    SELECT @LoaiXe = LoaiXe
    FROM XE
    WHERE MaXe = @MaXe;
    IF @MaPhong = 'Ngoai thanh' AND @LoaiXe != 'Toyota'
    BEGIN
	ROLLBACK TRANSACTION;
        PRINT 'Nhân viên thuộc phòng "Ngoại thành" chỉ được phân công lái xe loại Toyota.';
    END
END;


-- 3. Viết các câu lệnh SQL thực hiện các câu truy vấn sau:  
-- 3.1. Tìm nhân viên (MaNV,HoTen) thuộc phòng lái xe “Nội thành” được phân công lái loại xe Toyota có số chỗ ngồi là 4. 
SELECT DISTINCT nv.MaNV, nv.HoTen
FROM NHANVIEN nv
JOIN PHANCONG pc ON nv.MaNV = pc.MaNV
JOIN XE x ON pc.MaXe = x.MaXe
WHERE nv.MaPhong = 'Nội thành'
AND x.LoaiXe = 'Toyota'
AND x.SoChoNgoi = 4;

-- 3.2. Tìm nhân viên(MANV,HoTen) là trưởng phòng được phân công lái tất cả các loại xe. 
SELECT nv.MaNV, nv.HoTen
FROM NHANVIEN nv
JOIN PHONGBAN pb ON nv.MaPhong = pb.MaPhong
JOIN PHANCONG pc ON nv.MaNV = pc.MaNV
WHERE pb.TruongPhong = nv.MaNV
GROUP BY nv.MaNV, nv.HoTen
HAVING COUNT(DISTINCT pc.MaXe) = (SELECT COUNT(*) FROM XE);

-- 3.3. Trong mỗi phòng ban,tìm nhân viên (MaNV,HoTen) được phân công lái ít nhất loại xe Toyota. 
SELECT nv.MaNV, nv.HoTen, nv.MaPhong
FROM NHANVIEN nv
JOIN PHANCONG pc ON nv.MaNV = pc.MaNV
JOIN XE x ON pc.MaXe = x.MaXe
WHERE x.LoaiXe = 'Toyota'
GROUP BY nv.MaNV, nv.HoTen, nv.MaPhong;

