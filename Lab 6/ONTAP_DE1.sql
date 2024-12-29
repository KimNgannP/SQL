-- 1. Tao Database
CREATE DATABASE ONTAP
GO

USE ONTAP
GO

CREATE TABLE TACGIA (
    MaTG CHAR(5) PRIMARY KEY, 
    HoTen VARCHAR(20), 
    DiaChi VARCHAR(50), 
    NgSinh SMALLDATETIME, 
    SoDT VARCHAR(15)
);

CREATE TABLE SACH (
    MaSach CHAR(5) PRIMARY KEY, 
    TenSach VARCHAR(25), 
    TheLoai VARCHAR(25)
);

CREATE TABLE TACGIA_SACH (
    MaTG CHAR(5), 
    MaSach CHAR(5), 
    PRIMARY KEY (MaTG, MaSach),
    FOREIGN KEY (MaTG) REFERENCES TACGIA(MaTG),
    FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)
);

CREATE TABLE PHATHANH (
    MaPH CHAR(5) PRIMARY KEY, 
    MaSach CHAR(5), 
    NgayPH SMALLDATETIME, 
    SoLuong INT, 
    NhaXuatBan VARCHAR(20),
    FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)
);

-- 2. Hiện thực các ràng buộc toàn vẹn sau:  
-- 2.1 Ngày phát hành sách phải lớn hơn ngày sinh của tác giả.
GO
CREATE PROCEDURE sp_InsertPhatHanh
    @MaPH CHAR(5),
    @MaSach CHAR(5),
    @NgayPH SMALLDATETIME,
    @SoLuong INT,
    @NhaXuatBan VARCHAR(20)
AS
BEGIN
    DECLARE @MaTG CHAR(5), @NgSinh SMALLDATETIME;
    SELECT @MaTG = MaTG
    FROM TACGIA_SACH
    WHERE MaSach = @MaSach;

    SELECT @NgSinh = NgSinh
    FROM TACGIA
    WHERE MaTG = @MaTG;

    IF @NgayPH <= @NgSinh
    BEGIN
        PRINT 'Ngày phát hành sách phải lớn hơn ngày sinh của tác giả.';
        RETURN;
    END
    INSERT INTO PHATHANH (MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
    VALUES (@MaPH, @MaSach, @NgayPH, @SoLuong, @NhaXuatBan);
END;

-- 2.2 Sách thuộc thể loại “Giáo khoa” chỉ do nhà xuất bản “Giáo dục” phát hành.
GO
CREATE TRIGGER TRG_CheckNgayPhatHanh
ON PHATHANH
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaSach CHAR(5), @MaTG CHAR(5), @NgayPH SMALldatetime, @NgSinh SMALldatetime;
    SELECT @MaSach = MaSach, @NgayPH = NgayPH
    FROM INSERTED;
    SELECT @MaTG = MaTG
    FROM TACGIA_SACH
    WHERE MaSach = @MaSach;

    SELECT @NgSinh = NgSinh
    FROM TACGIA
    WHERE MaTG = @MaTG;

    IF @NgayPH <= @NgSinh
    BEGIN
        PRINT 'Ngày phát hành sách phải lớn hơn ngày sinh của tác giả.';
    END
END;

-- 3. Viết các câu lệnh SQL thực hiện các câu truy vấn sau:  
-- 3.1. Tìm tác giả (MaTG,HoTen,SoDT) của những quyển sách thuộc thể loại “Văn học” do nhà xuất bản Trẻ phát hành.
SELECT DISTINCT tg.MaTG, tg.HoTen, tg.SoDT
FROM TACGIA tg
JOIN TACGIA_SACH tgs ON tg.MaTG = tgs.MaTG
JOIN SACH s ON tgs.MaSach = s.MaSach
JOIN PHATHANH ph ON s.MaSach = ph.MaSach
WHERE s.TheLoai = N'Văn học' AND ph.NhaXuatBan = N'Trẻ';

-- 3.2. Tìm nhà xuất bản phát hành nhiều thể loại sách nhất.
SELECT TOP 1 NhaXuatBan
FROM PHATHANH
GROUP BY NhaXuatBan
ORDER BY COUNT(DISTINCT MaSach) DESC;

-- 3.3. Trong mỗi nhà xuất bản, tìm tác giả (MaTG,HoTen) có số lần phát hành nhiều sách nhất.
SELECT ph.NhaXuatBan, tg.MaTG, tg.HoTen, COUNT(ph.MaSach) AS SoLanPhatHanh
FROM PHATHANH ph
JOIN SACH s ON ph.MaSach = s.MaSach
JOIN TACGIA_SACH tgs ON s.MaSach = tgs.MaSach
JOIN TACGIA tg ON tgs.MaTG = tg.MaTG
GROUP BY ph.NhaXuatBan, tg.MaTG, tg.HoTen
HAVING COUNT(ph.MaSach) = (
    SELECT MAX(SoLanPhatHanh)
    FROM (
        SELECT COUNT(ph.MaSach) AS SoLanPhatHanh
        FROM PHATHANH ph
        JOIN SACH s ON ph.MaSach = s.MaSach
        JOIN TACGIA_SACH tgs ON s.MaSach = tgs.MaSach
        JOIN TACGIA tg ON tgs.MaTG = tg.MaTG
        WHERE ph.NhaXuatBan = ph.NhaXuatBan
        GROUP BY tg.MaTG
    ) AS SubQuery
);
