-- insert chủ quán
create procedure InsertchuQuan
as
begin
    declare @Counter int = 1,
			@SoCCCD char(12),
			@TenChuQuan nvarchar(50),
			@TuoiChuQuan int,
			@NoiOHienTai nvarchar(50),
			@SoDienThoai char(10),
			@Username char(12),
			@Pass varchar(20)

    declare @FirstNames table (ID int, Name nvarchar(50));
    declare @LastNames table (ID int, Name nvarchar(50));
    declare @DiaChi table (DiaChi nvarchar(100))

    insert into @FirstNames (ID, Name) values	(1, N'Nguyễn'),
												(2, N'Trần'),
												(3, N'Lê'),
												(4, N'Phạm'),
												(5, N'Ngô'),
												(6, N'Đinh'),
												(7, N'Hồ'),
												(8, N'Tô'),
												(9, N'Bùi'),
												(10, N'Vũ')

    insert into @LastNames (ID, Name) values	(1, N'An'),
												(2, N'Bình'),
												(3, N'Chi'),
												(4, N'Duy'),
												(5, N'Hoàng'),
												(6, N'Hương'),
												(7, N'Khánh'),
												(8, N'Linh'),
												(9, N'Mai'),
												(10, N'Nam')

    insert into @DiaChi (DiaChi) values (N'Nguyễn Thị Minh Khai'), 
										(N'Đường Lê Lợi'), 
										(N'Đường Trần Hưng Đạo'), 
										(N'Đường Phạm Văn Đồng'), 
										(N'Đường Hoàng Văn Thụ')

  -- tạo mã đăng nhập ngẫu nhiên
    while @Counter <= 1000
    begin
        -- tạo mã đăng nhập ngẫu nhiên
        set @Username = 'CQ' +  right('0000000000' + cast(@counter as varchar),10)

        -- tạo số cccd ngẫu nhiên
        set @SoCCCD = right('000000000000' + cast(abs(checksum(newid())) as varchar(12)), 12)

        -- tạo tên ngẫu nhiên
        set @TenChuQuan = (select top 1 Name from @FirstNames order by newid()) + ' ' +
                           (select top 1 Name from @LastNames order by newid())

        -- tạo tuổi ngẫu nhiên từ 18 đến 80
        set @TuoiChuQuan = abs(checksum(newid()) % 63) + 18

        -- tạo địa chỉ hiện tại ngẫu nhiên
        set @NoiOHienTai = (select top 1 DiaChi from @DiaChi order by newid())

        -- tạo số điện thoại ngẫu nhiên
        set @SoDienThoai = '0' + right('0000000000' + cast(abs(checksum(newid())) as varchar(10)), 9)

        -- tạo username ngẫu nhiên
        set @Username = right('000000000000' + cast(abs(checksum(newid())) as varchar(12)), 12)

        -- tạo mật khẩu ngẫu nhiên
        set @Pass = left(newid(), 8)  -- mật khẩu dài 8 ký tự

        -- chèn dữ liệu vào bảng chuquan
        insert into ChuQuan (SoCCCD, TenChuQuan, TuoiChuQuan, NoiOHienTai, SoDienThoai, Username, Pass)
        values (@SoCCCD, @TenChuQuan, @TuoiChuQuan, @NoiOHienTai, @SoDienThoai, @Username, @Pass)

        set @Counter = @Counter + 1
    end
end

exec InsertChuQuan
select * from ChuQuan


