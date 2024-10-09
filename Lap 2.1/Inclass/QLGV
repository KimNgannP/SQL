SET DATEFORMAT DMY

-- Nhập dữ liệu cho bảng KHOA
INSERT INTO KHOA (MAKHOA, TENKHOA, NGTLAP, TRGKHOA)
VALUES 
('KHMT','Khoa hoc may tinh','06/07/2005','GV01'),
('HTTT','He thong thong tin','06/07/2005','GV02'),
('CNPM','Cong nghe phan mem','06/07/2005','GV04'),
('MTT','Mang va truyen thong','20/10/2005','GV03'),
('KTMT','Ky thuat may tinh','20/12/2005','Null')


--Nhập dữ liệu cho bảng MONHOC
INSERT INTO MONHOC (MAMH, TENMH, TCLT, TCTH, MAKHOA)
VALUES
('THDC','Tin hoc dai cuong',4,1,'KHMT'),
('CTRR','Cau truc roi rac',5,0,'KHMT'),
('CSDL','Co so du lieu',3,1,'HTTT'),
('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT'),
('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT'),
('DHMT','Do hoa may tinh',3,1,'KHMT'),
('KTMT','Kien truc may tinh',3,0,'KTMT'),
('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT'),
('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT'),
('HDH','He dieu hanh',4,0,'KTMT'),
('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM'),
('LTCFW','Lap trinh C for win',3,1,'CNPM'),
('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')


-- Nhập dữ liệu cho bảng DIEUKIEN
INSERT INTO DIEUKIEN (MAMH, MAMH_TRUOC)
VALUES
('CSDL','CTRR'),
('CSDL','CTDLGT'),
('CTDLGT','THDC'),
('PTTKTT','THDC'),
('PTTKTT','CTDLGT'),
('DHMT','THDC'),
('LTHDT','THDC'),
('PTTKHTTT','CSDL')


-- Nhập dữ liệu cho bảng GIAOVIEN
INSERT INTO GIAOVIEN (MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH, NGSINH, NGVL, HESO, MUCLUONG, MAKHOA)
VALUES
('GV01','Ho Thanh Son','PTS','GS','Nam','05/02/1950','01/11/2004',5,2250000,'KHMT'),
('GV02','Tran Tam Thanh','TS','PGS','Nam','17/12/1965','20/4/2004',4.5,2025000,'HTTT'),
('GV03','Do Nghiem Phung','TS','GS','Nu','08/01/1950','23/9/2004',4,1800000,'CNPM'),
('GV04','Tran Nam Son','TS','PGS','Nam','22/2/1961','01/12/2005',4.5,2025000,'KTMT'),
('GV05','Mai Thanh Danh','ThS','GV','Nam','03/12/1958','01/12/2005',3,1350000,'HTTT'),
('GV06','Tran Doan Hung','TS','GV','Nam','03/11/1953','01/12/2005',4.5,2025000,'KHMT'),
('GV07','Nguyen Minh Tien','ThS','GV','Nam','23/11/1971','03/01/2005',4,1800000,'KHMT'),
('GV08','Le Thi Tran','KS','Null','Nu','26/3/1974','03/01/2005',1.69,760500,'KHMT'),
('GV09','Nguyen To Lan','ThS','GV','Nu','31/12/1966','03/01/2005',4,1800000,'HTTT'),
('GV10','Le Tran Anh Loan','KS','Null','Nu','17/7/1972','03/01/2005',1.86,837000,'CNPM'),
('GV11','Ho Thanh Tung','CN','GV','Nam','01/12/1980','15/5/2005',2.67,1201500,'MTT'),
('GV12','Tran Van Anh','CN','Null','Nu','29/3/1981','15/5/2005',1.69,760500,'CNPM'),
('GV13','Nguyen Linh Dan','CN','Null','Nu','23/5/1980','15/5/2005',1.69,760500,'KTMT'),
('GV14','Truong Minh Chau','ThS','GV','Nu','30/11/1976','15/5/2005',3,1350000,'MTT'),
('GV15','Le Ha Thanh','ThS','GV','Nam','05/04/1978','15/5/2005',3,1350000,'KHMT')


