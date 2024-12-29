-- 1. Tao database
CREATE DATABASE DETHI_03
GO

USE DETHI_03
GO

CREATE TABLE NHACUNGCAP (
    MANCC CHAR(5) PRIMARY KEY,
    TENNCC VARCHAR(50),
    QUOCGIA VARCHAR(30),
    LOAINCC VARCHAR(20)
);

CREATE TABLE DUOCPHAM (
    MADP CHAR(5) PRIMARY KEY,
    TENDP VARCHAR(50),
    LOAIDP VARCHAR(30),
    GIA INT
);

CREATE TABLE PHIEUNHAP (
    SOPN CHAR(5) PRIMARY KEY,
    NGNHAP SMALLDATETIME,
    MANCC CHAR(5),
    LOAINHAP VARCHAR(20),
    FOREIGN KEY (MANCC) REFERENCES NHACUNGCAP(MANCC)
);

CREATE TABLE CTPN (
    SOPN CHAR(5),
    MADP CHAR(5),
    SOLUONG INT,
    PRIMARY KEY (SOPN, MADP),
    FOREIGN KEY (SOPN) REFERENCES PHIEUNHAP(SOPN),
    FOREIGN KEY (MADP) REFERENCES DUOCPHAM(MADP)
);

-- 2. Nhap du lieu cho cac bang

-- Nhập dữ liệu cho bảng NHACUNGCAP
INSERT INTO NHACUNGCAP (MANCC, TENNCC, QUOCGIA, LOAINCC)
VALUES
('NCC01', 'Phuc Hung', 'Viet Nam', 'Thuong xuyen'),
('NCC02', 'J. B. Pharmaceuticals', 'India', 'Vang lai'),
('NCC03', 'Sapharco', 'Singapore', 'Vang lai');

-- Nhập dữ liệu cho bảng DUOCPHAM
INSERT INTO DUOCPHAM (MADP, TENDP, LOAIDP, GIA)
VALUES
('DP01', 'Thuoc ho PH Siro', 'Siro', 120000),
('DP02', 'Zecuf Herbal CouchRemedy', 'Vien nen', 200000),
('DP03', 'Cotrim', 'Vien sui', 80000);

-- Nhập dữ liệu cho bảng PHIEUNHAP
INSERT INTO PHIEUNHAP (SOPN, NGNHAP, MANCC, LOAINHAP)
VALUES
('00001', '2017-11-22', 'NCC01', 'Noi dia'),
('00002', '2017-12-04', 'NCC03', 'Nhap khau'),
('00003', '2017-12-10', 'NCC02', 'Nhap khau');

-- Nhập dữ liệu cho bảng CTPN
INSERT INTO CTPN (SOPN, MADP, SOLUONG)
VALUES
('00001', 'DP01', 100),
('00001', 'DP02', 200),
('00003', 'DP03', 543);

-- 3. Hiện thực ràng buộc toàn vẹn sau: Tất cả các dược phẩm có loại là Siro đều có giá lớn hơn 100.000đ (1đ). 
ALTER TABLE DUOCPHAM
ADD CONSTRAINT CK_Gia_Siro CHECK (NOT (LOAIDP = 'Siro' AND GIA <= 100000));

-- 4. Hiện thực ràng buộc toàn vẹn sau: Phiếu nhập của những nhà cung cấp ở những quốc gia 
-- khác Việt Nam đều có loại nhập là Nhập khẩu. (2đ). 
GO
CREATE TRIGGER TRG_CheckLoaiNhap
ON PHIEUNHAP
AFTER INSERT
AS
BEGIN
    DECLARE @QuocGia VARCHAR(30), @LoaiNhap VARCHAR(20);
    SELECT @QuocGia = NC.QUOCGIA, @LoaiNhap = PT.LOAINHAP
    FROM INSERTED PT
    JOIN NHACUNGCAP NC ON PT.MANCC = NC.MANCC;

    IF @QuocGia <> 'Viet Nam' AND @LoaiNhap <> 'Nhap khau'
    BEGIN
        ROLLBACK TRANSACTION;
		PRINT 'Phiếu nhập của nhà cung cấp ngoài Việt Nam phải có loại nhập là Nhập khẩu.';
    END
END;

-- 5. Tìm tất cả các phiếu nhập có ngày nhập trong tháng 12 năm 2017, sắp xếp kết quả tăng dần theo ngày nhập (1đ). 
SELECT * 
FROM PHIEUNHAP
WHERE NGNHAP BETWEEN '2017-12-01' AND '2017-12-31'
ORDER BY NGNHAP ASC;

-- 6. Tìm dược phẩm được nhập số lượng nhiều nhất trong năm 2017 (1đ). 
SELECT TOP 1 DP.TENDP, SUM(CTP.SOLUONG) AS TotalQuantity
FROM CTPN CTP
JOIN DUOCPHAM DP ON CTP.MADP = DP.MADP
JOIN PHIEUNHAP PN ON CTP.SOPN = PN.SOPN
WHERE YEAR(PN.NGNHAP) = 2017
GROUP BY DP.TENDP
ORDER BY TotalQuantity DESC;

-- 7. Tìm dược phẩm chỉ có nhà cung cấp thường xuyên (LOAINCC là Thuong xuyen) cung cấp, 
-- nhà cung cấp vãng lai (LOAINCC là Vang lai) không cung cấp. (1đ). 
SELECT DP.TENDP
FROM DUOCPHAM DP
JOIN CTPN CTP ON DP.MADP = CTP.MADP
JOIN PHIEUNHAP PN ON CTP.SOPN = PN.SOPN
JOIN NHACUNGCAP NC ON PN.MANCC = NC.MANCC
GROUP BY DP.TENDP
HAVING SUM(CASE WHEN NC.LOAINCC = 'Thuong xuyen' THEN 1 ELSE 0 END) > 0
       AND SUM(CASE WHEN NC.LOAINCC = 'Vang lai' THEN 1 ELSE 0 END) = 0;

-- 8. Tìm nhà cung cấp đã từng cung cấp tất cả những dược phẩm có giá trên 100.000đ trong năm 2017 (1đ).
SELECT NC.MANCC, NC.TENNCC
FROM NHACUNGCAP NC
JOIN PHIEUNHAP PN ON NC.MANCC = PN.MANCC
JOIN CTPN CTP ON PN.SOPN = CTP.SOPN
JOIN DUOCPHAM DP ON CTP.MADP = DP.MADP
WHERE DP.GIA > 100000 AND YEAR(PN.NGNHAP) = 2017
GROUP BY NC.MANCC, NC.TENNCC
HAVING COUNT(DISTINCT DP.MADP) = (SELECT COUNT(DISTINCT MADP) 
                                   FROM DUOCPHAM 
                                   WHERE GIA > 100000);
