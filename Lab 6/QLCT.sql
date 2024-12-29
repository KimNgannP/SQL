CREATE DATABASE QLCT_lab6
GO

USE QLCT_lab6
GO

-- Tạo bảng Chuyên gia
CREATE TABLE ChuyenGia (
    MaChuyenGia INT PRIMARY KEY,
    HoTen NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    Email NVARCHAR(100),
    SoDienThoai NVARCHAR(20),
    ChuyenNganh NVARCHAR(50),
    NamKinhNghiem INT
);

-- Tạo bảng Công ty
CREATE TABLE CongTy (
    MaCongTy INT PRIMARY KEY,
    TenCongTy NVARCHAR(100),
    DiaChi NVARCHAR(200),
    LinhVuc NVARCHAR(50),
    SoNhanVien INT
);

-- Tạo bảng Dự án
CREATE TABLE DuAn (
    MaDuAn INT PRIMARY KEY,
    TenDuAn NVARCHAR(200),
    MaCongTy INT,
    NgayBatDau DATE,
    NgayKetThuc DATE,
    TrangThai NVARCHAR(50),
    FOREIGN KEY (MaCongTy) REFERENCES CongTy(MaCongTy)
);

-- Tạo bảng Kỹ năng
CREATE TABLE KyNang (
    MaKyNang INT PRIMARY KEY,
    TenKyNang NVARCHAR(100),
    LoaiKyNang NVARCHAR(50)
);

-- Tạo bảng Chuyên gia - Kỹ năng
CREATE TABLE ChuyenGia_KyNang (
    MaChuyenGia INT,
    MaKyNang INT,
    CapDo INT,
    PRIMARY KEY (MaChuyenGia, MaKyNang),
    FOREIGN KEY (MaChuyenGia) REFERENCES ChuyenGia(MaChuyenGia),
    FOREIGN KEY (MaKyNang) REFERENCES KyNang(MaKyNang)
);

-- Tạo bảng Chuyên gia - Dự án
CREATE TABLE ChuyenGia_DuAn (
    MaChuyenGia INT,
    MaDuAn INT,
    VaiTro NVARCHAR(50),
    NgayThamGia DATE,
    PRIMARY KEY (MaChuyenGia, MaDuAn),
    FOREIGN KEY (MaChuyenGia) REFERENCES ChuyenGia(MaChuyenGia),
    FOREIGN KEY (MaDuAn) REFERENCES DuAn(MaDuAn)
);

-- Chèn dữ liệu mẫu vào bảng Chuyên gia
INSERT INTO ChuyenGia (MaChuyenGia, HoTen, NgaySinh, GioiTinh, Email, SoDienThoai, ChuyenNganh, NamKinhNghiem)
VALUES 
(1, N'Nguyễn Văn An', '1985-05-10', N'Nam', 'nguyenvanan@email.com', '0901234567', N'Phát triển phần mềm', 10),
(2, N'Trần Thị Bình', '1990-08-15', N'Nữ', 'tranthiminh@email.com', '0912345678', N'An ninh mạng', 7),
(3, N'Lê Hoàng Cường', '1988-03-20', N'Nam', 'lehoangcuong@email.com', '0923456789', N'Trí tuệ nhân tạo', 9),
(4, N'Phạm Thị Dung', '1992-11-25', N'Nữ', 'phamthidung@email.com', '0934567890', N'Khoa học dữ liệu', 6),
(5, N'Hoàng Văn Em', '1987-07-30', N'Nam', 'hoangvanem@email.com', '0945678901', N'Điện toán đám mây', 8),
(6, N'Ngô Thị Phượng', '1993-02-14', N'Nữ', 'ngothiphuong@email.com', '0956789012', N'Phân tích dữ liệu', 5),
(7, N'Đặng Văn Giang', '1986-09-05', N'Nam', 'dangvangiang@email.com', '0967890123', N'IoT', 11),
(8, N'Vũ Thị Hương', '1991-12-20', N'Nữ', 'vuthihuong@email.com', '0978901234', N'UX/UI Design', 7),
(9, N'Bùi Văn Inh', '1989-04-15', N'Nam', 'buivaninch@email.com', '0989012345', N'DevOps', 8),
(10, N'Lý Thị Khánh', '1994-06-30', N'Nữ', 'lythikhanh@email.com', '0990123456', N'Blockchain', 4);