-- insert nhân viên
create procedure InsertNhanVien
as
begin
    declare @Counter int = 1,
			@MaDangNhap char(12),
			@CCCD char(12),
			@TenNV nvarchar(50),
			@TuoiNV int,
			@DiaChiValue nvarchar(60),  
			@SDT char(10),
			@SoTaiKhoanNH varchar(20),
			@MatKhau varchar(20)

    declare @FirstNames table (ID int, Name nvarchar(50))
    declare @LastNames table (ID int, Name nvarchar(50))
    declare @DiaChi table (DiaChi nvarchar(60))

    insert into @FirstNames (ID, Name) values	(1, N'Nguyễn'),
												(2, N'Trần'),
												(3, N'Lê'),
												(4, N'Phạm'),
												(5, N'Ngô'),
												(6, N'Đinh'),
												(7, N'Hồ'),
												(8, N'Tô'),
												(9, N'Bùi'),
												(10, N'Vũ')

    insert into @LastNames (ID, Name) values	(1, N'An'),
												(2, N'Bình'),
												(3, N'Chi'),
												(4, N'Duy'),
												(5, N'Hoàng'),
												(6, N'Hương'),
												(7, N'Khánh'),
												(8, N'Linh'),
												(9, N'Mai'),
												(10, N'Nam')

    insert into @DiaChi (DiaChi) values (N'Nguyễn Thị Minh Khai'), 
										(N'Đường Lê Lợi'), 
										(N'Đường Trần Hưng Đạo'), 
										(N'Đường Phạm Văn Đồng'), 
										(N'Đường Hoàng Văn Thụ')

    while @Counter <= 1000
    begin
        -- tạo mã đăng nhập ngẫu nhiên
        set @MaDangNhap = 'NV' +  right('0000000000' + cast(@counter as varchar),10)

        -- tạo số cccd ngẫu nhiên
        set @CCCD = right('000000000000' + cast(abs(checksum(newid())) as varchar(12)), 12)

        -- tạo tên ngẫu nhiên
        set @TenNV = (select top 1 Name from @FirstNames order by newid()) + ' ' +
                      (select top 1 Name from @LastNames order by newid())

        -- tạo tuổi ngẫu nhiên từ 18 đến 60
        set @TuoiNV = abs(checksum(newid()) % 8) + 18

        -- tạo địa chỉ ngẫu nhiên
        set @DiaChiValue = (select top 1 DiaChi from @DiaChi order by newid())

        -- tạo số điện thoại ngẫu nhiên
        set @SDT = '0' + right('0000000000' + cast(abs(checksum(newid())) as varchar(10)), 9)

        -- tạo số tài khoản ngân hàng ngẫu nhiên
        set @SoTaiKhoanNH = right('00000000000000000000' + cast(abs(checksum(newid())) as varchar(20)), 20)

        -- tạo mật khẩu ngẫu nhiên
        set @MatKhau = left(newid(), 8)  -- mật khẩu dài 8 ký tự

        -- chèn dữ liệu vào bảng nhanvien
        insert into NhanVien (MaDangNhap, CCCD, TenNV, TuoiNV, DiaChi, SDT, SoTaiKhoanNH, MatKhau)
        values (@MaDangNhap, @CCCD, @TenNV, @TuoiNV, @DiaChiValue, @SDT, @SoTaiKhoanNH, @MatKhau)

        set @Counter = @Counter + 1
    end
end

exec InsertNhanVien
select * from NhanVien


-- insert cấp bậc
create procedure CapBac
as
begin
    declare @Counter int = 0, -- đếm số bản ghi đã chèn thành công
			@MaDangNhap char(12),
			@CapBac char(2)

    -- giả định các cấp bậc
    declare @CapBacOptions table (CapBac char(2));
    insert into @CapBacOptions (CapBac) values	(N'S1'),  -- cấp thấp nhất với mức lương 15k
												(N'S2'),  -- cấp thứ 2 với mức lương 17k
												(N'SS')	  -- cấp cao nhất trong nhân viên với mức lương 20k

    while @Counter < 1000
    begin
        -- chọn ngẫu nhiên MaDangNhap từ bảng nhanvien
        set @MaDangNhap = (select top 1 MaDangNhap from NhanVien order by newid())

        -- chọn ngẫu nhiên cấp bậc từ danh sách
        set @CapBac = (select top 1 CapBac from @CapBacOptions order by newid())

        -- chèn dữ liệu vào bảng CapBacNV
        begin try
            insert into CapBacNV (MaDangNhap, CapBac)
            values (@MaDangNhap, @CapBac)
            set @Counter = @Counter + 1
        end try
        begin catch
            -- xử lý lỗi nếu có ở đây (nếu cần)
            continue
        end catch
    end
end

-- thực hiện thủ tục
exec CapBac
select * from CapBacNV


-- insert lịch làm
create procedure TaoDuLieuLichLam
as
begin
    declare @i int = 0,  
			@Ca int,
			@MaBang char(4),
			@NgayLam date,
			@CaLam nvarchar(10),
			@NgayNghi date

    -- Vòng lặp để tạo dữ liệu cho từng ngày làm việc từ 01/01/2024 đến 31/12/2024
    while @i < 366  
    begin
        set @NgayLam = dateadd(day, @i, '2024-01-01') -- Bắt đầu từ ngày 01/01/2024

        -- Lặp qua từng ca (1: Sáng, 2: Chiều, 3: Tối) cho mỗi ngày
        set @Ca = 1
        while @Ca <= 3
        begin
            -- Cập nhật MaBang với định dạng 4 ký tự, bắt đầu từ L001 cho ngày 01/01/2024
            set @MaBang = 'L' + right('000' + cast((@i * 3 + @Ca + 1) as varchar), 3)

            set @CaLam = case @Ca	when 1 then N'Sang'
									when 2 then N'Chieu'
									when 3 then N'Toi' 
							end

            -- Để NgàyNghi là NULL cho tất cả các ca
            set @NgayNghi = null

            -- Chèn dữ liệu vào bảng LichLam
            insert into LichLam (MaBang, NgayLam, CaLam, NgayNghi)
            values (@MaBang, @NgayLam, @CaLam, @NgayNghi)

            set @Ca = @Ca + 1  
        end

        set @i = @i + 1  
    end
