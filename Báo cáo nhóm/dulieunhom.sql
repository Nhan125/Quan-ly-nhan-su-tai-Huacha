create database nhom3
use nhom3

CREATE TABLE ChuQuan
(
	SoCCCD CHAR(12) unique,
	TenChuQuan NVARCHAR(50) NOT NULL,
	TuoiChuQuan INT NOT NULL,
    NoiOHienTai NVARCHAR(50) NOT NULL,
    SoDienThoai CHAR(10) UNIQUE,
    Username CHAR(12) NOT NULL,
    Pass VARCHAR(20) NOT NULL,
	PRIMARY KEY (SoCCCD)
)

--Tao bang NhanVien
CREATE TABLE NhanVien 
(
    MaDangNhap CHAR(12) NOT NULL PRIMARY KEY,
    CCCD CHAR(12) UNIQUE,
    TenNV NVARCHAR(50) NOT NULL,
    TuoiNV INT NOT NULL,
    DiaChi NVARCHAR(60) NOT NULL,
    SDT CHAR(10) UNIQUE,
    SoTaiKhoanNH VARCHAR(20) NOT NULL,
    MatKhau VARCHAR(20) NOT NULL
)

--Tao bang CapBacNV
CREATE TABLE CapBacNV 
(
    MaDangNhap CHAR(12) NOT NULL,
    CapBac CHAR(2) NOT NULL,
    PRIMARY KEY (MaDangNhap),
    FOREIGN KEY (MaDangNhap) REFERENCES NhanVien
)

--Tao bang Luong
Create table Luong 
(	
	MaBangLuong char(4) not null, 
	SoGioLamTrongThang int not null, 
	SoGioBatDauLam int not null, 
	TienLuong int not null,
	primary key (MaBangLuong)
)

--Tao bang LuongNV
Create table LuongNV
(	
	MaDangNhap char(12) not null,
	MaBangLuong char(4) not null,
	primary key (MaDangNhap, MaBangLuong),
	foreign key (MaDangNhap) references NhanVien,
	foreign key (MaBangLuong) references Luong
)

--Tao bang ChamCong
CREATE TABLE ChamCong 
(
	MaBangChamCong CHAR (4) NOT NULL,
	NgayChamCong DATE NOT NULL,
	TGVaoCa DATETIME NOT NULL,
	TGRaCa DATETIME NOT NULL,
	CaLam VARCHAR (10) NOT NULL,
	PRIMARY KEY ( MaBangChamCong )
)

--Tao bang ChamCongNV
CREATE TABLE ChamCongNV
(
	MaBangChamCong CHAR (4) NOT NULL,
	MaDangNhap CHAR (12) NOT NULL,
	PRIMARY KEY ( MaBangChamCong, MaDangNhap ),
	FOREIGN KEY ( MaBangChamCong ) REFERENCES ChamCong,
	FOREIGN KEY ( MaDangNhap ) REFERENCES NhanVien
)

--Tao bang ThongBao
CREATE TABLE ThongBao 
(
    MaTB char(4) not null PRIMARY KEY,
    TenThongBao NVARCHAR(100) not null,
    ThoiGianThongBao DATETIME not null ,
    NoiDungThongBao nvarchar(200) not null 
)

--Tao bang ThongBaoNV
CREATE TABLE ThongBaoNV 
(
    MaTB char(4) not null ,
    MaDangNhap char(12) not null ,
    PRIMARY KEY (MaTB, MaDangNhap),
    FOREIGN KEY (MaTB) REFERENCES ThongBao,
    FOREIGN KEY (MaDangNhap) REFERENCES NhanVien
)

--Tao bang LichLam
CREATE TABLE LichLam 
(
    MaBang char(4) PRIMARY KEY,				
    NgayLam DATE NOT NULL,                   
    CaLam VARCHAR(10) NOT NULL,             
    NgayNghi DATE                            
)
--Tao bang LichLamNV
CREATE TABLE LichLamNV 
(
    MaBang CHAR(4),                             
    MaDangNhap CHAR(12),						
    PRIMARY KEY (MaBang, MaDangNhap),			
    FOREIGN KEY (MaBang) REFERENCES LichLam,
    FOREIGN KEY (MaDangNhap) REFERENCES NhanVien
)

