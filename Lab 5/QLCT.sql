-- 101. Tạo một trigger để tự động cập nhật trường NgayCapNhat trong bảng ChuyenGia mỗi khi có sự thay đổi thông tin.
ALTER TABLE ChuyenGia ADD NgayCapNhat DATETIME;
GO 
CREATE TRIGGER trg_UpdateNgayCapNhat
ON ChuyenGia
AFTER UPDATE
AS
BEGIN
    UPDATE ChuyenGia
    SET NgayCapNhat = GETDATE()
    FROM ChuyenGia INNER JOIN Inserted ON ChuyenGia.MaChuyenGia = Inserted.MaChuyenGia;
END;

-- 102. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng DuAn.
CREATE TABLE Log_DuAn (
    LogID INT IDENTITY PRIMARY KEY,
    MaDuAn INT,
    ThaoTac NVARCHAR(50),
    NgayThucHien DATETIME DEFAULT GETDATE()
);
GO 
CREATE TRIGGER trg_LogDuAn
ON DuAn
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM Inserted) AND EXISTS (SELECT * FROM Deleted)
        INSERT INTO Log_DuAn (MaDuAn, ThaoTac) VALUES ((SELECT MaDuAn FROM Inserted), N'Cập nhật');
    ELSE IF EXISTS (SELECT * FROM Inserted)
        INSERT INTO Log_DuAn (MaDuAn, ThaoTac) VALUES ((SELECT MaDuAn FROM Inserted), N'Thêm mới');
    ELSE IF EXISTS (SELECT * FROM Deleted)
        INSERT INTO Log_DuAn (MaDuAn, ThaoTac) VALUES ((SELECT MaDuAn FROM Deleted), N'Xóa');
END;
GO

-- 103. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER trg_LimitDuAnChuyenGia
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
        RAISERROR (N'Một chuyên gia không thể tham gia quá 5 dự án cùng lúc.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

-- 104. Tạo một trigger để tự động cập nhật số lượng nhân viên trong bảng CongTy mỗi khi có sự thay đổi trong bảng ChuyenGia.
GO
CREATE TRIGGER trg_UpdateSoNhanVien
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
GO

-- 105. Tạo một trigger để ngăn chặn việc xóa các dự án đã hoàn thành.
CREATE TRIGGER trg_PreventDeleteCompletedDuAn
ON DuAn
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Deleted
        WHERE TrangThai = N'Hoàn thành'
    )
    BEGIN
        RAISERROR (N'Không thể xóa các dự án đã hoàn thành.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        DELETE FROM DuAn
        WHERE MaDuAn IN (SELECT MaDuAn FROM Deleted);
    END;
END;
GO

-- 106. Tạo một trigger để tự động cập nhật cấp độ kỹ năng của chuyên gia khi họ tham gia vào một dự án mới.
CREATE TRIGGER trg_UpdateCapDoKyNang
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    UPDATE ChuyenGia_KyNang
    SET CapDo = CapDo + 1
    FROM ChuyenGia_KyNang
    INNER JOIN Inserted ON ChuyenGia_KyNang.MaChuyenGia = Inserted.MaChuyenGia;
END;
GO

-- 107. Tạo một trigger để ghi log mỗi khi có sự thay đổi cấp độ kỹ năng của chuyên gia.
CREATE TABLE Log_CapDoKyNang (
    LogID INT IDENTITY PRIMARY KEY,
    MaChuyenGia INT,
    MaKyNang INT,
    CapDoCu INT,
    CapDoMoi INT,
    NgayThucHien DATETIME DEFAULT GETDATE()
);
CREATE TRIGGER trg_LogCapDoKyNang
ON ChuyenGia_KyNang
AFTER UPDATE
AS
BEGIN
    INSERT INTO Log_CapDoKyNang (MaChuyenGia, MaKyNang, CapDoCu, CapDoMoi)
    SELECT d.MaChuyenGia, d.MaKyNang, d.CapDo, i.CapDo
    FROM Deleted d
    INNER JOIN Inserted i ON d.MaChuyenGia = i.MaChuyenGia AND d.MaKyNang = i.MaKyNang;
END;
GO

-- 108. Tạo một trigger để đảm bảo rằng ngày kết thúc của dự án luôn lớn hơn ngày bắt đầu.
CREATE TRIGGER trg_CheckNgayDuAn
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
        RAISERROR (N'Ngày kết thúc phải lớn hơn ngày bắt đầu.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- 109. Tạo một trigger để tự động xóa các bản ghi liên quan trong bảng ChuyenGia_KyNang khi một kỹ năng bị xóa.
CREATE TRIGGER trg_DeleteKyNang
ON KyNang
AFTER DELETE
AS
BEGIN
    DELETE FROM ChuyenGia_KyNang
    WHERE MaKyNang IN (SELECT MaKyNang FROM Deleted);
END;
GO

-- 110. Tạo một trigger để đảm bảo rằng một công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.
CREATE TRIGGER trg_LimitDuAnCongTy
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
        RAISERROR (N'Một công ty không thể có quá 10 dự án đang thực hiện.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