end

exec TaoDuLieuLichLam
select * from LichLam


-- insert lịch làm nv
create procedure TaoDuLieuLichLamNV
as
begin
    declare @SoLuongLich int = (select count(*) from LichLam),
			@index int = 1,
			@MaBang char(4),
			@MaDangNhap char(12)

    while @index <= @SoLuongLich
    begin
        set @MaBang = 'L' + right('000' + cast(@index as varchar), 3)

        -- Lấy MaDangNhap ngẫu nhiên từ bảng NhanVien
        set @MaDangNhap = (select top 1 MaDangNhap 
                           from NhanVien 
                           order by newid())

        insert into LichLamNV (MaBang, MaDangNhap)
        values (@MaBang, @MaDangNhap)

        set @index = @index + 1  
    end
end

exec TaoDuLieuLichLamNV
select * from LichLamNV

select LichLamNV.MaBang, CaLam, NgayLam
from LichLam join LichLamNV on LichLam.MaBang = LichLamNV.MaBang
where MaDangNhap = 'NV0000000007'


-- insert chấm công
create procedure TaoDuLieuChamCong
as
begin
    declare @MaBangChamCong char(4),
			@NgayChamCong date,
			@CaLam nvarchar(10),
			@TGVaoCa datetime,
			@TGRaCa datetime

    -- Chèn dữ liệu vào bảng ChamCong từ bảng LichLam
    insert into ChamCong (MaBangChamCong, NgayChamCong, TGVaoCa, TGRaCa, CaLam)
    select MaBang, NgayLam, 
        case when NgayLam < getdate() then case CaLam	when N'Sang' then cast(convert(varchar, NgayLam, 120) + ' 07:00:00' as datetime)
														when N'Chieu' then cast(convert(varchar, NgayLam, 120) + ' 12:00:00' as datetime)
														else cast(convert(varchar, NgayLam, 120) + ' 17:00:00' as datetime)
											end
			 else Null
		end as TGVaoCa,
		case when NgayLam < getdate() then dateadd(hour, 5, case CaLam when N'Sang' then cast(convert(varchar, NgayLam, 120) + ' 07:00:00' as datetime)
																		when N'Chieu' then cast(convert(varchar, NgayLam, 120) + ' 12:00:00' as datetime)
																		else cast(convert(varchar, NgayLam, 120) + ' 17:00:00' as datetime)
															end )
			 else Null
		end as TGRaCa, CaLam
    from LichLam
end

exec TaoDuLieuChamCong
select * from ChamCong


-- insert chấm công nv
create procedure TaoDuLieuChamCongNV
as
begin
    declare @MaBangChamCong char(4),
			@MaDangNhap char(12)

    -- Chèn dữ liệu vào bảng ChamCongNV dựa trên bảng ChamCong và LichLam
    insert into ChamCongNV (MaBangChamCong, MaDangNhap)
    select	c.MaBangChamCong,
			n.MaDangNhap
    from ChamCong c join LichLamNV l on c.MaBangChamCong = l.MaBang
					join NhanVien n on l.MaDangNhap = n.MaDangNhap 
end

exec TaoDuLieuChamCongNV
select * from ChamCongNV join ChamCong on ChamCong.MaBangChamCong = ChamCongNV.MaBangChamCong
where MaDangNhap = 'NV0000000707'


-- insert lương
-- hàm tính tiền lương cho nhân viên
create function TienLuong(@SoGioLamTrongThang int, @MaDangNhap char(12))
returns int
as
begin
    declare @TienLuong int, 
			@CapBac char(2), 
			@LuongMoiGio int

    select @CapBac = CapBac 
	from CapBacNV 
	where MaDangNhap = @MaDangNhap

    set @LuongMoiGio = case when @CapBac = 'S1' then 15000
							when @CapBac = 'S2' then 17000
							when @CapBac = 'SS' then 20000
							else 0  
						end

    set @TienLuong = @SoGioLamTrongThang * @LuongMoiGio
    return @TienLuong
end


-- trigger tính số giờ làm trong tháng 
create trigger TinhSoGioLam
on ChamCong
after insert
as
begin
    declare @MaBangChamCong char(4), 
			@MaBangLuong char(4), 
			@SoGioLamTrongThang int

    select @MaBangChamCong = inserted.MaBangChamCong 
    from inserted

    select top 1 @MaBangLuong = Luong.MaBangLuong
    from Luong	join LuongNV on Luong.MaBangLuong = LuongNV.MaBangLuong
				join ChamCongNV on LuongNV.MaDangNhap = ChamCongNV.MaDangNhap
    where ChamCongNV.MaBangChamCong = @MaBangChamCong

    -- Tính tổng số giờ làm cho tháng hiện tại
    select @SoGioLamTrongThang = sum(datediff(hour, TGVaoCa, TGRaCa))
    from ChamCong join ChamCongNV on ChamCong.MaBangChamCong = ChamCongNV.MaBangChamCong
    where ChamCongNV.MaBangChamCong = @MaBangChamCong
    and month(ChamCong.NgayChamCong) = month(getdate())  
    and year(ChamCong.NgayChamCong) = year(getdate())

    -- Cập nhật số giờ làm vào bảng lương
    update Luong
    set SoGioLamTrongThang = @SoGioLamTrongThang
    where MaBangLuong = @MaBangLuong
