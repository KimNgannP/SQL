CREATE DATABASE QLCT_T2
GO

USE QLCT_T2
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


-- Liệt kê tất cả các chuyên gia và sắp xếp theo họ tên.
SELECT HoTen 
FROM ChuyenGia 
ORDER BY HoTen

-- Hiển thị tên và số điện thoại của các chuyên gia có chuyên ngành 'Phát triển phần mềm'.
SELECT HoTen, SoDienThoai
FROM ChuyenGia 
WHERE ChuyenNganh = N'Phát triển phần mềm'

-- Liệt kê tất cả các công ty có trên 100 nhân viên.
SELECT TenCongTy, SoNhanVien
FROM CongTy
WHERE SoNhanVien > 100

-- Hiển thị tên và ngày bắt đầu của các dự án bắt đầu trong năm 2023.
SELECT TenDuAn, NgayBatDau
FROM DuAn
WHERE YEAR(NgayBatDau) = 2023

-- Liệt kê tất cả các kỹ năng và sắp xếp theo tên kỹ năng.
SELECT TenKyNang
FROM KyNang
ORDER BY TenKyNang

-- Hiển thị tên và email của các chuyên gia có tuổi dưới 35 (tính đến năm 2024).
SELECT HoTen, Email
FROM ChuyenGia
WHERE DATEDIFF(YEAR, NgaySinh, '2024-01-01') < 35

-- Hiển thị tên và chuyên ngành của các chuyên gia nữ.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE GioiTinh = N'Nữ'

-- Liệt kê tên các kỹ năng thuộc loại 'Công nghệ'.
SELECT TenKyNang
FROM KyNang
WHERE LoaiKyNang = N'Công nghệ'

-- Hiển thị tên và địa chỉ của các công ty trong lĩnh vực 'Phân tích dữ liệu'.
SELECT TenCongTy, DiaChi
FROM CongTy
WHERE LinhVuc = N'Phân tích dữ liệu'

-- Liệt kê tên các dự án có trạng thái 'Hoàn thành'.
SELECT TenDuAn
FROM DuAn
WHERE TrangThai = N'Hoàn thành'

-- Hiển thị tên và số năm kinh nghiệm của các chuyên gia, sắp xếp theo số năm kinh nghiệm giảm dần.
SELECT HoTen, NamKinhNghiem
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC

-- Liệt kê tên các công ty và số lượng nhân viên, chỉ hiển thị các công ty có từ 100 đến 200 nhân viên.
SELECT TenCongTy, SoNhanVien
FROM CongTy
WHERE SoNhanVien BETWEEN 100 AND 200

-- Hiển thị tên dự án và ngày kết thúc của các dự án kết thúc trong năm 2023.
SELECT TenDuAn, NgayKetThuc
FROM DuAn
WHERE YEAR(NgayKetThuc) = 2023

-- Liệt kê tên và email của các chuyên gia có tên bắt đầu bằng chữ 'N'.
SELECT HoTen, Email
FROM ChuyenGia
WHERE HoTen LIKE N'N%'

-- Hiển thị tên kỹ năng và loại kỹ năng, không bao gồm các kỹ năng thuộc loại 'Ngôn ngữ lập trình'.
SELECT TenKyNang, LoaiKyNang
FROM KyNang
WHERE LoaiKyNang != N'Ngôn ngữ lập trình'

-- Hiển thị tên công ty và lĩnh vực hoạt động, sắp xếp theo lĩnh vực.
SELECT TenCongTy, LinhVuc
FROM CongTy
ORDER BY LinhVuc

-- Hiển thị tên và chuyên ngành của các chuyên gia nam có trên 5 năm kinh nghiệm.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE GioiTinh = N'Nam' AND NamKinhNghiem > 5

-- Liệt kê tất cả các chuyên gia trong cơ sở dữ liệu.
SELECT * FROM ChuyenGia

-- Hiển thị tên và email của tất cả các chuyên gia nữ.
SELECT HoTen, Email
FROM ChuyenGia
WHERE GioiTinh = N'Nữ'

--  Liệt kê tất cả các công ty và số nhân viên của họ, sắp xếp theo số nhân viên giảm dần.
SELECT TenCongTy, SoNhanVien
FROM CongTy
ORDER BY SoNhanVien DESC

-- Hiển thị tất cả các dự án đang trong trạng thái "Đang thực hiện".
SELECT TenDuAn
FROM DuAn
WHERE TrangThai = N'Đang thực hiện'

-- Liệt kê tất cả các kỹ năng thuộc loại "Ngôn ngữ lập trình".
SELECT TenKyNang
FROM KyNang
WHERE LoaiKyNang = N'Ngôn ngữ lập trình'

-- Hiển thị tên và chuyên ngành của các chuyên gia có trên 8 năm kinh nghiệm.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE NamKinhNghiem > 8

-- Liệt kê tất cả các dự án của công ty có MaCongTy là 1.
SELECT TenDuAn
FROM DuAn
WHERE MaCongTy = 1

-- Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT ChuyenNganh, COUNT(*) AS SoChuyenGia 
FROM ChuyenGia 
GROUP BY ChuyenNganh;

-- Tìm chuyên gia có số năm kinh nghiệm cao nhất.
SELECT HoTen, NamKinhNghiem 
FROM ChuyenGia 
WHERE NamKinhNghiem = (SELECT MAX(NamKinhNghiem) FROM ChuyenGia);

-- Liệt kê tổng số nhân viên cho mỗi công ty mà có số nhân viên lớn hơn 100. Sắp xếp kết quả theo số nhân viên tăng dần.
SELECT TenCongTy, SoNhanVien 
FROM CongTy 
WHERE SoNhanVien > 100 
ORDER BY SoNhanVien

-- Xác định số lượng dự án mà mỗi công ty tham gia có trạng thái 'Đang thực hiện'. Chỉ bao gồm các công ty có hơn một dự án đang thực hiện. Sắp xếp kết quả theo số lượng dự án giảm dần.
SELECT MaCongTy, COUNT(*) AS SoDuAn 
FROM DuAn 
WHERE TrangThai = N'Đang thực hiện' 
GROUP BY MaCongTy 
HAVING COUNT(*) > 1 
ORDER BY SoDuAn DESC;

-- Tìm kiếm các kỹ năng mà chuyên gia có cấp độ từ 4 trở lên và tính tổng số chuyên gia cho mỗi kỹ năng đó. Chỉ bao gồm những kỹ năng có tổng số chuyên gia lớn hơn 2. Sắp xếp kết quả theo tên kỹ năng tăng dần.
SELECT TenKyNang, COUNT(DISTINCT MaChuyenGia) AS SoChuyenGia 
FROM ChuyenGia_KyNang ck
JOIN KyNang k ON ck.MaKyNang = k.MaKyNang
WHERE CapDo >= 4 
GROUP BY TenKyNang 
HAVING COUNT(DISTINCT MaChuyenGia) > 2 
ORDER BY TenKyNang;

-- Liệt kê tên các công ty có lĩnh vực 'Điện toán đám mây' và tính tổng số nhân viên của họ. Sắp xếp kết quả theo tổng số nhân viên tăng dần.
SELECT TenCongTy, SoNhanVien 
FROM CongTy 
WHERE LinhVuc = N'Điện toán đám mây' 
ORDER BY SoNhanVien;

-- Liệt kê tên các công ty có số nhân viên từ 50 đến 150 và tính trung bình số nhân viên của họ. Sắp xếp kết quả theo tên công ty tăng dần.
SELECT TenCongTy, SoNhanVien, 
       AVG(SoNhanVien) OVER () AS TrungBinhSoNhanVien
FROM CongTy
WHERE SoNhanVien BETWEEN 50 AND 150
ORDER BY TenCongTy ASC;

-- Xác định số lượng kỹ năng cho mỗi chuyên gia có cấp độ tối đa là 5 và chỉ bao gồm những chuyên gia có ít nhất một kỹ năng đạt cấp độ tối đa này. Sắp xếp kết quả theo tên chuyên gia tăng dần.
SELECT cg.HoTen, COUNT(ck.MaKyNang) AS SoKyNang 
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ck ON cg.MaChuyenGia = ck.MaChuyenGia
WHERE ck.CapDo = 5
GROUP BY cg.HoTen
ORDER BY cg.HoTen ASC;

-- Liệt kê tên các kỹ năng mà chuyên gia có cấp độ từ 4 trở lên và tính tổng số chuyên gia cho mỗi kỹ năng đó. Chỉ bao gồm những kỹ năng có tổng số chuyên gia lớn hơn 2. Sắp xếp kết quả theo tên kỹ năng tăng dần.
SELECT k.TenKyNang, COUNT(ck.MaChuyenGia) AS SoChuyenGia 
FROM KyNang k
JOIN ChuyenGia_KyNang ck ON k.MaKyNang = ck.MaKyNang
WHERE ck.CapDo >= 4
GROUP BY k.TenKyNang
HAVING COUNT(ck.MaChuyenGia) > 2
ORDER BY k.TenKyNang ASC;

-- Tìm kiếm tên của các chuyên gia trong lĩnh vực 'Phát triển phần mềm' và tính trung bình cấp độ kỹ năng của họ. Chỉ bao gồm những chuyên gia có cấp độ trung bình lớn hơn 3. Sắp xếp kết quả theo cấp độ trung bình giảm dần.
SELECT cg.HoTen, AVG(ck.CapDo) AS TrungBinhCapDo 
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ck ON cg.MaChuyenGia = ck.MaChuyenGia
WHERE cg.ChuyenNganh = N'Phát triển phần mềm'
GROUP BY cg.HoTen
HAVING AVG(ck.CapDo) > 3
ORDER BY TrungBinhCapDo DESC;


