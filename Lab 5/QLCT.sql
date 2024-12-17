-- 101. Tạo một trigger để tự động cập nhật trường NgayCapNhat trong bảng ChuyenGia mỗi khi có sự thay đổi thông tin.
ALTER TABLE ChuyenGia ADD NgayCapNhat DATETIME;
GO 
CREATE TRIGGER TRG_UpdateNgayCapNhat
ON ChuyenGia
AFTER UPDATE
AS
BEGIN
    UPDATE ChuyenGia
    SET NgayCapNhat = GETDATE()
    FROM ChuyenGia
    INNER JOIN Inserted ON ChuyenGia.MaChuyenGia = Inserted.MaChuyenGia
    WHERE ChuyenGia.MaChuyenGia = Inserted.MaChuyenGia;
END;

-- 102. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng DuAn.
CREATE TABLE Log_DuAn (
    LogID INT IDENTITY PRIMARY KEY,
    MaDuAn INT,
    ThaoTac NVARCHAR(50),
    NgayThucHien DATETIME DEFAULT GETDATE()
);
GO 
CREATE TRIGGER TRG_LogDuAn
ON DuAn
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM Inserted) AND EXISTS (SELECT * FROM Deleted)
        INSERT INTO Log_DuAn (MaDuAn, ThaoTac) 
        SELECT MaDuAn, N'Cập nhật' FROM Inserted;
    ELSE IF EXISTS (SELECT * FROM Inserted)
        INSERT INTO Log_DuAn (MaDuAn, ThaoTac) 
        SELECT MaDuAn, N'Thêm mới' FROM Inserted;
    ELSE IF EXISTS (SELECT * FROM Deleted)
        INSERT INTO Log_DuAn (MaDuAn, ThaoTac) 
        SELECT MaDuAn, N'Xóa' FROM Deleted;
END;

-- 103. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
GO
CREATE TRIGGER TRG_LimitDuAnChuyenGia
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    DECLARE @MaChuyenGia INT;
    SELECT @MaChuyenGia = MaChuyenGia FROM Inserted;

    IF (SELECT COUNT(*) FROM ChuyenGia_DuAn WHERE MaChuyenGia = @MaChuyenGia) > 5
    BEGIN
        PRINT N'Một chuyên gia không thể tham gia quá 5 dự án cùng lúc.';
        DELETE FROM ChuyenGia_DuAn WHERE MaChuyenGia = @MaChuyenGia;
    END;
END;

-- 104. Tạo một trigger để tự động cập nhật số lượng nhân viên trong bảng CongTy mỗi khi có sự thay đổi trong bảng ChuyenGia.
GO
CREATE TRIGGER TRG_UpdateSoNhanVien
ON ChuyenGia
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE CongTy
    SET SoNhanVien = (
        SELECT COUNT(DISTINCT CG.MaChuyenGia)
        FROM ChuyenGia CG
        INNER JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia = CGDA.MaChuyenGia
        INNER JOIN DuAn DA ON CGDA.MaDuAn = DA.MaDuAn
        WHERE DA.MaCongTy = CongTy.MaCongTy
    )
    FROM CongTy;
END;

-- 105. Tạo một trigger để ngăn chặn việc xóa các dự án đã hoàn thành.
GO
CREATE TRIGGER TRG_PreventDeleteCompletedDuAn
ON DuAn
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Deleted WHERE TrangThai = N'Hoàn thành')
    BEGIN
        PRINT N'Không thể xóa các dự án đã hoàn thành.';
        RETURN;
    END;

    DELETE DuAn
    FROM DuAn
    INNER JOIN Deleted ON DuAn.MaDuAn = Deleted.MaDuAn;
END;