end


create proc InsertLuong
as
begin
    declare @MaBangLuong char(4), 
            @SoGioBatDauLam int, 
            @TienLuong int, 
            @MaDangNhap char(12), 
            @dem int = 1, 
            @SoGioLamTrongThang int

    while @dem <= 1000 
    begin
        -- Tạo mã bảng lương 
        set @MaBangLuong = 'S' + right('000' + cast(@dem as varchar), 3)

        -- Kiểm tra mã bảng lương đã tồn tại hay chưa
        while exists (select 1 from Luong where MaBangLuong = @MaBangLuong)
        begin
            -- Tạo lại mã bảng lương nếu đã tồn tại
            set @MaBangLuong = 'S' + right('000' + cast(@dem as varchar), 3)
        end
        
        -- Lấy mã đăng nhập ngẫu nhiên
        select top 1 @MaDangNhap = MaDangNhap from NhanVien order by newid()

        -- Tính số giờ làm trong tháng từ bảng ChamCongNV
        select @SoGioLamTrongThang = sum(datediff(hour, TGVaoCa, TGRaCa))
        from ChamCongNV 
        join ChamCong on ChamCong.MaBangChamCong = ChamCongNV.MaBangChamCong
        where MaDangNhap = @MaDangNhap
        and month(NgayChamCong) = month(getdate())  
        and year(NgayChamCong) = year(getdate())

        -- Nếu không có chấm công, đặt số giờ làm bằng 0
        if @SoGioLamTrongThang is null
            set @SoGioLamTrongThang = 0

        -- Tính tiền lương dựa trên số giờ làm
        set @TienLuong = dbo.TienLuong(@SoGioLamTrongThang, @MaDangNhap)

        -- Chèn thông tin lương vào bảng Luong
        insert into Luong (MaBangLuong, SoGioLamTrongThang, SoGioBatDauLam, TienLuong)
        values (@MaBangLuong, @SoGioLamTrongThang, 0, @TienLuong) -- Giữ giá trị @SoGioBatDauLam = 0 vì không sử dụng

        set @dem = @dem + 1
    end
end

-- Thực hiện gọi thủ tục
exec InsertLuong
select * from Luong


-- insert lương nv
create proc InsertLuongNV
as
begin
    declare @MaBangLuong char(4), @MaDangNhap char(12), @dem int = 1
    while @dem <= 1000
    begin
        -- Lấy mã đăng nhập ngẫu nhiên từ bảng nhân viên đã chấm công
        set @MaDangNhap = (select top 1 MaDangNhap 
                           from ChamCongNV 
                           join ChamCong on ChamCong.MaBangChamCong = ChamCongNV.MaBangChamCong
                           where month(NgayChamCong) = month(getdate())
                           and year(NgayChamCong) = year(getdate())
                           order by newid())
        
        -- Nếu không có nhân viên nào đã chấm công, thoát khỏi vòng lặp
        if @MaDangNhap is null
        begin
            break
        end

        -- Lấy mã bảng lương ngẫu nhiên
        set @MaBangLuong = (select top 1 MaBangLuong from Luong order by newid())

        -- Chèn thông tin lương vào bảng LuongNV
        insert into LuongNV (MaDangNhap, MaBangLuong)
        values (@MaDangNhap, @MaBangLuong)
        
        set @dem = @dem + 1
    end
end

exec InsertLuongNV
select * from LuongNV


exec InsertLuongNV
select * from Luong
select * from LuongNV
select * from Luong join LuongNV on Luong.MaBangLuong = LuongNV.MaBangLuong
where Luong.MaBangLuong = 'S027'