--Tao bang NhanVien 
CREATE PROCEDURE InsertNhanVien
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @MaDangNhap CHAR(12);
    DECLARE @CCCD CHAR(12);
    DECLARE @TenNV NVARCHAR(50); 
    DECLARE @TuoiNV INT;
    DECLARE @DiaChiValue NVARCHAR(60);  -- Renamed variable
    DECLARE @SDT CHAR(10);
    DECLARE @SoTaiKhoanNH VARCHAR(20);
    DECLARE @MatKhau VARCHAR(20);

    DECLARE @FirstNames TABLE (ID INT, Name NVARCHAR(50));
    DECLARE @LastNames TABLE (ID INT, Name NVARCHAR(50));
    DECLARE @DiaChi TABLE (DiaChi NVARCHAR(60));

    INSERT INTO @FirstNames (ID, Name) VALUES
    (1, N'Nguyễn'),
    (2, N'Trần'),
    (3, N'Lê'),
    (4, N'Phạm'),
    (5, N'Ngô'),
    (6, N'Đinh'),
    (7, N'Hồ'),
    (8, N'Tô'),
    (9, N'Bùi'),
    (10, N'Vũ')

    INSERT INTO @LastNames (ID, Name) VALUES
    (1, N'An'),
    (2, N'Bình'),
    (3, N'Chi'),
    (4, N'Duy'),
    (5, N'Hoàng'),
    (6, N'Hương'),
    (7, N'Khánh'),
    (8, N'Linh'),
    (9, N'Mai'),
    (10, N'Nam')

    INSERT INTO @DiaChi (DiaChi) VALUES 
        (N'Nguyễn Thị Minh Khai'), 
        (N'Đường Lê Lợi'), 
        (N'Đường Trần Hưng Đạo'), 
        (N'Đường Phạm Văn Đồng'), 
        (N'Đường Hoàng Văn Thụ')

    WHILE @Counter <= 1000
    BEGIN
        -- Tạo mã đăng nhập ngẫu nhiên
        SET @MaDangNhap = 'NV' +  RIGHT('0000000000' + cast(@counter as varchar),10)

        -- Tạo số CCCD ngẫu nhiên
        SET @CCCD = RIGHT('000000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(12)), 12);

        -- Tạo tên ngẫu nhiên
        SET @TenNV = (SELECT TOP 1 Name FROM @FirstNames ORDER BY NEWID()) + ' ' +
                      (SELECT TOP 1 Name FROM @LastNames ORDER BY NEWID());

        -- Tạo tuổi ngẫu nhiên từ 18 đến 60
        SET @TuoiNV = ABS(CHECKSUM(NEWID()) % 8) + 18;

        -- Tạo địa chỉ ngẫu nhiên
        SET @DiaChiValue = (SELECT TOP 1 DiaChi FROM @DiaChi ORDER BY
NEWID());

        -- Tạo số điện thoại ngẫu nhiên
        SET @SDT = '0' + RIGHT('0000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(10)), 9);

        -- Tạo số tài khoản ngân hàng ngẫu nhiên
        SET @SoTaiKhoanNH = RIGHT('00000000000000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20)), 20);

        -- Tạo mật khẩu ngẫu nhiên
        SET @MatKhau = LEFT(NEWID(), 8);  -- Mật khẩu dài 8 ký tự

        -- Chèn dữ liệu vào bảng NhanVien
        INSERT INTO NhanVien (MaDangNhap, CCCD, TenNV, TuoiNV, DiaChi, SDT, SoTaiKhoanNH, MatKhau)
        VALUES (@MaDangNhap, @CCCD, @TenNV, @TuoiNV, @DiaChiValue, @SDT, @SoTaiKhoanNH, @MatKhau);

        SET @Counter = @Counter + 1;
    END
END

exec InsertNhanVien
select * from NhanVien

-- Tao bang ChuQuan
CREATE PROCEDURE InsertchuQuan
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @SoCCCD CHAR(12);
    DECLARE @TenChuQuan NVARCHAR(50); 
    DECLARE @TuoiChuQuan INT;
    DECLARE @NoiOHienTai NVARCHAR(50);
    DECLARE @SoDienThoai CHAR(10);
    DECLARE @Username CHAR(12);
    DECLARE @Pass VARCHAR(20);

    DECLARE @FirstNames TABLE (ID INT, Name NVARCHAR(50));
    DECLARE @LastNames TABLE (ID INT, Name NVARCHAR(50));
    DECLARE @DiaChi TABLE (DiaChi NVARCHAR(100));

    INSERT INTO @FirstNames (ID, Name) VALUES
    (1, N'Nguyễn'),
    (2, N'Trần'),
    (3, N'Lê'),
    (4, N'Phạm'),
    (5, N'Ngô'),
    (6, N'Đinh'),
    (7, N'Hồ'),
    (8, N'Tô'),
    (9, N'Bùi'),
    (10, N'Vũ')

    INSERT INTO @LastNames (ID, Name) VALUES
    (1, N'An'),
    (2, N'Bình'),
    (3, N'Chi'),
    (4, N'Duy'),
    (5, N'Hoàng'),
    (6, N'Hương'),
    (7, N'Khánh'),
    (8, N'Linh'),
    (9, N'Mai'),
    (10, N'Nam')

    INSERT INTO @DiaChi (DiaChi) VALUES 
        (N'Nguyễn Thị Minh Khai'), 
        (N'Đường Lê Lợi'), 
        (N'Đường Trần Hưng Đạo'), 
        (N'Đường Phạm Văn Đồng'), 
        (N'Đường Hoàng Văn Thụ')
      
  -- Tạo mã đăng nhập ngẫu nhiên
      WHILE @Counter <= 1000
		BEGIN
			-- Tạo mã đăng nhập ngẫu nhiên
			SET @Username = 'CQ' +  RIGHT('0000000000’' + cast(@counter as varchar),10)

			-- Tạo số CCCD ngẫu nhiên
			SET @SoCCCD = RIGHT('000000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(12)), 12);
	
			-- Tạo tên ngẫu nhiên
			SET @TenChuQuan = (SELECT TOP 1 Name FROM @FirstNames ORDER BY NEWID()) + ' ' +
                           (SELECT TOP 1 Name FROM @LastNames ORDER BY NEWID());

			-- Tạo tuổi ngẫu nhiên từ 18 đến 80
			SET @TuoiChuQuan = ABS(CHECKSUM(NEWID()) % 63) + 18;

			-- Tạo địa chỉ hiện tại ngẫu nhiên
			SET @NoiOHienTai = (SELECT TOP 1 DiaChi FROM @DiaChi ORDER BY NEWID());

			-- Tạo số điện thoại ngẫu nhiên
			SET @SoDienThoai = '0' + RIGHT('0000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(10)), 9);

			-- Tạo username ngẫu nhiên
			SET @Username = RIGHT('000000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(12)), 12);

			-- Tạo mật khẩu ngẫu nhiên
			SET @Pass = LEFT(NEWID(), 8);  -- Mật khẩu dài 8 ký tự

			-- Chèn dữ liệu vào bảng ChuQuan
			INSERT INTO ChuQuan (SoCCCD, TenChuQuan, TuoiChuQuan, NoiOHienTai, SoDienThoai, Username, Pass)
			VALUES (@SoCCCD, @TenChuQuan, @TuoiChuQuan, @NoiOHienTai, @SoDienThoai, @Username, @Pass);

			SET @Counter = @Counter + 1;
		end
END

EXEC InsertChuQuan
select*from ChuQuan

-- Tao bang CapBac
CREATE PROCEDURE CapBac
AS
BEGIN
    DECLARE @Counter INT = 0; -- Đếm số bản ghi đã chèn thành công
    DECLARE @MaDangNhap CHAR(12);
    DECLARE @CapBac CHAR(2);

    -- Giả định các cấp bậc
    DECLARE @CapBacOptions TABLE (CapBac CHAR(2));
    INSERT INTO @CapBacOptions (CapBac) VALUES
    (N'S1'),  -- Cấp thấp nhất với mức lương 15k
    (N'S2'),  -- Cấp thứ 2 với mức lương 17k
    (N'SS');  -- Cấp cao nhất trong nhân viên với mức lương 20k

    WHILE @Counter < 1000
    BEGIN
        -- Chọn ngẫu nhiên MaDangNhap từ bảng NhanVien
        SET @MaDangNhap = (SELECT TOP 1 MaDangNhap FROM NhanVien ORDER BY NEWID());

        -- Chọn ngẫu nhiên cấp bậc từ danh sách
        SET @CapBac = (SELECT TOP 1 CapBac FROM @CapBacOptions ORDER BY NEWID());

        -- Chèn dữ liệu vào bảng CapBacNV
        BEGIN TRY
            INSERT INTO CapBacNV (MaDangNhap, CapBac)
            VALUES (@MaDangNhap, @CapBac);
            SET @Counter = @Counter + 1; -- Tăng biến đếm chỉ khi chèn thành công
        END TRY
        BEGIN CATCH
            -- Nếu chèn thất bại do trùng lặp, bỏ qua và tiếp tục
            -- Không cần làm gì ở đây, chỉ cần tiếp tục vòng lặp
        END CATCH
    END
END

exec capbac
select * from CapBacNV

-- Tao bang LichLam
CREATE PROCEDURE TaoDuLieuLichLam
AS
BEGIN
    DECLARE @i INT = 0;  -- Bắt đầu từ 0 để tạo ngày làm việc từ năm 2024
    DECLARE @Ca INT;
    DECLARE @MaBang CHAR(4);
    DECLARE @NgayLam DATE;
    DECLARE @CaLam NVARCHAR(10);
    DECLARE @NgayNghi DATE;

    -- Vòng lặp để tạo dữ liệu cho từng ngày làm việc từ 01/01/2024 đến 31/12/2024
    WHILE @i < 366  -- Tổng cộng có 366 ngày trong năm 2024 (năm nhuận)
    BEGIN
        SET @NgayLam = DATEADD(DAY, @i, '2024-01-01'); -- Bắt đầu từ ngày 01/01/2024

        -- Lặp qua từng ca (1: Sáng, 2: Chiều, 3: Tối) cho mỗi ngày
        SET @Ca = 1;
        WHILE @Ca <= 3
        BEGIN
            -- Cập nhật MaBang với định dạng 4 ký tự, bắt đầu từ L001 cho ngày 01/01/2024
            SET @MaBang = 'L' + RIGHT('000' + CAST((@i * 3 + @Ca + 1) AS VARCHAR), 3);

            SET @CaLam = CASE @Ca 
                            WHEN 1 THEN N'Sáng'
                            WHEN 2 THEN N'Chiều'
                            WHEN 3 THEN N'Tối' 
						END

            -- Để NgàyNghi là NULL cho tất cả các ca
            SET @NgayNghi = NULL; 

            -- Chèn dữ liệu vào bảng LichLam
            INSERT INTO LichLam (MaBang, NgayLam, CaLam, NgayNghi)
            VALUES (@MaBang, @NgayLam, @CaLam, @NgayNghi);

            SET @Ca = @Ca + 1;  -- Tăng ca lên 1
        END

        SET @i = @i + 1;  -- Tăng ngày lên 1
    END
END

exec TaoDuLieuLichLam
select*from LichLam

 --Tao Bang LichLamNV
CREATE proc TaoDuLieuLichLamNV
AS
BEGIN
    DECLARE @SoLuongLich INT = (SELECT COUNT(*) FROM LichLam);
    DECLARE @index INT = 1;
    DECLARE @MaBang CHAR(4);
    DECLARE @MaDangNhap CHAR(12);

    WHILE @index <= @SoLuongLich
    BEGIN
        SET @MaBang = 'L' + RIGHT('000' + CAST(@index AS VARCHAR), 3);

        -- Lấy MaDangNhap ngẫu nhiên từ bảng NhanVien
        SET @MaDangNhap = (SELECT TOP 1 MaDangNhap 
                           FROM NhanVien 
                           ORDER BY NEWID());

        INSERT INTO LichLamNV (MaBang, MaDangNhap)
        VALUES (@MaBang, @MaDangNhap);

        SET @index = @index + 1;  -- Tăng chỉ số lên 1
    END
END

exec TaoDuLieuLichLamNV
select*from LichLamNV

-- Tao Bang ChamCong
CREATE proc TaoDuLieuChamCong
AS
BEGIN
    DECLARE @TGVaoCa DATETIME;
    DECLARE @TGRaCa DATETIME;

    -- Chèn dữ liệu vào bảng ChamCong từ bảng LichLam
    INSERT INTO ChamCong (MaBangChamCong, NgayChamCong, TGVaoCa, TGRaCa, CaLam)
    SELECT 
        MaBang, 
        NgayLam, 
        CASE CaLam
            WHEN N'Sáng' THEN CAST(CONVERT(VARCHAR, NgayLam, 120) + ' 07:00:00' AS DATETIME)
            WHEN N'Chiều' THEN CAST(CONVERT(VARCHAR, NgayLam, 120) + ' 12:00:00' AS DATETIME)
            ELSE CAST(CONVERT(VARCHAR, NgayLam, 120) + ' 17:00:00' AS DATETIME)
        END AS TGVaoCa,
        DATEADD(HOUR, 5, 
            CASE CaLam
                WHEN N'Sáng' THEN CAST(CONVERT(VARCHAR, NgayLam, 120) + ' 07:00:00' AS DATETIME)
                WHEN N'Chiều' THEN CAST(CONVERT(VARCHAR, NgayLam, 120) + ' 12:00:00' AS DATETIME)
                ELSE CAST(CONVERT(VARCHAR, NgayLam, 120) + ' 17:00:00' AS DATETIME)
            END) AS TGRaCa,
        CaLam
    FROM LichLam;

END

EXEC TaoDuLieuChamCong
select*from ChamCong

-- Tao Bang ChamCongNV
CREATE proc TaoDuLieuChamCongNV
AS
BEGIN
    DECLARE @MaBangChamCong CHAR(4);
    DECLARE @MaDangNhap CHAR(12);

    -- Chèn dữ liệu vào bảng ChamCongNV dựa trên bảng ChamCong và LichLam
    INSERT INTO ChamCongNV (MaBangChamCong, MaDangNhap)
    SELECT 
        c.MaBangChamCong,
        n.MaDangNhap
    FROM ChamCong c
    JOIN LichLamNV l ON c.MaBangChamCong = l.MaBang
    JOIN NhanVien n ON l.MaDangNhap = n.MaDangNhap; -- Giả sử l chứa MaDangNhap
END

EXEC TaoDuLieuChamCongNV
select*from ChamCongNV

-- Tao bang Luong

--Hàm tính tiền lương cho nhân viên
CREATE FUNCTION TienLuong (@SoGioLamTrongThang INT, @MaDangNhap CHAR(12))
RETURNS INT
AS
BEGIN
    DECLARE @TienLuong INT, @CapBac CHAR(2), @LuongMoiGio INT;
    
    -- Lấy cấp bậc của nhân viên
    SELECT @CapBac = CapBac FROM CapBacNV WHERE MaDangNhap = @MaDangNhap;
    
    -- Tính lương theo cấp bậc
    SET @LuongMoiGio = CASE 
        WHEN @CapBac = 'S1' THEN 15000
        WHEN @CapBac = 'S2' THEN 17000
        WHEN @CapBac = 'SS' THEN 20000
        ELSE 0  
    END
    
    -- Tính tổng tiền lương
    SET @TienLuong = @SoGioLamTrongThang * @LuongMoiGio
    
    RETURN @TienLuong
END

--trigger Tinh So Gio Lam Trong Thang 
CREATE TRIGGER TinhSoGioLam
ON ChamCong
AFTER INSERT
AS
BEGIN
    DECLARE @MaBangChamCong CHAR(4), @MaBangLuong CHAR(4), @SoGioLamTrongThang INT;

    -- Lấy MaBangChamCong từ inserted
    SELECT @MaBangChamCong = MaBangChamCong FROM inserted;

    -- Lấy MaBangLuong tương ứng với MaBangChamCong
    SELECT TOP 1 @MaBangLuong = Luong.MaBangLuong
    FROM Luong
    JOIN LuongNV ON Luong.MaBangLuong = LuongNV.MaBangLuong
    JOIN ChamCongNV ON LuongNV.MaDangNhap = ChamCongNV.MaDangNhap
    WHERE ChamCongNV.MaBangChamCong = @MaBangChamCong;

    -- Tính số giờ làm trong tháng
    SELECT @SoGioLamTrongThang = SUM(DATEDIFF(HOUR, TGVaoCa, TGRaCa))
    FROM ChamCong
    JOIN ChamCongNV ON ChamCong.MaBangChamCong = ChamCongNV.MaBangChamCong
    WHERE ChamCongNV.MaBangChamCong = @MaBangChamCong
        AND MONTH(ChamCong.NgayChamCong) = MONTH(GETDATE())  
        AND YEAR(ChamCong.NgayChamCong) = YEAR(GETDATE());

    -- Cập nhật số giờ làm trong bảng Luong
    UPDATE Luong
    SET SoGioLamTrongThang = @SoGioLamTrongThang
    WHERE MaBangLuong = @MaBangLuong;
END

CREATE PROC InsertLuong
AS
BEGIN
    DECLARE @MaBangLuong CHAR(4), 
            @SoGioBatDauLam INT, 
            @TienLuong INT, 
            @MaDangNhap CHAR(12), 
            @dem INT = 1, 
            @SoGioLamTrongThang INT;

    WHILE @dem <= 1000 
    BEGIN
        -- Tạo mã bảng lương 
        SET @MaBangLuong = 'S' + RIGHT('000' + CAST(@dem AS VARCHAR), 3);

        -- Kiểm tra mã bảng lương đã tồn tại hay chưa
        WHILE EXISTS (SELECT 1 FROM Luong WHERE MaBangLuong = @MaBangLuong)
        BEGIN
            -- Tạo lại mã bảng lương nếu đã tồn tại
            SET @MaBangLuong = 'S' + RIGHT('000' + CAST(@dem AS VARCHAR), 3);
        END
        
        -- Lấy mã đăng nhập ngẫu nhiên
        SELECT TOP 1 @MaDangNhap = MaDangNhap FROM NhanVien ORDER BY NEWID();

        -- Tạo giờ bắt đầu làm ngẫu nhiên từ 900 đến 10000
        SET @SoGioBatDauLam = FLOOR(900 + (RAND() * 9100));

        -- Tính số giờ làm trong tháng từ bảng ChamCongNV
        SELECT @SoGioLamTrongThang = SUM(DATEDIFF(HOUR, TGVaoCa, TGRaCa))
		FROM ChamCongNV join ChamCong on ChamCong.MaBangChamCong = ChamCongNV.MaBangChamCong
		WHERE MaDangNhap = @MaDangNhap
		  AND MONTH(NgayChamCong) = MONTH(GETDATE())  
		  AND YEAR(NgayChamCong) = YEAR(GETDATE());

		IF @SoGioLamTrongThang IS NULL
			SET @SoGioLamTrongThang = 0;

        -- Tính tiền lương dựa trên số giờ làm
        SET @TienLuong = dbo.TienLuong(@SoGioLamTrongThang, @MaDangNhap);

        -- Chèn thông tin lương vào bảng Luong
        INSERT INTO Luong (MaBangLuong, SoGioLamTrongThang, SoGioBatDauLam, TienLuong)
        VALUES (@MaBangLuong, @SoGioLamTrongThang, @SoGioBatDauLam, @TienLuong);

        SET @dem = @dem + 1;
    END
END

exec InsertLuong
select*from Luong

-- Tao bang LuongNV
create proc InsertLuongNV
as
begin
	declare @MaBangLuong char(4), @MaDangNhap CHAR(12), @dem int = 1
	while @dem  <= 1000
	begin
		set @MaDangNhap = (select top 1 MaDangNhap from NhanVien order by NEWID())
		
		set @MaBangLuong = (select top 1 MaBangLuong from Luong order by NEWID())

		insert into LuongNV ( MaDangNhap, MaBangLuong)
		values (@MaDangNhap, @MaBangLuong)
		set @dem = @dem+ 1
	end
end

exec InsertLuongNV
Select*from Luong

--TaoThongBao
CREATE PROCEDURE TaoDuLieDuLieuThongBao
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @MaTB_moi CHAR(4);
    DECLARE @MaTB_cu CHAR(4);
    DECLARE @TenThongBao NVARCHAR(100);
    DECLARE @NoiDungThongBao NVARCHAR(200);

    DECLARE @ThongBao TABLE (TenThongBao NVARCHAR(100), NoiDungThongBao NVARCHAR(200));
    
    INSERT INTO @ThongBao (TenThongBao, NoiDungThongBao) VALUES
        (N'Thông báo khuyến mãi trà sữa', N'Giảm giá 20% cho các loại trà sữa'),
        (N'Thông báo khai trương cửa hàng mới', N'Khai trương cửa hàng mới tại 225 Lê Thanh Nghị'),
        (N'Thông báo sự kiện âm nhạc', N'Sự kiện âm nhạc vào ngày mai với ca sĩ khách mời '),
        (N'Thông báo chương trình tri ân khách hàng', N'Tri ân khách hàng với nhiều phần quà hấp dẫn'),
        (N'Thông báo ngày hội hoa sen', N'Ngày hội hoa sen với các mã trà sữa từ hoa sen giảm giá 30%');
    set @MaTB_cu = 0001
    IF @MaTB_cu IS NOT NULL
    BEGIN
        SET @MaTB_moi = RIGHT('000' + CAST(CAST(@MaTB_cu AS INT) + 1 AS VARCHAR(4)), 4)
    END
    WHILE @Counter <= 1000
    BEGIN
        -- Chọn một thông báo ngẫu nhiên từ bảng tạm
        SELECT TOP 1 
            @TenThongBao = TenThongBao,
            @NoiDungThongBao = NoiDungThongBao
        FROM @ThongBao
        ORDER BY NEWID();

        -- Chèn thông báo vào bảng ThongBao
        INSERT INTO ThongBao (MaTB, TenThongBao, ThoiGianThongBao, NoiDungThongBao)
        VALUES (@MaTB_moi, @TenThongBao, GETDATE(), @NoiDungThongBao);

        -- Tăng mã thông báo cho lần lặp tiếp theo
        SET @MaTB_moi = RIGHT('000' + CAST(CAST(@MaTB_moi AS INT) + 1 AS VARCHAR(4)), 4);

        SET @Counter = @Counter + 1;
    END
END

EXEC TaoDuLieDuLieuThongBao
select * from ThongBao 

--ThongBaoNhanVien
CREATE PROCEDURE TaoDuLieuThongBaoNV
AS
BEGIN
    DECLARE @SoLuongThongBao INT = (SELECT COUNT(*) FROM ThongBao);
    DECLARE @index INT = 1;
    DECLARE @MaTB CHAR(4);
    DECLARE @MaDangNhap CHAR(12);

    WHILE @index <= @SoLuongThongBao
    BEGIN
        SET @MaTB = (SELECT TOP 1 MaTB FROM ThongBao ORDER BY NEWID());
        SET @MaDangNhap = (SELECT TOP 1 MaDangNhap 
                           FROM NhanVien 
                           ORDER BY NEWID());

        INSERT INTO ThongBaoNV (MaTB, MaDangNhap)
        VALUES (@MaTB, @MaDangNhap);

        SET @index = @index + 1;  -- Tăng chỉ số lên 1
    END
END

EXEC TaoDuLieuThongBaoNV 
select * from ThongBaoNV