-- Nhập dữ liệu cho bảng LOP
INSERT INTO LOP (MALOP, TENLOP, TRGLOP, SISO, MAGVCN)
VALUES
('K11','Lop 1 khoa 1','K1108',11,'GV07'),
('K12','Lop 2 khoa 1','K1205',12,'GV09'),
('K13','Lop 3 khoa 1','K1305',12,'GV14')


--Nhập dữ liệu cho bảng HOCVIEN
INSERT INTO HOCVIEN (MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP)
VALUES
('K1101','Nguyen Van','A','27/1/1986','Nam','TpHCM','K11'),
('K1102','Tran Ngoc','Han','14/3/1986','Nu','Kien Giang','K11'),
('K1103','Ha Duy','Lap','18/4/1986','Nam','Nghe An','K11'),
('K1104','Tran Ngoc','Linh','30/3/1986','Nu','Tay Ninh','K11'),
('K1105','Tran Minh','Long','27/2/1986','Nam','TpHCM','K11'),
('K1106','Le Nhat','Minh','24/1/1986','Nam','TpHCM','K11'),
('K1107','Nguyen Nhu','Nhut','27/1/1986','Nam','Ha Noi','K11'),
('K1108','Nguyen Manh','Tam','27/2/1986','Nam','Kien Giang','K11'),
('K1109','Phan Thi Thanh','Tam','27/1/1986','Nu','Vinh Long','K11'),
('K1110','Le Hoai','Thuong','02/05/1986','Nu','Can Tho','K11'),
('K1111','Le Ha','Vinh','25/12/1986','Nam','Vinh Long','K11'),
('K1201','Nguyen Van','B','02/11/1986','Nam','TpHCM','K12'),
('K1202','Nguyen Thi Kim','Duyen','18/1/1986','Nu','TpHCM','K12'),
('K1203','Tran Thi Kim','Duyen','17/9/1986','Nu','TpHCM','K12'),
('K1204','Truong My','Hanh','19/5/1986','Nu','Dong Nai','K12'),
('K1205','Nguyen Thanh','Nam','17/4/1986','Nam','TpHCM','K12'),
('K1206','Nguyen Thi Truc','Thanh','03/04/1986','Nu','Kien Giang','K12'),
('K1207','Tran Thi Bich','Thuy','02/08/1986','Nu','Nghe An','K12'),
('K1208','Huynh Thi Kim','Trieu','04/08/1986','Nu','Tay Ninh','K12'),
('K1209','Pham Thanh','Trieu','23/2/1986','Nam','TpHCM','K12'),
('K1210','Ngo Thanh','Tuan','14/2/1986','Nam','TpHCM','K12'),
('K1211','Do Thi','Xuan','03/09/1986','Nu','Ha Noi','K12'),
('K1212','Le Thi Phi','Yen','03/12/1986','Nu','TpHCM','K12'),
('K1301','Nguyen Thi Kim','Cuc','06/09/1986','Nu','Kien Giang','K13'),
('K1302','Truong Thi My','Hien','18/3/1986','Nu','Nghe An','K13'),
('K1303','Le Duc','Hien','21/3/1986','Nam','Tay Ninh','K13'),
('K1304','Le Quang','Hien','18/4/1986','Nam','TpHCM','K13'),
('K1305','Le Thi','Huong','27/3/1986','Nu','TpHCM','K13'),
('K1306','Nguyen Thai','Huu','30/3/1986','Nam','Ha Noi','K13'),
('K1307','Tran Minh','Man','28/5/1986','Nam','TpHCM','K13'),
('K1308','Nguyen Hieu','Nghia','04/08/1986','Nam','Kien Giang','K13'),
('K1309','Nguyen Trung','Nghia','18/1/1987','Nam','Nghe An','K13'),
('K1310','Tran Thi Hong','Tham','22/4/1986','Nu','Tay Ninh','K13'),
('K1311','Tran Minh','Thuc','04/04/1986','Nam','TpHCM','K13'),
('K1312','Nguyen Thi Kim','Yen','09/07/1986','Nu','TpHCM','K13')


