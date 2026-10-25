/*
    PHAN VIEW - QUAN LY NHAN SU VA LUONG - CONG TY OLOGN TECHNOLOGY
    Yeu cau: it nhat 3 view. File nay co 4 view.
    Chay file QuanLyNhanSuLuong_OlognTechnology.sql truoc de co bang va du lieu.
*/
USE QLNhanSuLuong_OlognTechnology;
GO

-- VIEW 1: Danh sach nhan vien kem phong ban, chuc vu
-- Muc dich: tra cuu thong tin nhan vien day du ma khong can JOIN thu cong.
CREATE OR ALTER VIEW dbo.vw_DanhSachNhanVien
AS
SELECT nv.MaNV, nv.HoTen, nv.NgaySinh, nv.GioiTinh,
       nv.SoDienThoai, nv.Email, nv.NgayVaoLam,
       pb.MaPB, pb.TenPB, cv.MaCV, cv.TenCV, nv.TrangThai
FROM dbo.NhanVien AS nv
JOIN dbo.PhongBan AS pb ON nv.MaPB = pb.MaPB
JOIN dbo.ChucVu AS cv ON nv.MaCV = cv.MaCV;
GO

-- VIEW 2: Hop dong cua nhan vien
-- Muc dich: xem loai hop dong, thoi han, luong co ban theo tung nhan vien.
CREATE OR ALTER VIEW dbo.vw_HopDongNhanVien
AS
SELECT hd.MaHD, nv.MaNV, nv.HoTen, pb.TenPB,
       hd.LoaiHopDong, hd.NgayBatDau, hd.NgayKetThuc,
       hd.LuongCoBan, hd.TrangThai
FROM dbo.HopDong AS hd
JOIN dbo.NhanVien AS nv ON hd.MaNV = nv.MaNV
JOIN dbo.PhongBan AS pb ON nv.MaPB = pb.MaPB;
GO

-- VIEW 3: Chi tiet bang luong
-- Muc dich: phieu luong day du (cong, phu cap, thuong, khau tru, thuc nhan).
CREATE OR ALTER VIEW dbo.vw_ChiTietBangLuong
AS
SELECT bl.MaBangLuong, bl.MaNV, nv.HoTen, pb.TenPB,
       bl.Thang, bl.Nam, bl.SoNgayCong,
       bl.LuongCoBan, bl.TienLuongNgayCong,
       bl.TongPhuCap, bl.TongThuong, bl.TongKhauTru,
       bl.LuongThucNhan, bl.TrangThai, bl.NgayTinh
FROM dbo.BangLuong AS bl
JOIN dbo.NhanVien AS nv ON bl.MaNV = nv.MaNV
JOIN dbo.PhongBan AS pb ON nv.MaPB = pb.MaPB;
GO

-- VIEW 4: Tong luong theo phong ban
-- Muc dich: thong ke so nhan vien va tong chi luong cua tung phong ban moi ky.
CREATE OR ALTER VIEW dbo.vw_TongLuongPhongBan
AS
SELECT bl.Thang, bl.Nam, pb.MaPB, pb.TenPB,
       COUNT(*) AS SoNhanVienCoLuong,
       SUM(bl.LuongThucNhan) AS TongLuongThucNhan
FROM dbo.BangLuong AS bl
JOIN dbo.NhanVien AS nv ON bl.MaNV = nv.MaNV
JOIN dbo.PhongBan AS pb ON nv.MaPB = pb.MaPB
GROUP BY bl.Thang, bl.Nam, pb.MaPB, pb.TenPB;
GO

-- CAC LENH KIEM TRA
-- 1. Toan bo nhan vien (du lieu mau: 4 dong)
SELECT * FROM dbo.vw_DanhSachNhanVien ORDER BY MaNV;

-- 2. Nhan vien thuoc Phong Cong nghe thong tin (mau: NV001, NV002)
SELECT MaNV, HoTen, TenCV FROM dbo.vw_DanhSachNhanVien
WHERE MaPB = 'PB01';

-- 3. Hop dong dang hieu luc (mau: HD001 - HD004)
SELECT * FROM dbo.vw_HopDongNhanVien
WHERE TrangThai = N'Hiệu lực' ORDER BY MaHD;

-- 4. Phieu luong thang 09/2026 (mau: NV001 = 16,100,000; NV002 = 11,576,923.08;
--    NV003 = 11,576,923.08; NV004 = 10,850,000)
SELECT MaNV, HoTen, SoNgayCong, TienLuongNgayCong,
       TongPhuCap, TongThuong, TongKhauTru, LuongThucNhan
FROM dbo.vw_ChiTietBangLuong
WHERE Thang = 9 AND Nam = 2026 ORDER BY MaNV;

-- 5. Tong luong theo phong ban (mau: PB01 = 27,676,923.08; PB02 = 11,576,923.08;
--    PB03 = 10,850,000)
SELECT * FROM dbo.vw_TongLuongPhongBan
WHERE Thang = 9 AND Nam = 2026 ORDER BY MaPB;

-- 6. Nhan vien co luong thuc nhan cao nhat thang 09/2026
SELECT TOP (1) MaNV, HoTen, LuongThucNhan
FROM dbo.vw_ChiTietBangLuong
WHERE Thang = 9 AND Nam = 2026
ORDER BY LuongThucNhan DESC;
GO