-- Chèn dữ liệu mẫu vào bảng Công ty
INSERT INTO CongTy (MaCongTy, TenCongTy, DiaChi, LinhVuc, SoNhanVien)
VALUES 
(1, N'TechViet Solutions', N'123 Đường Lê Lợi, TP.HCM', N'Phát triển phần mềm', 200),
(2, N'DataSmart Analytics', N'456 Đường Nguyễn Huệ, Hà Nội', N'Phân tích dữ liệu', 150),
(3, N'CloudNine Systems', N'789 Đường Trần Hưng Đạo, Đà Nẵng', N'Điện toán đám mây', 100),
(4, N'SecureNet Vietnam', N'101 Đường Võ Văn Tần, TP.HCM', N'An ninh mạng', 80),
(5, N'AI Innovate', N'202 Đường Lý Tự Trọng, Hà Nội', N'Trí tuệ nhân tạo', 120);

-- Chèn dữ liệu mẫu vào bảng Dự án
INSERT INTO DuAn (MaDuAn, TenDuAn, MaCongTy, NgayBatDau, NgayKetThuc, TrangThai)
VALUES 
(1, N'Phát triển ứng dụng di động cho ngân hàng', 1, '2023-01-01', '2023-06-30', N'Hoàn thành'),
(2, N'Xây dựng hệ thống phân tích dữ liệu khách hàng', 2, '2023-03-15', '2023-09-15', N'Đang thực hiện'),
(3, N'Triển khai giải pháp đám mây cho doanh nghiệp', 3, '2023-02-01', '2023-08-31', N'Đang thực hiện'),
(4, N'Nâng cấp hệ thống bảo mật cho tập đoàn viễn thông', 4, '2023-04-01', '2023-10-31', N'Đang thực hiện'),
(5, N'Phát triển chatbot AI cho dịch vụ khách hàng', 5, '2023-05-01', '2023-11-30', N'Đang thực hiện');

-- Chèn dữ liệu mẫu vào bảng Kỹ năng
INSERT INTO KyNang (MaKyNang, TenKyNang, LoaiKyNang)
VALUES 
(1, 'Java', N'Ngôn ngữ lập trình'),
(2, 'Python', N'Ngôn ngữ lập trình'),
(3, 'Machine Learning', N'Công nghệ'),
(4, 'AWS', N'Nền tảng đám mây'),
(5, 'Docker', N'Công cụ'),
(6, 'Kubernetes', N'Công cụ'),
(7, 'SQL', N'Cơ sở dữ liệu'),
(8, 'NoSQL', N'Cơ sở dữ liệu'),
(9, 'React', N'Framework'),
(10, 'Angular', N'Framework');

-- Chèn dữ liệu mẫu vào bảng Chuyên gia - Kỹ năng
INSERT INTO ChuyenGia_KyNang (MaChuyenGia, MaKyNang, CapDo)
VALUES 
(1, 1, 5), (1, 7, 4), (1, 9, 3),
(2, 2, 4), (2, 3, 3), (2, 8, 4),
(3, 2, 5), (3, 3, 5), (3, 4, 3),
(4, 2, 4), (4, 7, 5), (4, 8, 4),
(5, 4, 5), (5, 5, 4), (5, 6, 4),
(6, 2, 4), (6, 3, 3), (6, 7, 5),
(7, 1, 3), (7, 2, 4), (7, 5, 3),
(8, 9, 5), (8, 10, 4),
(9, 5, 5), (9, 6, 5), (9, 4, 4),
(10, 2, 3), (10, 3, 3), (10, 8, 4);

-- Chèn dữ liệu mẫu vào bảng Chuyên gia - Dự án
INSERT INTO ChuyenGia_DuAn (MaChuyenGia, MaDuAn, VaiTro, NgayThamGia)
VALUES 
(1, 1, N'Trưởng nhóm phát triển', '2023-01-01'),
(2, 4, N'Chuyên gia bảo mật', '2023-04-01'),
(3, 5, N'Kỹ sư AI', '2023-05-01'),
(4, 2, N'Chuyên gia phân tích dữ liệu', '2023-03-15'),
(5, 3, N'Kiến trúc sư đám mây', '2023-02-01'),
(6, 2, N'Chuyên gia phân tích dữ liệu', '2023-03-15'),
(7, 3, N'Kỹ sư IoT', '2023-02-01'),
(8, 1, N'Nhà thiết kế UX/UI', '2023-01-01'),
(9, 3, N'Kỹ sư DevOps', '2023-02-01'),
(10, 5, N'Kỹ sư Blockchain', '2023-05-01');


