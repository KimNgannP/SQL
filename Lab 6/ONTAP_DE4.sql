-- 1. Tao database
CREATE DATABASE ONTAP_DE4
GO

USE ONTAP_DE4
GO

CREATE TABLE KHACHHANG (
    MaKH CHAR(5) PRIMARY KEY,
    HoTen VARCHAR(30),
    DiaChi VARCHAR(30),
    SoDT VARCHAR(15),
    LoaiKH VARCHAR(10)
);

CREATE TABLE BANG_DIA (
    MaBD CHAR(5) PRIMARY KEY,
    TenBD VARCHAR(25),
    TheLoai VARCHAR(25)
);

CREATE TABLE PHIEUTHUE (
    MaPM CHAR(5) PRIMARY KEY,
    MaKH CHAR(5),
    NgayThue SMALLDATETIME,
    NgayTra SMALLDATETIME,
    Soluongmuon INT,
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH)
);

CREATE TABLE CHITIET_PM (
    MaPM CHAR(5),
    MaBD CHAR(5),
    PRIMARY KEY (MaPM, MaBD),
    FOREIGN KEY (MaPM) REFERENCES PHIEUTHUE(MaPM),
    FOREIGN KEY (MaBD) REFERENCES BANG_DIA(MaBD)
);

-- 2. Hiện thực các ràng buộc toàn vẹn sau:  
-- 2.1. Thể loại băng đĩa chỉ thuộc các thể loại sau “ca nhạc”, “phim hành động”, “phim tình cảm”, “phim hoạt hình”. 
ALTER TABLE BANG_DIA
ADD CONSTRAINT CK_TheLoai CHECK (TheLoai IN ('ca nhạc', 'phim hành động', 'phim tình cảm', 'phim hoạt hình'));

-- 2.2. Chỉ những khách hàng thuộc loại VIP mới được thuê với số lượng băng đĩa trên 5. 
GO
CREATE TRIGGER TRG_CheckVIP
ON PHIEUTHUE
AFTER INSERT
AS
BEGIN
    DECLARE @LoaiKH VARCHAR(10), @Soluongmuon INT;
    SELECT @LoaiKH = KH.LoaiKH, @Soluongmuon = PT.Soluongmuon
    FROM INSERTED PT
    JOIN KHACHHANG KH ON PT.MaKH = KH.MaKH;
 
    IF @LoaiKH <> 'VIP' AND @Soluongmuon > 5
    BEGIN
        ROLLBACK TRANSACTION;
		PRINT 'Chỉ những khách hàng VIP mới được thuê trên 5 băng đĩa.';
    END
END;

-- 3. Viết các câu lệnh SQL thực hiện các câu truy vấn sau:  
-- 3.1. Tìm các khách hàng (MaDG,HoTen) đã thuê băng đĩa  thuộc thể loại phim “Tình cảm” có số lượng thuê lớn hơn 3. 
SELECT DISTINCT KH.MaKH, KH.HoTen
FROM KHACHHANG KH
JOIN PHIEUTHUE PT ON KH.MaKH = PT.MaKH
JOIN CHITIET_PM CTPM ON PT.MaPM = CTPM.MaPM
JOIN BANG_DIA BD ON CTPM.MaBD = BD.MaBD
WHERE BD.TheLoai = 'phim tình cảm' AND PT.Soluongmuon > 3;

-- 3.2. Tìm các khách hàng(MaDG,HoTen) thuộc loại VIP đã thuê nhiều băng đĩa nhất. 
SELECT KH.MaKH, KH.HoTen
FROM KHACHHANG KH
JOIN PHIEUTHUE PT ON KH.MaKH = PT.MaKH
JOIN CHITIET_PM CTPM ON PT.MaPM = CTPM.MaPM
JOIN BANG_DIA BD ON CTPM.MaBD = BD.MaBD
WHERE KH.LoaiKH = 'VIP'
GROUP BY KH.MaKH, KH.HoTen
HAVING COUNT(CTPM.MaBD) = (
    SELECT MAX(BookCount)
    FROM (
        SELECT PT.MaKH, COUNT(CTPM.MaBD) AS BookCount
        FROM PHIEUTHUE PT
        JOIN CHITIET_PM CTPM ON PT.MaPM = CTPM.MaPM
        GROUP BY PT.MaKH
    ) AS SubQuery
);

-- 3.3. Trong mỗi thể loại băng đĩa, cho biết tên khách hàng nào đã thuê nhiều băng đĩa nhất. 
SELECT BD.TheLoai, KH.MaKH, KH.HoTen
FROM BANG_DIA BD
JOIN CHITIET_PM CTPM ON BD.MaBD = CTPM.MaBD
JOIN PHIEUTHUE PT ON CTPM.MaPM = PT.MaPM
JOIN KHACHHANG KH ON PT.MaKH = KH.MaKH
GROUP BY BD.TheLoai, KH.MaKH, KH.HoTen
HAVING COUNT(CTPM.MaBD) = (
    SELECT MAX(BookCount)
    FROM (
        SELECT BD.TheLoai, PT.MaKH, COUNT(CTPM.MaBD) AS BookCount
        FROM BANG_DIA BD
        JOIN CHITIET_PM CTPM ON BD.MaBD = CTPM.MaBD
        JOIN PHIEUTHUE PT ON CTPM.MaPM = PT.MaPM
        GROUP BY BD.TheLoai, PT.MaKH
    ) AS SubQuery
);