-- 106. Tạo một trigger để tự động cập nhật cấp độ kỹ năng của chuyên gia khi họ tham gia vào một dự án mới.
GO
CREATE TRIGGER TRG_UpdateCapDoKyNang
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    UPDATE ChuyenGia_KyNang
    SET CapDo = CapDo + 1
    FROM ChuyenGia_KyNang
    INNER JOIN Inserted ON ChuyenGia_KyNang.MaChuyenGia = Inserted.MaChuyenGia;
END;

-- 107. Tạo một trigger để ghi log mỗi khi có sự thay đổi cấp độ kỹ năng của chuyên gia.
CREATE TABLE Log_CapDoKyNang (
    LogID INT IDENTITY PRIMARY KEY,
    MaChuyenGia INT,
    MaKyNang INT,
    CapDoCu INT,
    CapDoMoi INT,
    NgayThucHien DATETIME DEFAULT GETDATE()
);
GO
CREATE TRIGGER TRG_LogCapDoKyNang
ON ChuyenGia_KyNang
AFTER UPDATE
AS
BEGIN
    INSERT INTO Log_CapDoKyNang (MaChuyenGia, MaKyNang, CapDoCu, CapDoMoi)
    SELECT d.MaChuyenGia, d.MaKyNang, d.CapDo, i.CapDo
    FROM Deleted d
    INNER JOIN Inserted i ON d.MaChuyenGia = i.MaChuyenGia AND d.MaKyNang = i.MaKyNang;
END;

-- 108. Tạo một trigger để đảm bảo rằng ngày kết thúc của dự án luôn lớn hơn ngày bắt đầu.
GO
CREATE TRIGGER TRG_CheckNgayDuAn
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inserted
        WHERE NgayKetThuc <= NgayBatDau
    )
    BEGIN
        PRINT N'Ngày kết thúc phải lớn hơn ngày bắt đầu.';
        RETURN;
    END;
END;

-- 109. Tạo một trigger để tự động xóa các bản ghi liên quan trong bảng ChuyenGia_KyNang khi một kỹ năng bị xóa.
GO
CREATE TRIGGER TRG_DeleteKyNang
ON KyNang
AFTER DELETE
AS
BEGIN
    DELETE FROM ChuyenGia_KyNang
    WHERE MaKyNang IN (SELECT MaKyNang FROM Deleted);
END;
GO

-- 110. Tạo một trigger để đảm bảo rằng một công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.
GO
CREATE TRIGGER TRG_LimitDuAnCongTy
ON DuAn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT MaCongTy
        FROM DuAn
        WHERE TrangThai = N'Đang thực hiện'
        GROUP BY MaCongTy
        HAVING COUNT(*) > 10
    )
    BEGIN
        PRINT N'Một công ty không thể có quá 10 dự án đang thực hiện.';
        RETURN;
    END;
END;

-- 123. Tạo một trigger để tự động cập nhật lương của chuyên gia dựa trên cấp độ kỹ năng và số năm kinh nghiệm.
GO
CREATE TRIGGER TRG_UpdateLuongChuyenGia
ON ChuyenGia_KyNang
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE ChuyenGia
    SET Luong = (CK.CapDo * 1000000) + (CG.NamKinhNghiem * 500000)
    FROM ChuyenGia CG
    INNER JOIN ChuyenGia_KyNang CK ON CG.MaChuyenGia = CK.MaChuyenGia;
END;
GO

-- 124. Tạo một trigger để tự động gửi thông báo khi một dự án sắp đến hạn (còn 7 ngày).
-- Tạo bảng ThongBao nếu chưa có
CREATE TABLE ThongBao (
    MaThongBao INT IDENTITY PRIMARY KEY,
    NoiDung NVARCHAR(200),
    NgayThongBao DATETIME DEFAULT GETDATE()
);
GO
CREATE TRIGGER TRG_ThongBaoSapDenHan
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO ThongBao (NoiDung)
    SELECT CONCAT(N'Dự án "', TenDuAn, N'" sắp đến hạn sau 7 ngày.')
    FROM DuAn
    WHERE DATEDIFF(DAY, GETDATE(), NgayKetThuc) = 7;
