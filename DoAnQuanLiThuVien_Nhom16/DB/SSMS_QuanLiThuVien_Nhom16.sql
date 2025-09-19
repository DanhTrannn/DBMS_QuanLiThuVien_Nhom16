CREATE DATABASE QLThuVien;
GO

USE QLThuVien;
GO

-- 1. Bảng Sách
CREATE TABLE Sach (
    MaSach INT PRIMARY KEY IDENTITY,
    TenSach NVARCHAR(255) NOT NULL,
    TacGia NVARCHAR(255) NOT NULL,
    TheLoai NVARCHAR(100) NOT NULL,
    NhaXuatBan NVARCHAR(255) NOT NULL,
    NamXuatBan INT NOT NULL CHECK (NamXuatBan >= 1900 AND NamXuatBan <= YEAR(GETDATE()))
);

-- 2. Bảng Kho Sách
CREATE TABLE KhoSach (
    MaSach INT PRIMARY KEY,
    SoLuongTon INT NOT NULL CHECK (SoLuongTon >= 0),
    CONSTRAINT FK_KhoSach_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON delete cascade
);

-- 3. Bảng Phiếu Nhập
CREATE TABLE PhieuNhap (
    MaPN INT PRIMARY KEY IDENTITY,
    NgayNhap DATE NOT NULL CHECK (NgayNhap <= GETDATE()),
    NhaCungCap NVARCHAR(255) NOT NULL
);

-- 4. Bảng Chi Tiết Nhập
CREATE TABLE ChiTietNhap (
    MaPN INT NOT NULL,
    MaSach INT,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    PRIMARY KEY (MaPN, MaSach),
    CONSTRAINT FK_ChiTietNhap_PhieuNhap FOREIGN KEY (MaPN) REFERENCES PhieuNhap(MaPN) ON DELETE cascade,      
    CONSTRAINT FK_ChiTietNhap_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)   
);

-- 5. Bảng Phiếu Xuất
CREATE TABLE PhieuXuat (
    MaPX INT PRIMARY KEY IDENTITY,
    NgayXuat DATE NOT NULL CHECK (NgayXuat <= GETDATE()),
    LyDoXuat NVARCHAR(255) NOT NULL
);

-- 6. Bảng Chi Tiết Xuất
CREATE TABLE ChiTietXuat (
    MaPX INT NOT NULL,
    MaSach INT,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    PRIMARY KEY (MaPX, MaSach),
    CONSTRAINT FK_ChiTietXuat_PhieuXuat FOREIGN KEY (MaPX) REFERENCES PhieuXuat(MaPX) ON DELETE cascade,       
    CONSTRAINT FK_ChiTietXuat_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)    
);

INSERT INTO Sach (TenSach, TacGia, TheLoai, NhaXuatBan, NamXuatBan)
VALUES 
('Lập Trình C#', 'Nguyễn Văn A', 'CNTT', 'NXB Trẻ', 2021),
('Học SQL Server', 'Trần Thị B', 'CNTT', 'NXB Giáo Dục', 2020),
('Python cho người mới', 'Lê Văn C', 'CNTT', 'NXB Tổng Hợp', 2022),
('Cấu trúc dữ liệu', 'Nguyễn Thị D', 'CNTT', 'NXB Đại Học', 2019),
('Thiết kế Web với HTML & CSS', 'Phạm Văn E', 'CNTT', 'NXB Trẻ', 2021),
('Java nâng cao', 'Lê Thị F', 'CNTT', 'NXB Giáo Dục', 2020),
('Machine Learning cơ bản', 'Trần Văn G', 'CNTT', 'NXB Tổng Hợp', 2022),
('Kỹ năng mềm cho lập trình viên', 'Nguyễn Văn H', 'Giáo dục kỹ năng', 'NXB Trẻ', 2021),
('Học React JS', 'Lê Văn I', 'CNTT', 'NXB Đại Học', 2023),
('Big Data và Hadoop', 'Trần Thị J', 'CNTT', 'NXB Giáo Dục', 2022);

-- Giả sử MaSach từ 1 đến 10
INSERT INTO KhoSach (MaSach, SoLuongTon)
VALUES 
(1, 20),
(2, 15),
(3, 25),
(4, 10),
(5, 18),
(6, 12),
(7, 30),
(8, 8),
(9, 14),
(10, 22);

INSERT INTO PhieuNhap (NgayNhap, NhaCungCap)
VALUES
('2025-09-10', 'Công ty Sách ABC'),
('2025-09-11', 'Công ty Sách XYZ'),
('2025-09-12', 'Công ty Sách LMN'),
('2025-09-13', 'Công ty Sách PQR'),
('2025-09-14', 'Công ty Sách DEF');

INSERT INTO ChiTietNhap (MaPN, MaSach, SoLuong)
VALUES
(1, 1, 5),
(1, 2, 3),
(1, 3, 10),
(2, 2, 5),
(2, 4, 2),
(2, 5, 7),
(3, 1, 3),
(3, 6, 4),
(3, 7, 6),
(4, 8, 2),
(4, 9, 5),
(5, 10, 10),
(5, 3, 5),
(5, 5, 4);

INSERT INTO PhieuXuat (NgayXuat, LyDoXuat)
VALUES
('2025-09-15', 'Phục vụ dự án nghiên cứu'),
('2025-09-16', 'Tặng đối tác'),
('2025-09-17', 'Sách hỏng'),
('2025-09-18', 'Phục vụ hội thảo'),
('2025-09-19', 'Xuất sách cho phòng đọc thư viện');

INSERT INTO ChiTietXuat (MaPX, MaSach, SoLuong)
VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 3),
(2, 4, 1),
(3, 5, 2),
(3, 6, 1),
(4, 8, 1),
(4, 9, 2),
(5, 1, 1),
(5, 10, 5);

CREATE VIEW View_SachKho AS
SELECT 
    s.MaSach,
    s.TenSach,
    s.TacGia,
    s.TheLoai,
    s.NhaXuatBan,
    s.NamXuatBan,
    k.SoLuongTon
FROM Sach s
JOIN KhoSach k ON s.MaSach = k.MaSach;

select * from View_SachKho;

CREATE VIEW View_ChiTietNhap AS
SELECT 
    pn.MaPN,
    pn.NgayNhap,
    pn.NhaCungCap,
    s.MaSach,
    s.TenSach,
    ctn.SoLuong
FROM PhieuNhap pn
JOIN ChiTietNhap ctn ON pn.MaPN = ctn.MaPN
JOIN Sach s ON ctn.MaSach = s.MaSach;

select * from View_ChiTietNhap;

CREATE VIEW View_ChiTietXuat AS
SELECT 
    px.MaPX,
    px.NgayXuat,
    px.LyDoXuat,
    s.MaSach,
    s.TenSach,
    ctx.SoLuong
FROM PhieuXuat px
JOIN ChiTietXuat ctx ON px.MaPX = ctx.MaPX
JOIN Sach s ON ctx.MaSach = s.MaSach;

select * from View_ChiTietXuat;

CREATE VIEW View_TongNhapXuat AS
SELECT 
    s.MaSach,
    s.TenSach,
    ISNULL(SUM(ctn.SoLuong), 0) AS TongSoLuongNhap,
    ISNULL(SUM(ctx.SoLuong), 0) AS TongSoLuongXuat
FROM Sach s
LEFT JOIN ChiTietNhap ctn ON s.MaSach = ctn.MaSach
LEFT JOIN ChiTietXuat ctx ON s.MaSach = ctx.MaSach
GROUP BY s.MaSach, s.TenSach;

select * from View_TongNhapXuat;