-- insert thông báo
create or alter proc TaoDuLieuThongBao
as
begin
    declare @Counter INT = 1,
			@MaTB_moi CHAR(4),
			@MaTB_cu CHAR(4),
			@TenThongBao NVARCHAR(100),
			@NoiDungThongBao NVARCHAR(200)

    declare @ThongBao table (TenThongBao nvarchar(100), NoiDungThongBao nvarchar(200))
    
    insert into @ThongBao (TenThongBao, NoiDungThongBao) values
        (N'Thông báo khuyến mãi trà sữa', N'Giảm giá 20% cho các loại trà sữa'),
        (N'Thông báo khai trương cửa hàng mới', N'Khai trương cửa hàng mới tại 225 Lê Thanh Nghị'),
        (N'Thông báo sự kiện âm nhạc', N'Sự kiện âm nhạc vào ngày mai với ca sĩ khách mời '),
        (N'Thông báo chương trình tri ân khách hàng', N'Tri ân khách hàng với nhiều phần quà hấp dẫn'),
        (N'Thông báo ngày hội hoa sen', N'Ngày hội hoa sen với các mã trà sữa từ hoa sen giảm giá 30%')
    set @MaTB_cu = 0001
    if @MaTB_cu is not null
    begin
		set @MaTB_moi = right('000' + cast(cast(@MaTB_cu as int) + 1 as varchar(4)), 4)
    end
    while @Counter <= 1000
    begin
        -- Chọn một thông báo ngẫu nhiên từ bảng tạm
        select top 1 
            @TenThongBao = TenThongBao,
            @NoiDungThongBao = NoiDungThongBao
        from @ThongBao
        order by newid()

        -- Chèn thông báo vào bảng ThongBao
        insert into ThongBao (MaTB, TenThongBao, ThoiGianThongBao, NoiDungThongBao)
        values (@MaTB_moi, @TenThongBao, getdate(), @NoiDungThongBao)

        -- Tăng mã thông báo cho lần lặp tiếp theo
		set @MaTB_moi = right('000' + cast(cast(@MaTB_moi as int) + 1 as varchar(4)), 4);

        set @Counter = @Counter + 1
    end
end

-- Thực hiện thủ tục
exec TaoDuLieuThongBao
select * from ThongBao 


-- insert thông báo nv
create or alter proc TaoDuLieuThongBaoNV
as
begin
    declare @SoLuongThongBao int = (select count(*) from ThongBao),
			@index INT = 1,
			@MaTB CHAR(4),
			@MaDangNhap CHAR(12)

    while @index <= @SoLuongThongBao
    begin
        set @MaTB = (select top 1 MaTB from ThongBao order by newid())
        set @MaDangNhap = (select top 1 MaDangNhap 
                           from NhanVien 
                           order by newid())

        insert into ThongBaoNV (MaTB, MaDangNhap)
        values (@MaTB, @MaDangNhap)

        set @index = @index + 1  
    end
end

-- Thực hiện thủ tục
exec TaoDuLieuThongBaoNV
select * from ThongBaoNV



-- 1. Hàm tính tiền lương cho nhân viên
/*
Input: số giờ làm trong tháng, mã đăng nhập
Output: Tiền lương
Process:	1. Lấy cấp bậc của nhân viên, điều kiện MaDangNhap = mã đăng nhập
			2. Tính lương mỗi giờ:	- Nếu cấp bậc = S1 -- > 15000
									- Nếu cấp bậc = S2 -- > 17000
									- Nếu cấp bậc = SS -- > 20000
									- Còn lại là 0
			3. Tiền lương = số giờ làm trong tháng * lương mỗi giờ
*/
create or alter function TienLuong (@SoGioLamTrongThang int, @MaDangNhap char(12))
returns int
as
begin
    declare @TienLuong int, @CapBac char(2), @LuongMoiGio int
    
    select @CapBac = CapBac from CapBacNV where MaDangNhap = @MaDangNhap
    
    set @LuongMoiGio = case when @CapBac = 'S1' then 15000
                            when @CapBac = 'S2' then 17000
                            when @CapBac = 'SS' then 20000
                            else 0  
                       end
    set @TienLuong = @SoGioLamTrongThang * @LuongMoiGio
    return @TienLuong
end



-- 2. Thủ tục tạo thông báo
create or alter procedure TaoThongBao
    @TenThongBao nvarchar(100),        
    @NoiDungThongBao nvarchar(200)     
as
begin
    declare @MaTB_moi char(4)
    declare @MaTB_cu char(4)
    declare @A int 
    set @MaTB_cu = (select max(MaTB) from ThongBao)
    if @MaTB_cu is null
    begin
        set @MaTB_cu = 000
    end 
    else 
    begin 
        set @A = @MaTB_cu + 1 
        set @MaTB_moi = concat(replicate('0', 4 - len(@A)), @A)
        insert into ThongBao (MaTB, TenThongBao, ThoiGianThongBao, NoiDungThongBao)
        values (@MaTB_moi, @TenThongBao, getdate(), @NoiDungThongBao)
        select * from ThongBao where MaTB = @MaTB_moi
    end 
end

exec TaoThongBao N'Thông báo chương trình khuyến mãi', N'Tặng khách hàng 1 con labubu khi mua trà sữa'
select * from ThongBao


-- 3. Thủ tục cập nhật thông tin nhân viên
create or alter PROC CapNhatThongTin(@MaDangNhap char(12),
							@CCCD char(12),
							@TenNV nvarchar(50) ,
							@TuoiNV int ,
							@DiaChi nvarchar(60),
							@SDT char(10) ,
							@SoTaiKhoanNH varchar(20) ,
							@MatKhau varchar(20) )