-- Nhập dữ liệu cho bảng GIANGDAY
INSERT INTO GIANGDAY (MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY)
VALUES
('K11','THDC','GV07',1,2006,'01/02/2006','05/12/2006'),
('K12','THDC','GV06',1,2006,'01/02/2006','05/12/2006'),
('K13','THDC','GV15',1,2006,'01/02/2006','05/12/2006'),
('K11','CTRR','GV02',1,2006,'09/01/2006','17/5/2006'),
('K12','CTRR','GV02',1,2006,'09/01/2006','17/5/2006'),
('K13','CTRR','GV08',1,2006,'09/01/2006','17/5/2006'),
('K11','CSDL','GV05',2,2006,'06/01/2006','15/7/2006'),
('K12','CSDL','GV09',2,2006,'06/01/2006','15/7/2006'),
('K13','CTDLGT','GV15',2,2006,'06/01/2006','15/7/2006'),
('K13','CSDL','GV05',3,2006,'08/01/2006','15/12/2006'),
('K13','DHMT','GV07',3,2006,'08/01/2006','15/12/2006'),
('K11','CTDLGT','GV15',3,2006,'08/01/2006','15/12/2006'),
('K12','CTDLGT','GV15',3,2006,'08/01/2006','15/12/2006'),
('K11','HDH','GV04',1,2007,'01/02/2007','18/2/2007'),
('K12','HDH','GV04',1,2007,'01/02/2007','20/3/2007'),
('K11','DHMT','GV07',1,2007,'18/2/2007','20/3/2007')


-- Nhập dữ liệu cho bảng KETQUATHI
INSERT INTO KETQUATHI (MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA)
VALUES
('K1101','CSDL',1,'20/7/2006',10,'Dat'),
('K1101','CTDLGT',1,'28/12/2006',9,'Dat'),
('K1101','THDC',1,'20/5/2006',9,'Dat'),
('K1101','CTRR',1,'13/5/2006',9.5,'Dat'),
('K1102','CSDL',1,'20/7/2006',4,'Khong Dat'),
('K1102','CSDL',2,'27/7/2006',4.25,'Khong Dat'),
('K1102','CSDL',3,'08/10/2006',4.5,'Khong Dat'),
('K1102','CTDLGT',1,'28/12/2006',4.5,'Khong Dat'),
('K1102','CTDLGT',2,'01/05/2007',4,'Khong Dat'),
('K1102','CTDLGT',3,'15/1/2007',6,'Dat'),
('K1102','THDC',1,'20/5/2006',5,'Dat'),
('K1102','CTRR',1,'13/5/2006',7,'Dat'),
('K1103','CSDL',1,'20/7/2006',3.5,'Khong Dat'),
('K1103','CSDL',2,'27/7/2006',8.25,'Dat'),
('K1103','CTDLGT',1,'28/12/2006',7,'Dat'),
('K1103','THDC',1,'20/5/2006',8,'Dat'),
('K1103','CTRR',1,'13/5/2006',6.5,'Dat'),
('K1104','CSDL',1,'20/7/2006',3.75,'Khong Dat'),
('K1104','CTDLGT',1,'28/12/2006',4,'Khong Dat'),
('K1104','THDC',1,'20/5/2006',4,'Khong Dat'),
('K1104','CTRR',1,'13/5/2006',4,'Khong Dat'),
('K1104','CTRR',2,'20/5/2006',3.5,'Khong Dat'),
('K1104','CTRR',3,'30/6/2006',4,'Khong Dat'),
('K1201','CSDL',1,'20/7/2006',6,'Dat'),
('K1201','CTDLGT',1,'28/12/2006',5,'Dat'),
('K1201','THDC',1,'20/5/2006',8.5,'Dat'),
('K1201','CTRR',1,'13/5/2006',9,'Dat'),
('K1202','CSDL',1,'20/7/2006',8,'Dat'),
('K1202','CTDLGT',1,'28/12/2006',4,'Khong Dat'),
('K1202','CTDLGT',2,'01/05/2007',5,'Dat'),
('K1202','THDC',1,'20/5/2006',4,'Khong Dat'),
('K1202','THDC',2,'27/5/2006',4,'Khong Dat'),
('K1202','CTRR',1,'13/5/2006',3,'Khong Dat'),
('K1202','CTRR',2,'20/5/2006',4,'Khong Dat'),
('K1202','CTRR',3,'30/6/2006',6.25,'Dat'),
('K1203','CSDL',1,'20/7/2006',9.25,'Dat'),
('K1203','CTDLGT',1,'28/12/2006',9.5,'Dat'),
('K1203','THDC',1,'20/5/2006',10,'Dat'),
('K1203','CTRR',1,'13/5/2006',10,'Dat'),
('K1204','CSDL',1,'20/7/2006',8.5,'Dat'),
('K1204','CTDLGT',1,'28/12/2006',6.75,'Dat'),
('K1204','THDC',1,'20/5/2006',4,'Khong Dat'),
('K1204','CTRR',1,'13/5/2006',6,'Dat'),
('K1301','CSDL',1,'20/12/2006',4.25,'Khong Dat'),
('K1301','CTDLGT',1,'25/7/2006',8,'Dat'),
('K1301','THDC',1,'20/5/2006',7.75,'Dat'),
('K1301','CTRR',1,'13/5/2006',8,'Dat'),
('K1302','CSDL',1,'20/12/2006',6.75,'Dat'),
('K1302','CTDLGT',1,'25/7/2006',5,'Dat'),
('K1302','THDC',1,'20/5/2006',8,'Dat'),
('K1302','CTRR',1,'13/5/2006',8.5,'Dat'),
('K1303','CSDL',1,'20/12/2006',4,'Khong Dat'),
('K1303','CTDLGT',1,'25/7/2006',4.5,'Khong Dat'),
('K1303','CTDLGT',2,'08/07/2006',4,'Khong Dat'),
('K1303','CTDLGT',3,'15/8/2006',4.25,'Khong Dat'),
('K1303','THDC',1,'20/5/2006',4.5,'Khong Dat'),
('K1303','CTRR',1,'13/5/2006',3.25,'Khong Dat'),
('K1303','CTRR',2,'20/5/2006',5,'Dat'),
('K1304','CSDL',1,'20/12/2006',7.75,'Dat'),
('K1304','CTDLGT',1,'25/7/2006',9.75,'Dat'),
('K1304','THDC',1,'20/5/2006',5.5,'Dat'),
('K1304','CTRR',1,'13/5/2006',5,'Dat'),
('K1305','CSDL',1,'20/12/2006',9.25,'Dat'),
('K1305','CTDLGT',1,'25/7/2006',10,'Dat'),
('K1305','THDC',1,'20/5/2006',8,'Dat'),
('K1305','CTRR',1,'13/5/2006',10,'Dat')


