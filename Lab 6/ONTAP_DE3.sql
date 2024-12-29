-- 1. Tao database
CREATE DATABASE ONTAP_DE3
GO

USE ONTAP_DE3
GO

CREATE TABLE DOCGIA (
    MaDG char(5) PRIMARY KEY,
    HoTen varchar(30),
    NgaySinh smalldatetime,
    DiaChi varchar(30),
    SoDT varchar(15)
);

CREATE TABLE SACH (
    MaSach char(5) PRIMARY KEY,
    TenSach varchar(25),
    TheLoai varchar(25),
    NhaXuatBan varchar(30)
);

CREATE TABLE PHIEUTHUE (
    MaPM char(5) PRIMARY KEY,
    MaDG char(5),
    NgayThue smalldatetime,
    NgayTra smalldatetime,
    SoSachMuon int,
    FOREIGN KEY (MaDG) REFERENCES DOCGIA(MaDG)
);

CREATE TABLE CHITIET_PM (
    MaPM char(5),
    MaSach char(5),
    PRIMARY KEY (MaPM, MaSach),
    FOREIGN KEY (MaPM) REFERENCES PHIEUTHUE(MaPM),
    FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)
);

-- 2. Hiện thực các ràng buộc toàn vẹn sau:  
-- 2.1. Thể loại băng đĩa chỉ thuộc các thể loại sau “ca nhạc”, “phim hành động”, “phim tình cảm”, “phim hoạt hình”.
GO
CREATE TRIGGER TRG_BANGDIA
ON PHIEUTHUE
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @NgayThue smalldatetime, @NgayTra smalldatetime;
    SELECT @NgayThue = NgayThue, @NgayTra = NgayTra
    FROM INSERTED;
    IF DATEDIFF(DAY, @NgayThue, @NgayTra) > 10
    BEGIN
        ROLLBACK TRANSACTION;
		PRINT 'Độc giả không được thuê sách quá 10 ngày.';
    END
END;

-- 2.2. Chỉ những khách hàng thuộc loại VIP mới được thuê với số lượng băng đĩa trên 5.
GO
 CREATE TRIGGER TRG_CHECKBD
ON CHITIET_PM
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @MaPM char(5), @SoSachMuon int;
    SELECT @MaPM = MaPM FROM INSERTED;
    SELECT @SoSachMuon = COUNT(*) 
    FROM CHITIET_PM
    WHERE MaPM = @MaPM;

    UPDATE PHIEUTHUE
    SET SoSachMuon = @SoSachMuon
    WHERE MaPM = @MaPM;
END;

-- 3. Viết các câu lệnh SQL thực hiện các câu truy vấn sau:  
-- 3.1. Tìm các khách hàng (MaDG,HoTen) đã thuê băng đĩa  thuộc thể loại phim “Tình cảm” có số lượng thuê lớn hơn 3.  
SELECT DISTINCT dg.MaDG, dg.HoTen
FROM DOCGIA dg
JOIN PHIEUTHUE pt ON dg.MaDG = pt.MaDG
JOIN CHITIET_PM ctp ON pt.MaPM = ctp.MaPM
JOIN SACH s ON ctp.MaSach = s.MaSach
WHERE s.TheLoai = 'Tin học' AND YEAR(pt.NgayThue) = 2007;

-- 3.2. Tìm các khách hàng(MaDG,HoTen) thuộc loại VIP đã thuê nhiều băng đĩa nhất.
SELECT dg.MaDG, dg.HoTen
FROM DOCGIA dg
JOIN PHIEUTHUE pt ON dg.MaDG = pt.MaDG
JOIN CHITIET_PM ctp ON pt.MaPM = ctp.MaPM
JOIN SACH s ON ctp.MaSach = s.MaSach
GROUP BY dg.MaDG, dg.HoTen
HAVING COUNT(DISTINCT s.TheLoai) = (
    SELECT MAX(BookCount)
    FROM (
        SELECT pt.MaDG, COUNT(DISTINCT s.TheLoai) AS BookCount
        FROM PHIEUTHUE pt
        JOIN CHITIET_PM ctp ON pt.MaPM = ctp.MaPM
        JOIN SACH s ON ctp.MaSach = s.MaSach
        GROUP BY pt.MaDG
    ) AS SubQuery
);



-- 3.3. Trong mỗi thể loại băng đĩa, cho biết tên khách hàng nào đã thuê nhiều băng đĩa nhất. 
SELECT s.TheLoai, s.TenSach
FROM SACH s
JOIN CHITIET_PM ctp ON s.MaSach = ctp.MaSach
JOIN PHIEUTHUE pt ON ctp.MaPM = pt.MaPM
GROUP BY s.TheLoai, s.TenSach
HAVING COUNT(*) = (
    SELECT MAX(BookCount)
    FROM (
        SELECT s.TheLoai, s.TenSach, COUNT(*) AS BookCount
        FROM SACH s
        JOIN CHITIET_PM ctp ON s.MaSach = ctp.MaSach
        JOIN PHIEUTHUE pt ON ctp.MaPM = pt.MaPM
        GROUP BY s.TheLoai, s.TenSach
    ) AS SubQuery
);