as
begin
	update NhanVien
	set CCCD = @CCCD,
		TenNV = @TenNV,
		TuoiNV = @TuoiNV,
		DiaChi = @DiaChi,
		SDT = @SDT,
		SoTaiKhoanNH = @SoTaiKhoanNH,
		MatKhau = @MatKhau
	where MaDangNhap = @MaDangNhap
	if @@ROWCOUNT = 0
	begin
		print N'Cập nhật không thành công'
	end
	else
	begin
		print N'Cập nhật thành công'
	end
end
-- gọi thủ tục
exec CapNhatThongTin	@MaDangNhap = 'NV0000000020',
						@CCCD = '123456789012',
						@TenNV = N'Nguyễn Văn A',
						@TuoiNV = 30,
						@DiaChi = N'123 Đường ABC, Quận 1',
						@SDT = '0123456789',
						@SoTaiKhoanNH = '1234567890',
						@MatKhau = 'MatKhauMoi'
select * from NhanVien



-- 4. Thủ tục kiểm tra mã đăng nhập đã tồn tại hay chưa
/*
Input: mã đăng nhập
Output: trả về chuỗi: - Mã dăng nhập đã tồn tại / Mã đăng nhập chưa tồn tại
Process: 1. kiểm tra xem có tồn tại nhân viên có MaDangNhap = mã đăng nhập không
			- Nếu có --> Mã dăng nhập đã tồn tại
			- Còn lại --> Mã đăng nhập chưa tồn tại
*/
create or alter PROC CheckMaDangNhap(@MaDangNhap char(12), @KiemTra nvarchar(50) output)
as
begin
	if exists (select * from NhanVien where MaDangNhap = @MaDangNhap)
	begin
		set @KiemTra = N'Mã đăng nhập đã tồn tại'
	end
	else
	begin
		set @KiemTra = N'Mã đăng nhập chưa tồn tại'
	end
end

declare @mdn varchar(12), @kt nvarchar(50)
exec CheckMaDangNhap 'NV0000000001', @kt output
print @kt

declare @mdn varchar(12), @kt nvarchar(50)
exec CheckMaDangNhap 'NV1111111111', @kt output
print @kt



-- 5. Thủ tục tạo mới thông tin nhân viên
create or alter PROC TaoThongTinNV (	@MaDangNhap char(12),
										@CCCD char(12),
										@TenNV nvarchar(50) ,
										@TuoiNV int ,
										@DiaChi nvarchar(60),
										@SDT char(10) ,
										@SoTaiKhoanNH varchar(20) ,
										@MatKhau varchar(20),
										@kiemtra nvarchar(50) output)
as
begin
	if exists (select * from NhanVien where MaDangNhap = @MaDangNhap)
	begin
		set @KiemTra = N'Mã đăng nhập đã tồn tại'
	end
	else
	begin
		insert into NhanVien
		values(	@MaDangNhap, @CCCD, @TenNV, @TuoiNV, @DiaChi, @SDT, @SoTaiKhoanNH, @MatKhau)
	end
end

declare @mdn char(12),
		@cc char(12),
		@ten nvarchar(50) ,
		@tuoi int ,
		@dc nvarchar(60),
		@sodt char(10) ,
		@stk varchar(20) ,
		@mk varchar(20),
		@kt nvarchar(50)
exec TaoThongTinNV 'NV0000000001', '123456789012', 'ABC', 20, 'Quang Ngai', '0965525315', '0987654321', 'ABCDE', @kt output
print @kt

declare @mdn char(12),
		@cc char(12),
		@ten nvarchar(50) ,
		@tuoi int ,
		@dc nvarchar(60),
		@sodt char(10) ,
		@stk varchar(20) ,
		@mk varchar(20),
		@kt nvarchar(50)
exec TaoThongTinNV 'NV5487294765', '124456789015', 'ABC', 20, 'Quang Ngai', '0961525315', '0980654321', 'ABCDE', @kt output
print @kt
select * from NhanVien



--6. Thủ tục cập nhật Ngày nghỉ trong bảng lịch làm
/*
Input: ngày 
Output: N/A
Process: 1. cập ngật cọt NgayNghi = ngày, điều kiện NgayLam = ngày
*/
create or alter PROC CapNhatNgayNghi (@Ngay date, @kiemtra nvarchar(50) output)
as
begin
	update LichLam
	set NgayNghi = @Ngay
	where NgayLam = @Ngay

	if @@ROWCOUNT = 0
	begin
		set @kiemtra = N'Cập nhật không thành công'
	end
	else
	begin
		set @kiemtra = N'Cập nhật thành công'
	end