END;

-- 125. Tạo một trigger để ngăn chặn việc xóa hoặc cập nhật thông tin của chuyên gia đang tham gia dự án.
GO
CREATE TRIGGER TRG_DeleteChuyenGia
ON ChuyenGia
INSTEAD OF DELETE, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Deleted D
        INNER JOIN ChuyenGia_DuAn CDA ON D.MaChuyenGia = CDA.MaChuyenGia
    )
    BEGIN
        PRINT N'Không thể xóa hoặc cập nhật thông tin của chuyên gia đang tham gia dự án.';
        RETURN;
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM Deleted)
            DELETE FROM ChuyenGia WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM Deleted);
        
        IF EXISTS (SELECT 1 FROM Inserted)
            UPDATE ChuyenGia SET ... WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM Inserted);
    END
END;

-- 126. Tạo một trigger để tự động cập nhật số lượng chuyên gia trong mỗi chuyên ngành.
-- Tạo bảng ThongKeChuyenNganh nếu chưa có
CREATE TABLE ThongKeChuyenNganh (
    ChuyenNganh NVARCHAR(50) PRIMARY KEY,
    SoLuongChuyenGia INT
);
GO
CREATE TRIGGER TRG_ThongKeChuyenNganh
ON ChuyenGia
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE Target
    SET Target.SoLuongChuyenGia = Source.SoLuong
    FROM ThongKeChuyenNganh Target
    INNER JOIN (
        SELECT ChuyenNganh, COUNT(*) AS SoLuong
        FROM ChuyenGia
        GROUP BY ChuyenNganh
    ) AS Source
    ON Target.ChuyenNganh = Source.ChuyenNganh;
    INSERT INTO ThongKeChuyenNganh (ChuyenNganh, SoLuongChuyenGia)
    SELECT ChuyenNganh, COUNT(*) AS SoLuong
    FROM ChuyenGia
    WHERE ChuyenNganh NOT IN (SELECT ChuyenNganh FROM ThongKeChuyenNganh)
    GROUP BY ChuyenNganh;
END;

-- 127. Tạo một trigger để tự động tạo bản sao lưu của dự án khi nó được đánh dấu là hoàn thành.
-- Tạo bảng DuAnHoanThanh nếu chưa có
CREATE TABLE DuAnHoanThanh (
    MaDuAn INT PRIMARY KEY,
    TenDuAn NVARCHAR(200),
    MaCongTy INT,
    NgayBatDau DATE,
    NgayKetThuc DATE,
    TrangThai NVARCHAR(50)
);
GO
CREATE TRIGGER TRG_DuAnHoanThanh
ON DuAn
AFTER UPDATE
AS
BEGIN
    INSERT INTO DuAnHoanThanh (MaDuAn, TenDuAn, MaCongTy, NgayBatDau, NgayKetThuc, TrangThai)
    SELECT MaDuAn, TenDuAn, MaCongTy, NgayBatDau, NgayKetThuc, TrangThai
    FROM Inserted
    WHERE TrangThai = N'Hoàn thành';
END;

-- 128. Tạo một trigger để tự động cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
ALTER TABLE DuAn ADD DiemDanhGia FLOAT;
GO
CREATE TRIGGER TRG_UpdateDiemDanhGia
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE CongTy
    SET DiemTrungBinh = (
        SELECT AVG(DiemDanhGia)
        FROM DuAn
        WHERE DuAn.MaCongTy = CongTy.MaCongTy AND DiemDanhGia IS NOT NULL
    )
    FROM CongTy;
END;