-- Câu hỏi SQL từ cơ bản đến nâng cao, bao gồm trigger
-- Cơ bản:
--1. Liệt kê tất cả chuyên gia trong cơ sở dữ liệu.
SELECT * FROM ChuyenGia;

--2. Hiển thị tên và email của các chuyên gia nữ.
SELECT HoTen, Email
FROM ChuyenGia
WHERE GioiTinh = N'Nữ';

--3. Liệt kê các công ty có trên 100 nhân viên.
SELECT TenCongTy
FROM CongTy
WHERE SoNhanVien > 100;

--4. Hiển thị tên và ngày bắt đầu của các dự án trong năm 2023.
SELECT TenDuAn, NgayBatDau
FROM DuAn
WHERE YEAR(NgayBatDau) = 2023;

--5
-- Trung cấp:
--6. Liệt kê tên chuyên gia và số lượng dự án họ tham gia.
SELECT cg.HoTen, COUNT(tg.MaDuAn) AS SoLuongDuAn
FROM ChuyenGia cg
JOIN ChuyenGia_DuAn tg ON cg.MaChuyenGia = tg.MaChuyenGia
GROUP BY cg.HoTen;

--7. Tìm các dự án có sự tham gia của chuyên gia có kỹ năng 'Python' cấp độ 4 trở lên.
SELECT DISTINCT da.TenDuAn
FROM DuAn da
JOIN ChuyenGia_DuAn tg ON da.MaDuAn = tg.MaDuAn
JOIN ChuyenGia_KyNang ck ON tg.MaChuyenGia = ck.MaChuyenGia
JOIN KyNang kn ON ck.MaKyNang = kn.MaKyNang
WHERE kn.TenKyNang = 'Python' AND ck.CapDo >= 4;

--8. Hiển thị tên công ty và số lượng dự án đang thực hiện.
SELECT ct.TenCongTy, COUNT(da.MaDuAn) AS SoLuongDuAn
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
WHERE da.TrangThai = N'Đang thực hiện'
GROUP BY ct.TenCongTy;

--9. Tìm chuyên gia có số năm kinh nghiệm cao nhất trong mỗi chuyên ngành.
SELECT ChuyenNganh, HoTen, MAX(NamKinhNghiem) AS NamKinhNghiem
FROM ChuyenGia
GROUP BY ChuyenNganh, HoTen;

--10. Liệt kê các cặp chuyên gia đã từng làm việc cùng nhau trong ít nhất một dự án.
SELECT DISTINCT c1.HoTen AS ChuyenGia1, c2.HoTen AS ChuyenGia2
FROM ChuyenGia_DuAn cd1
JOIN ChuyenGia_DuAn cd2 ON cd1.MaDuAn = cd2.MaDuAn AND cd1.MaChuyenGia < cd2.MaChuyenGia
JOIN ChuyenGia c1 ON cd1.MaChuyenGia = c1.MaChuyenGia
JOIN ChuyenGia c2 ON cd2.MaChuyenGia = c2.MaChuyenGia;

-- Nâng cao:
--11. Tính tổng thời gian (theo ngày) mà mỗi chuyên gia đã tham gia vào các dự án.
SELECT cg.HoTen, SUM(DATEDIFF(DAY, cd.NgayThamGia, da.NgayKetThuc)) AS TongThoiGian
FROM ChuyenGia cg
JOIN ChuyenGia_DuAn cd ON cg.MaChuyenGia = cd.MaChuyenGia
JOIN DuAn da ON cd.MaDuAn = da.MaDuAn
GROUP BY cg.HoTen;

--12. Tìm các công ty có tỷ lệ dự án hoàn thành cao nhất (trên 90%).
SELECT ct.TenCongTy, 
       COUNT(da.MaDuAn) * 100.0 / COUNT(*) AS TyLeHoanThanh
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy AND da.TrangThai = N'Hoàn thành'
GROUP BY ct.TenCongTy
HAVING COUNT(da.MaDuAn) * 100.0 / COUNT(*) > 90;

--13. Liệt kê top 3 kỹ năng được yêu cầu nhiều nhất trong các dự án.
SELECT TOP 3 kn.TenKyNang, COUNT(*) AS SoLanYeuCau
FROM ChuyenGia_KyNang ck
JOIN KyNang kn ON ck.MaKyNang = kn.MaKyNang
GROUP BY kn.TenKyNang
ORDER BY SoLanYeuCau DESC;