end
declare @nn date, @kt nvarchar(50)
exec CapNhatNgayNghi '2024-10-17', @kt output
print @kt
select * from LichLam



-- 7. Thủ tục để sửa đổi thời gian chấm công
/*
Input: ngày chấm công, ca làm, thời gian vào, thời gian ra
output: trả vè chuỗi: - Cập nhật thành công / Cập nhật không thành công
Process: 1. cập nhật TGVaoCa = thời gian vào
					 TGRaCa = thời gian ra 
				điều kiện NgayChamCong = ngày chấm công và CaLam = @ca làm
*/
create or alter PROC CapNhatThoiGianChamCong (	@NgayChamCong date,
												@CaLam nvarchar(20),
												@TGVaoCa datetime, 
												@TGRaCa datetime, 
												@kiemtra nvarchar(50) output)
as
begin
	update ChamCong
	set TGVaoCa = @TGVaoCa,
		TGRaCa = @TGRaCa
	where NgayChamCong = @NgayChamCong
	and CaLam = @CaLam

	if @@ROWCOUNT = 0
	begin
		set @kiemtra = N'Cập nhật không thành công'
	end
	else
	begin
		set @kiemtra = N'Cập nhật thành công'
	end
end

declare @ngay date, @ca nvarchar(20), @vao datetime, @ra datetime, @kt nvarchar(50)
exec CapNhatThoiGianChamCong '2024-01-01', N'Sang', '2024-01-01 07:20:00.000', '2024-01-01 12:20:00.000', @kt output
print @kt
select * from ChamCong



-- 8. Trigger cập nhật số giờ làm trong tháng
/*
Loại: after
Sự kiện: insert
Ký sinh: ChamCong
*/
create or alter trigger TinhSoGioLam
on ChamCong
after insert
as
begin
    declare @MaBangChamCong char(4), 
			@MaBangLuong char(4), 
			@SoGioLamTrongThang int

    select @MaBangChamCong = inserted.MaBangChamCong 
    from inserted

    select top 1 @MaBangLuong = Luong.MaBangLuong
    from Luong	join LuongNV on Luong.MaBangLuong = LuongNV.MaBangLuong
				join ChamCongNV on LuongNV.MaDangNhap = ChamCongNV.MaDangNhap
    where ChamCongNV.MaBangChamCong = @MaBangChamCong

    -- Tính tổng số giờ làm cho tháng hiện tại
    select @SoGioLamTrongThang = sum(datediff(hour, TGVaoCa, TGRaCa))
    from ChamCong join ChamCongNV on ChamCong.MaBangChamCong = ChamCongNV.MaBangChamCong
    where ChamCongNV.MaBangChamCong = @MaBangChamCong
    and month(ChamCong.NgayChamCong) = month(getdate())  
    and year(ChamCong.NgayChamCong) = year(getdate())

    -- Cập nhật số giờ làm vào bảng lương
    update Luong
    set SoGioLamTrongThang = @SoGioLamTrongThang
    where MaBangLuong = @MaBangLuong
end



-- 9. Trigger đảm bảo nhân viên không đăng ký hai ca làm việc trùng giờ trong cùng một ngày.
/*
Loại: for
Sự kiện: Insert
Ký sinh: LichLamNV
*/
create or alter trigger KiemTraTrungCaLamViec
on LichLamNV
for insert
as
begin
    -- Kiểm tra xem có nhân viên nào đăng ký trùng ca làm việc và ngày làm không
    if exists (
        select 1 
        from inserted I
        join LichLam LL on LL.MaBang = I.MaBang
        join LichLamNV LLNV on LLNV.MaDangNhap = I.MaDangNhap
        join LichLam LL2 on LL2.MaBang = LLNV.MaBang
        where LL.NgayLam = LL2.NgayLam
          and LL.CaLam = LL2.CaLam
          and LLNV.MaDangNhap = I.MaDangNhap
          and LLNV.MaBang <> I.MaBang  -- Điều kiện này đảm bảo kiểm tra với các bản ghi trước đó
    )
    begin
        -- Nếu nhân viên đã đăng ký trùng ca làm trong ngày đó, rollback giao dịch
        print N'Nhân viên đã đăng ký ca làm việc trùng giờ trong cùng một ngày'
        rollback
    end
end
-- test
insert into LichLam values ('LLLM', '2024-12-10', 'Sang', Null)
insert into LichLamNV values ('LLLM', 'NV0000000001')
insert into LichLamNV values ('LLLM', 'NV0000000001')



