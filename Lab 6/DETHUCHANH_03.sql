-- 1. Tao database BAITHI

CREATE DATABASE BAITHI
GO

USE BAITHI
GO

CREATE TABLE NHACUNGCAP (
	MANCC char(5) PRIMARY KEY,
	TENNCC nvarchar(50),
	QUOCGIA nvarchar(50),
	LOAINCC nvarchar(50)
);

CREATE TABLE DUOCPHAM (
	MADP char(5) PRIMARY KEY,
	TENDP nvarchar(50),
	LOAIDP nvarchar(20),
	GIA int
);

CREATE TABLE PHIEUNHAP (
	SOPN char(5) PRIMARY KEY,
	NGNHAP date,
	MANCC char(5),
	LOAINHAP nvarchar(20),
	CONSTRAINT FK_PHIEUNHAP_NCC FOREIGN KEY (MANCC) REFERENCES NHACUNGCAP(MANCC)
);

CREATE TABLE CTPN (
	SOPN char(5),
	MADP char(5),
	SOLUONG int,
	PRIMARY KEY (SOPN, MADP),
	CONSTRAINT FK_CTPN_PHIEUNHAP FOREIGN KEY (SOPN) REFERENCES PHIEUNHAP (SOPN),
	CONSTRAINT FK_CTPN_DUOCPHAM FOREIGN KEY (MADP) REFERENCES DUOCPHAM (MADP)
);

-- 2. Nhap du lieu
INSERT INTO NHACUNGCAP VALUES
('NCC01', N'Phuc Hung', N'Viet Nam', N'Thuong xuyen'),
('NCC02', N'J. B. Pharmaceuticals', N'India', N'Vang lai'),
('NCC03', N'Sapharco', N'Singapore', N'ang lai');

INSERT INTO DUOCPHAM VALUES
('DP01', N'Thuoc ho PH', N'Siro', 120000),
('DP02', N'Zecuf Herbal CouchRemedy', N'Vien nen', 200000),
('DP03', N'Cotrim', N'Vien sui', 80000);

INSERT INTO PHIEUNHAP VALUES
('00001', '2017-11-22', 'NCC01', N'Noi dia'),
('00002', '2017-12-04', 'NCC03', N'Nhap khau'),
('00003', '2017-12-10', 'NCC02', N'Nhap khau');

INSERT INTO CTPN VALUES
('00001', 'DP01', 100),
('00001', 'DP02', 200),
('00003', 'DP03', 543);

-- 3. Hiện thực ràng buộc toàn vẹn sau: Tất cả các dược phẩm có loại là Siro đều có giá lớn hơn 100.000đ
ALTER TABLE DUOCPHAM
ADD CONSTRAINT CHK_LOAIDP_GIA CHECK (LOAIDP != 'Siro' OR GIA > 100000)

-- 4. Hiện thực ràng buộc toàn vẹn sau: Phiếu nhập của những nhà cung cấp ở những quốc gia 
-- khác Việt Nam đều có loại nhập là Nhập khẩu.
GO
CREATE TRIGGER TRG_PHIEUNHAP
ON PHIEUNHAP
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE PHIEUNHAP
    SET LOAINHAP = N'Nhap khau'
    FROM PHIEUNHAP PN
    JOIN inserted i ON PN.SOPN = i.SOPN
    JOIN NHACUNGCAP ncc ON PN.MANCC = ncc.MANCC
    WHERE ncc.QUOCGIA != N'Viet Nam' AND i.LOAINHAP != N'Nhap khau';
END;

-- 5. Tìm tất cả các phiếu nhập có ngày nhập trong tháng 12 năm 2017, sắp xếp kết quả tăng dần theo ngày nhập 
SELECT *
FROM PHIEUNHAP
WHERE MONTH(NGNHAP) = 12 AND YEAR(NGNHAP) = 2017
ORDER BY NGNHAP ASC;

-- 6. Tìm dược phẩm được nhập số lượng nhiều nhất trong năm 2017 
SELECT TOP 1 CTPN.MADP, DUOCPHAM.TENDP, SUM(CTPN.SOLUONG) AS TONGSL
FROM CTPN
JOIN PHIEUNHAP ON CTPN.SOPN = PHIEUNHAP.SOPN
JOIN DUOCPHAM ON CTPN.MADP = DUOCPHAM.MADP
WHERE YEAR(PHIEUNHAP.NGNHAP) = 2017
GROUP BY CTPN.MADP, DUOCPHAM.TENDP
ORDER BY TONGSL DESC;

-- 7. Tìm dược phẩm chỉ có nhà cung cấp thường xuyên (LOAINCC là Thuong xuyen) cung cấp, 
--nhà cung cấp vãng lai (LOAINCC là Vang lai) không cung cấp. 
SELECT DISTINCT DUOCPHAM.*
FROM DUOCPHAM
WHERE NOT EXISTS (
    SELECT 1
    FROM PHIEUNHAP
    JOIN CTPN ON PHIEUNHAP.SOPN = CTPN.SOPN
    WHERE CTPN.MADP = DUOCPHAM.MADP
    AND PHIEUNHAP.MANCC IN (
        SELECT MANCC FROM NHACUNGCAP WHERE LOAINCC = N'Vang lai'
    )
);

-- 8. Tìm nhà cung cấp đã từng cung cấp tất cả những dược phẩm có giá trên 100.000đ trong năm 2017
SELECT NHACUNGCAP.*
FROM NHACUNGCAP
WHERE NOT EXISTS (
    SELECT 1
    FROM DUOCPHAM
    WHERE GIA > 100000
    AND NOT EXISTS (
        SELECT 1
        FROM PHIEUNHAP
        JOIN CTPN ON PHIEUNHAP.SOPN = CTPN.SOPN
        WHERE PHIEUNHAP.MANCC = NHACUNGCAP.MANCC
        AND CTPN.MADP = DUOCPHAM.MADP
        AND YEAR(PHIEUNHAP.NGNHAP) = 2017
    )
);