--14. Tính lương trung bình của chuyên gia theo từng cấp độ kinh nghiệm (Junior: 0-2 năm, Middle: 3-5 năm, Senior: >5 năm).
SELECT 
    IIF(NamKinhNghiem <= 2, N'Junior', IIF(NamKinhNghiem <= 5, N'Middle', N'Senior')) AS CapDoKinhNghiem,
    COUNT(*) AS SoLuongChuyenGia
FROM ChuyenGia
GROUP BY 
    IIF(NamKinhNghiem <= 2, N'Junior', IIF(NamKinhNghiem <= 5, N'Middle', N'Senior'));

--15. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
SELECT da.TenDuAn
FROM DuAn da
JOIN ChuyenGia_DuAn cd ON da.MaDuAn = cd.MaDuAn
JOIN ChuyenGia cg ON cd.MaChuyenGia = cg.MaChuyenGia
GROUP BY da.TenDuAn
HAVING COUNT(DISTINCT cg.ChuyenNganh) = (SELECT COUNT(DISTINCT ChuyenNganh) FROM ChuyenGia);

-- Trigger:
--16. Tạo một trigger để tự động cập nhật số lượng dự án của công ty khi thêm hoặc xóa dự án.
GO
CREATE TRIGGER TRG_UPDATEPROJ
ON DuAn
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE CongTy
    SET SoNhanVien = (SELECT COUNT(*) FROM DuAn WHERE DuAn.MaCongTy = CongTy.MaCongTy);
END;

--17. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng ChuyenGia.
CREATE TABLE Log_ChuyenGia (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MaChuyenGia INT,
    HoTen NVARCHAR(100),
    NgayThayDoi DATETIME,
    HanhDong NVARCHAR(50)
);
GO
CREATE TRIGGER TRG_LOGCHUYENGIA
ON ChuyenGia
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Log_ChuyenGia (MaChuyenGia, HoTen, HanhDong)
        SELECT MaChuyenGia, HoTen, 'INSERT' FROM inserted;
    END;
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Log_ChuyenGia (MaChuyenGia, HoTen, HanhDong)
        SELECT MaChuyenGia, HoTen, 'UPDATE' FROM inserted;
    END;
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Log_ChuyenGia (MaChuyenGia, HoTen, HanhDong)
        SELECT MaChuyenGia, HoTen, 'DELETE' FROM deleted;
    END;
END;

--18. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
GO
CREATE TRIGGER TRG_LMPROJECT
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT MaChuyenGia
        FROM ChuyenGia_DuAn
        GROUP BY MaChuyenGia
        HAVING COUNT(MaDuAn) > 5
    )
    BEGIN
        DELETE FROM ChuyenGia_DuAn
        WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM inserted)
        AND MaDuAn IN (SELECT MaDuAn FROM inserted);
    END;
END;

--19. Tạo một trigger để tự động cập nhật trạng thái của dự án thành 'Hoàn thành' khi tất cả chuyên gia đã kết thúc công việc.
GO
CREATE TRIGGER TRG_PROJECTSTATUS
ON ChuyenGia_DuAn
AFTER DELETE
AS
BEGIN
    UPDATE DuAn
    SET TrangThai = N'Hoàn thành'
    WHERE MaDuAn IN (
        SELECT cd.MaDuAn
        FROM ChuyenGia_DuAn cd
        LEFT JOIN ChuyenGia_DuAn cd_remaining ON cd.MaDuAn = cd_remaining.MaDuAn
        WHERE cd_remaining.MaChuyenGia IS NULL
    );
END;

--20. Tạo một trigger để tự động tính toán và cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
ALTER TABLE DuAn ADD DiemDanhGia FLOAT NULL;
ALTER TABLE CongTy ADD DiemTrungBinh FLOAT NULL;

GO
CREATE TRIGGER TRG_UPRATING
ON DuAn
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE CongTy
    SET DiemTrungBinh = (
        SELECT AVG(DiemDanhGia)
        FROM DuAn
        WHERE DuAn.MaCongTy = CongTy.MaCongTy AND DiemDanhGia IS NOT NULL
    )
    WHERE EXISTS (
        SELECT 1
        FROM DuAn
        WHERE DuAn.MaCongTy = CongTy.MaCongTy
    );
END;

