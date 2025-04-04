--Ma hoa tren cot CCCD trong bang NhanVien
update NhanVien set CCCD = CONVERT(varchar(10), HASHBYTES('SHA2_256', CCCD), 1)

--Ma hoa tren cot SDT trong bang NhanVien
update NhanVien set SDT = CONVERT(varchar(10), HASHBYTES('SHA2_256', SDT), 1)

--Ma hoa tren cot MatKhau trong bang NhanVien
update NhanVien set SDT = CONVERT(varchar(10), HASHBYTES('SHA2_256', MatKhau), 1)

-- Trigger mahoa sau khi insert vao NhanVien
create trigger insert_NV 
on NhanVien
after insert 
as
begin
	update NhanVien
	set CCCD = (select convert(varchar(10), HASHBYTES('SHA2_256',inserted.CCCD),1)
				from inserted) 
	where MaDangNhap = (select inserted.MaDangNhap from inserted)

	update NhanVien
	set SDT = (select convert(varchar(10), HASHBYTES('SHA2_256',inserted.SDT),1)
				from inserted) 
	where MaDangNhap = (select inserted.MaDangNhap from inserted)

	update NhanVien
	set MatKhau = (select convert(varchar(10), HASHBYTES('SHA2_256',inserted.MatKhau),1)
				from inserted) 
	where MaDangNhap = (select inserted.MaDangNhap from inserted)
end

insert into NhanVien
values ('NV0000001001', '000046454142', N'Thanh Nhàn',23 ,
N'Nguy?n Th? Minh Khai', '0369646087', '00000000001870604656', 'Kbg2345')

insert into NhanVien
values ('NV0000001002', '000046444142', N'Thu Trang',19,
N'Lê Lợi', '0362646087', '00000000001870604646', 'Trang123')


SELECT MatKhau FROM NhanVien WHERE MaDangNhap = 'NV0000001002';


select * from NhanVien

SELECT COUNT(*) FROM NhanVien WHERE MaDangNhap = 'NV0000001002' AND MatKhau = '0x880AB492'

--Ma hoa tren cot SoCCCD trong bang ChuQuan 
update ChuQuan set SoCCCD = CONVERT(varchar(10), HASHBYTES('SHA2_256', SoCCCD), 1)

--Ma hoa tren cot SoDienThoai trong bang ChuQuan
update ChuQuan set SoDienThoai = CONVERT(varchar(10), HASHBYTES('SHA2_256', SoDienThoai), 1)

--Ma hoa tren cot Pass trong bang ChuQuan
update ChuQuan set Pass = CONVERT(varchar(10), HASHBYTES('SHA2_256', Pass), 1)

-- Trigger mahoa sau khi insert vao ChuQuan 

create trigger insert_CQ
on ChuQuan
after insert 
as
begin
	update ChuQuan
	set SoDienThoai = (select convert(varchar(10), HASHBYTES('SHA2_256',inserted.SoDienThoai),1)
				from inserted) 
	where SoCCCD = (select inserted.SoCCCD from inserted)

	update ChuQuan
	set Pass = (select convert(varchar(10), HASHBYTES('SHA2_256',inserted.Pass),1)
				from inserted) 
	where SoCCCD = (select inserted.SoCCCD from inserted)

	update ChuQuan
	set SoCCCD = (select convert(varchar(10), HASHBYTES('SHA2_256',inserted.SoCCCD),1)
				from inserted) 
	where SoCCCD = (select inserted.SoCCCD from inserted)
end

insert into ChuQuan
values ('000014613811', N'Thu Trang', 32,
N'Nguy?n Th? Minh Khai', '0339645087', '000064271322', 'Trang2345')

select * from ChuQuan where TenChuQuan = N'Thu Trang'

create proc spKiemTraDangNhapNhanVien(@MaDangNhap varchar(12), @MatKhau varchar(20), @ret int output) 
as
begin
    declare @MatKhauHash VARBINARY(32);

    -- Hash m?t kh?u v?i SHA2_256
    set @MatKhauHash = HASHBYTES('SHA2_256', @MatKhau)

    -- Ki?m tra thông tin ??ng nh?p
    if exists (select 1 from NhanVien
				where MaDangNhap = @MaDangNhap 
				and MatKhau = CONVERT(VARCHAR(10), @MatKhauHash, 1)) -- Chuy?n hash thành chu?i ?? so sánh
    begin
        set @ret=1
    end
    else
    begin
        set @ret=0
    end
end

declare @ret int
exec spKiemTraDangNhapNhanVien 'NV0000001001', 'Kbg2345', @ret output
print @ret

SELECT MaDangNhap, MatKhau FROM NhanVien WHERE MaDangNhap = 'NV0000001004';

select convert(varchar(10), HASHBYTES('SHA2_256', 'Trang123'), 1) AS Mã_Hóa

insert into NhanVien
values ('NV0000001003', '000046444042', N'Thu Trang',19,
N'Lê Lợi', '0302646087', '00000000001879604646', 'quancute')

insert into NhanVien
values ('NV0000001004', '000046244042', N'Thanh Thao',19,
N'Lê Lợi', '0992646087', '00000000001879604666', 'thao123')