-- I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language):

-- 11. Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_TUOI CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >= 18)

-- 12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY 
ADD CONSTRAINT CHK_NGAY CHECK(TUNGAY < DENNGAY)

-- 13. Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN 
ADD CONSTRAINT CHK_NGVL CHECK (YEAR(NGVL) - YEAR(NGSINH) >= 22)

-- 14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC 
ADD CONSTRAINT CHK_TC CHECK(ABS(TCLT - TCTH) <= 3)


-- III. Ngôn ngữ truy vấn dữ liệu:

-- 1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, NGSINH, HV.MALOP 
FROM HOCVIEN HV INNER JOIN LOP 
ON HV.MAHV = LOP.TRGLOP

-- 2. In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT HOCVIEN.MAHV, CONCAT(HO,' ',TEN) AS HOTEN, LANTHI, DIEM
FROM KETQUATHI 
INNER JOIN HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE MAMH = 'CTRR' AND MALOP = 'K12'
ORDER BY HOTEN 

-- 3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT HOCVIEN.MAHV , CONCAT(HO,' ',TEN) AS HOTEN,MONHOC.MAMH, MONHOC.TENMH
FROM KETQUATHI
INNER JOIN HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV
INNER JOIN MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH 
WHERE LANTHI = 1 AND DIEM >= 5
ORDER BY MAHV 

-- 4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HOCVIEN.MAHV, CONCAT(HO,' ',TEN) AS HOTEN 
FROM KETQUATHI 
INNER JOIN HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE MAMH = 'CTRR' AND MALOP = 'K11' AND DIEM < 5 AND LANTHI = 1

-- 5. Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT HOCVIEN.MAHV, CONCAT(HO, ' ', TEN) AS HOTEN 
FROM HOCVIEN 
WHERE HOCVIEN.MAHV NOT IN (
    SELECT MAHV 
    FROM KETQUATHI 
    WHERE MAMH = 'CTRR' AND DIEM >= 5
)