-- 129. Tạo một trigger để tự động phân công chuyên gia vào dự án dựa trên kỹ năng và kinh nghiệm.
GO
CREATE TRIGGER TRG_AutoAssignChuyenGia
ON DuAn
AFTER INSERT
AS
BEGIN
    INSERT INTO ChuyenGia_DuAn (MaChuyenGia, MaDuAn, VaiTro, NgayThamGia)
    SELECT CG.MaChuyenGia, I.MaDuAn, N'Chuyên gia tự động phân công', GETDATE()
    FROM ChuyenGia CG
    INNER JOIN Inserted I ON 1=1  -- Điều kiện này giúp kết nối bảng Inserted với Chuyên gia
    WHERE CG.ChuyenNganh = N'Phát triển phần mềm' AND CG.NamKinhNghiem > 5;
END;

-- 130. Tạo một trigger để tự động cập nhật trạng thái "bận" của chuyên gia khi họ được phân công vào dự án mới.
ALTER TABLE ChuyenGia ADD TrangThai NVARCHAR(50);
GO
CREATE TRIGGER TRG_UpdateTrangThaiChuyenGia
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    UPDATE ChuyenGia
    SET TrangThai = N'Bận'
    FROM ChuyenGia
    INNER JOIN Inserted ON ChuyenGia.MaChuyenGia = Inserted.MaChuyenGia;
END;

-- 131. Tạo một trigger để ngăn chặn việc thêm kỹ năng trùng lặp cho một chuyên gia.
GO
CREATE TRIGGER TRG_PDKyNang
ON ChuyenGia_KyNang
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ChuyenGia_KyNang CK
        INNER JOIN Inserted I ON CK.MaChuyenGia = I.MaChuyenGia AND CK.MaKyNang = I.MaKyNang
        WHERE CK.MaChuyenGia = I.MaChuyenGia AND CK.MaKyNang = I.MaKyNang
    )
    BEGIN
        DELETE FROM ChuyenGia_KyNang
        WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM Inserted)
        AND MaKyNang IN (SELECT MaKyNang FROM Inserted);
    END
END;

-- 132. Tạo một trigger để tự động tạo báo cáo tổng kết khi một dự án kết thúc.
GO
CREATE TRIGGER TRG_TaoBaoCaoKhiDuAnKetThuc
ON DuAn
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inserted I
        INNER JOIN Deleted D ON I.MaDuAn = D.MaDuAn
        WHERE I.TrangThai = 'KET_THUC' AND D.TrangThai != 'KET_THUC'
    )
    BEGIN
        -- Chèn báo cáo tổng kết khi dự án kết thúc
        INSERT INTO BAO_CAO (TenBaoCao, DuAnID, ThoiGianTao, NoiDung)
        SELECT 'Bao cao tong ket', I.MaDuAn, GETDATE(), CONCAT('Du an ', I.TenDuAn, ' da ket thuc.')
        FROM Inserted I
        WHERE I.TrangThai = 'KET_THUC';
    END
END;

-- 133. Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.
-- 133. (tiếp tục) Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.
GO
CREATE TRIGGER TRG_ThongBaoVuotHan
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO ThongBao (NoiDung)
    SELECT CONCAT(N'Dự án "', TenDuAn, N'" đã vượt quá 90% thời gian thực hiện.')
    FROM DuAn
    WHERE DATEDIFF(DAY, GETDATE(), NgayKetThuc) <= (DATEDIFF(DAY, NgayBatDau, NgayKetThuc) * 0.1);
END;

-- 134. Tạo một trigger để tự động cập nhật trạng thái của dự án khi ngày kết thúc đã qua.
GO
CREATE TRIGGER TRG_UpdateTrangThaiDuAn
ON DuAn
AFTER UPDATE
AS
BEGIN
    UPDATE DuAn
    SET TrangThai = N'Hoàn thành'
    WHERE MaDuAn IN (SELECT MaDuAn FROM Inserted WHERE NgayKetThuc < GETDATE() AND TrangThai <> N'Hoàn thành');
END;