-- 10. Trigger khi thêm mới nhân viên, đảm bảo rằng mã đăng nhập là mới và phải đủ 12 ký tự, số điện thoại phải hợp lệ
/*
Loại: for
Sự kiện: insert
Ký sinh: NhanVien
Xử lý: 1. tìm MaDangNhap, Sdt trong bảng inserted --> @MaDangNhap, @SDT
		2. kiểm tra nếu @MaDangNhap không bằng 12 ký tự --> 'Mã đăng nhập phải có đúng 12 ký tự' + rollback
		3. kiểm tra nếu @SDT không bằng 10 ký tự --> 'Số điện thoại phải có đúng 10 chữ số' + rollback
*/
create or alter trigger KiemTraThemNhanVien 
on NhanVien
for insert
as
begin
    declare @MaDangNhap nvarchar(12), @SoDienThoai nvarchar(10)
    
    select @MaDangNhap = inserted.MaDangNhap, @SoDienThoai = inserted.SDT
    from inserted 

    if len(@MaDangNhap) < > 12
    begin
        print N'Mã đăng nhập phải có đúng 12 ký tự'
        rollback 
    end
    else if len(@SoDienThoai) < > 10  
    begin
        print N'Số điện thoại phải có đúng 10 chữ số'
        rollback 
    end
end
-- test
insert into NhanVien values 
('NV9876543213', '123456789011', 'ABC', 20, 'Quang Ngai', '0965525353', '0987654321', 'ABCDE')
insert into NhanVien values 
('NV987654321', '123456789013', 'ABC', 20, 'Quang Ngai', '0965525374', '0987654321', 'ABCDE')
insert into NhanVien values 
('NV9876543217', '123456789018', 'ABC', 20, 'Quang Ngai', '09655253', '0987654321', 'ABCDE')



-- 11. Thủ tục để xóa thông báo khi thông tin không còn phù hợp.
/*
Input: mã thông báo
Output: chuỗi giá trị: Error / Done
Process: 1. xóa thông báo, điều kiện MaTB = mã thông báo
		 2. kiểm tra xóa thành công hay chưa:	- nếu @@rowcount = 0 --> 'Error'
												- Ngược lại: 'Done'
*/
create procedure XoaThongBao (@MaTB char(4))            
as
begin
    delete from ThongBao 
    where MaTB = @MaTB;
    if @@rowcount = 0
    begin
        print 'Error!';
    end
    else
    begin
        print 'Done!';
    end
end
exec XoaThongBao '1002'



-- 12. Trigger để xóa thông tin bị lỗi thời
/*
Loại: after
Sự kiện: insert
Ký sinh: ThongBao
Xử lý: 1. xóa thông báo với điều kiện thời gian đã qua 1 năm: ThoiGianThongBao < dateadd(year, -1, getdate())
*/
create trigger XoaThongBaoTuDong
on ThongBao
after insert
as
begin
    delete from ThongBao
    where ThoiGianThongBao < dateadd(year, -1, getdate())
end



-- 13. Trigger kiểm tra tính hợp lệ của lương, đảm bảo mức lương phải nằm trong khoảng lương hợp lý tùy thuộc vào cấp bậc của nhân viên.
/*
Loại: after
Sự kiện: insert, update
Ký sinh: Luong
Xử lý:	1. lấy MaBangLuong, TienLuong từ bảng inserted --> @MaBangLuong, @TienLuong
		2. lấy MaDangNhap từ bảng LuongNV --> @MaDangNhap
		3. lấy Capbac từ bảng CapBacNV --> @CapBac
		4. tính lương mỗi giờ:	- Nếu cấp bậc = S1 -- > 15000
								- Nếu cấp bậc = S2 -- > 17000
								- Nếu cấp bậc = SS -- > 20000
								- Còn lại là 0
		5. kiểm tra lương có hợp lý không: (ít nhất một tháng làm 12 ca và nhiều nhất làm 20 ca (1 ca làm có 5 tiếng))
			- Nếu không: 'Lương không hợp lệ! Vui lòng kiểm tra lại' + rollback
*/
create trigger KiemTraMucLuong
on Luong
after insert, update
as
begin
    declare @MaBangLuong char(5), @MaDangNhap char(12),  @CapBac char(2),
			@TienLuong int, @LuongMoiGio int

    select @MaBangLuong = MaBangLuong, @TienLuong = TienLuong from inserted

    select @MaDangNhap = MaDangNhap from LuongNV where MaBangLuong = @MaBangLuong

    select @CapBac = CapBac from CapBacNV where MaDangNhap = @MaDangNhap

    set @LuongMoiGio = case 
                        when @CapBac = 'S1' then 15000
                        when @CapBac = 'S2' then 17000
                        when @CapBac = 'SS' then 20000
                        else 0
						end

    -- kiểm tra xem lương có nằm trong khoảng hợp lý không
    if @TienLuong < (@LuongMoiGio * 60) or @TienLuong > (@LuongMoiGio * 100 )
    begin
        print N'Lương không hợp lệ! Vui lòng kiểm tra lại.'
        rollback 
    end
end

insert into Luong (MaBangLuong, SoGioLamTrongThang, SoGioBatDauLam, TienLuong)
values ('S001', 160, 9365, 100000)