-- 135. Tạo một trigger để đảm bảo rằng chỉ có một chuyên gia có thể tham gia vào một dự án với vai trò 'Trưởng nhóm'.
GO
CREATE TRIGGER TRG_LimitTruongNhom
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ChuyenGia_DuAn
        WHERE MaDuAn = (SELECT MaDuAn FROM Inserted)
        AND VaiTro = N'Trưởng nhóm'
    )
    BEGIN
        PRINT N'Mỗi dự án chỉ có một Trưởng nhóm.';
        DELETE FROM ChuyenGia_DuAn WHERE MaDuAn = (SELECT MaDuAn FROM Inserted) AND VaiTro = N'Trưởng nhóm';
    END;
END;

-- 136. Tạo trigger để đảm bảo không có 2 chuyên gia tham gia vào cùng một dự án với cùng một vai trò.
GO
CREATE TRIGGER TRG_ThamGiaDA
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ChuyenGia_DuAn
        WHERE MaDuAn = (SELECT MaDuAn FROM Inserted)
        AND VaiTro = (SELECT VaiTro FROM Inserted)
        AND MaChuyenGia <> (SELECT MaChuyenGia FROM Inserted)
    )
    BEGIN
        PRINT N'Không thể thêm chuyên gia với cùng vai trò vào dự án.';
        DELETE FROM ChuyenGia_DuAn WHERE MaDuAn = (SELECT MaDuAn FROM Inserted) AND VaiTro = (SELECT VaiTro FROM Inserted);
    END;
END;


-- 137. Tạo trigger để đảm bảo khi xóa chuyên gia khỏi dự án, không có tác động đến bảng ChuyenGia.
GO
CREATE TRIGGER TRG_XoaCGDuAn
ON ChuyenGia_DuAn
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ChuyenGia
        WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM Deleted)
    )
    BEGIN
        PRINT N'Không thể xóa chuyên gia khỏi dự án vì chuyên gia vẫn tồn tại trong bảng Chuyên gia.';
    END
    ELSE
    BEGIN
        PRINT N'Chuyên gia đã được xóa khỏi dự án.';
    END;
END;

-- 138. Tạo trigger để đảm bảo không có chuyên gia nào tham gia vào dự án đã hoàn thành.
GO
CREATE TRIGGER TRG_DuAnHT
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DuAn
        WHERE MaDuAn = (SELECT MaDuAn FROM Inserted)
        AND TrangThai = N'Hoàn thành'
    )
    BEGIN
        PRINT N'Không thể thêm chuyên gia vào dự án đã hoàn thành.';
        DELETE FROM ChuyenGia_DuAn WHERE MaDuAn = (SELECT MaDuAn FROM Inserted);
    END;
END;

-- 139. Tạo trigger để đảm bảo không có chuyên gia nào có vai trò "Trưởng nhóm" trong dự án đã hoàn thành.
GO
CREATE TRIGGER TRG_TruongNhomDAHT
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DuAn
        WHERE MaDuAn = (SELECT MaDuAn FROM Inserted)
        AND TrangThai = N'Hoàn thành'
        AND VaiTro = N'Trưởng nhóm'
    )
    BEGIN
        PRINT N'Không thể thêm Trưởng nhóm vào dự án đã hoàn thành.';
        DELETE FROM ChuyenGia_DuAn WHERE MaDuAn = (SELECT MaDuAn FROM Inserted) AND VaiTro = N'Trưởng nhóm';
    END;
END;

-- 140. Tạo trigger để đảm bảo không có chuyên gia tham gia vào dự án có trạng thái "Đã hủy".
GO
CREATE TRIGGER TRG_TrangThaiDuAan
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DuAn
        WHERE MaDuAn = (SELECT MaDuAn FROM Inserted)
        AND TrangThai = N'Đã hủy'
    )
    BEGIN
        PRINT N'Không thể thêm chuyên gia vào dự án đã hủy.';
        DELETE FROM ChuyenGia_DuAn WHERE MaDuAn = (SELECT MaDuAn FROM Inserted);
    END;
END;
