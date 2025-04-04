/*1.Hàm tính lương nhân viên
-	Input: SoGioLamTrongThang, MaDangNhap
-	Output: TienLuong
-	Process: a. Lấy cấp bậc nhân viên từ bảng CapBacNV thông qua MaDangNhap 
b. Tính lương mỗi giờ: S1 15000, S2  17000, SS  20000
c. Tính lương: TienLuong = SoGioLamTrongThang*LuongGio
*/
create function Salary (@SoGioLamTrongThang int, @MaDangNhap char(12))
returns int
as
begin
	declare @LuongGio int, @TienLuong int, @CapBac char(2)
	select @CapBac = CapBac from CapBacNV where MaDangNhap = @MaDangNhap
	set @LuongGio = case when @CapBac = 'S1' then 15000
						when @CapBac = 'S2' then 17000
						when @CapBac = 'SS' then 20000
						else 0
					end
	set @TienLuong = @SoGioLamTrongThang*@LuongGio
	return @TienLuong
end

select dbo.Salary(5, 'NV0000000834')

--
/*2. Thủ tục tạo thông báo
- input: tenTB, noidungTB
- output: N/A
- process: a. Lay maTBcu = maTB lon nhat trong bang ThongBao
			a.1. Neu maTBcu = null thi set maTBcu = 000
			a.2. Tao maTBmoi = maTBcu + 1 va dam bao maTBmoi co 4 ky tu
		   b. Nhap du lieu vao bang
*/
create proc Notify (@TenTB nvarchar(50), @noidungTB nvarchar(250))
as
begin
	declare @macu char(4), @mamoi char(4), @ma int
	select @macu = max(MaTB) from ThongBao
	if @macu is null
		set @mamoi = 000
	else
	begin
		set @ma = @macu +1 
		set @mamoi = concat(replicate('0',4-len(@ma)),@ma)
	end
	insert into ThongBao (MaTB, TenThongBao, ThoiGianThongBao, NoiDungThongBao)
	values (@mamoi, @TenTB, getdate(), @noidungTB)
end

exec Notify N'Thông báo chương trình khuyến mãi', N'Tặng khách hàng 1 con labubu khi mua trà sữa'
select * from ThongBao

/*3. Thủ tục kiểm tra mã đăng nhập đã tồn tại hay chưa?
- input: MaDangNhap
- output: trả về chuỗi gia tri: - Mã đăng nhập đã tồn tại / Mã đăng nhập chưa tồn tại
- process: a. kiểm tra xem có tồn tại nhân viên có MaDangNhap = mã đăng nhập không
				a.1 Nếu có --> Mã đăng nhập đã tồn tại
				a.2 Còn lại --> Mã đăng nhập chưa tồn tại

*/

create proc KiemTraMDN (@MaDangNhap char(12), @ref nvarchar(50) output)
as
begin
	if exists (select * from NhanVien where MaDangNhap = @MaDangNhap)
	begin
		set @ref = N'Mã đăng nhập đã tồn tại'
	end
	else
	begin
		set @ref = N'Mã đăng nhập chưa tồn tại'
	end
end

declare @mdn varchar(12), @kt nvarchar(50)
exec KiemTraMDN 'NV0000000001', @kt output
print @kt

/*4.Thủ tục cập nhật thông tin nhân viên
- input: MaDangNhap, CCCD, TenNV, TuoiNV , DiaChi, SDT, SoTaiKhoanNH, MatKhau 
- output: Tra ve giá trị chuỗi ‘Cập nhật không thành công’ nếu số dòng update <= 0
		  Tra ve giá trị chuỗi ‘Cập nhật thành công’ nếu số dòng update > 0
- process: a. Update bảng nhân viên thay đổi thông tin với điều kiện MaDangNhap = @MaDangNhap
			b.1. Nếu số dòng update = 0 thì in ra ‘Cập nhật không thành công’
			b.2. Ngược lại, in ra 'Cập nhật thành công'
*/
create PROC CapNhatThongTin(@MaDangNhap char(12),
							@CCCD char(12),
							@TenNV nvarchar(50),
							@TuoiNV int,
							@DiaChi nvarchar(60),
							@SDT char(10),
							@SoTaiKhoanNH varchar(20),
							@MatKhau varchar(20))
as
begin
	update NhanVien
	set CCCD = @CCCD,
		tenNV = @TenNV,
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

exec CapNhatThongTin @MaDangNhap = 'NV0000000020',
					@CCCD = '123456789012',
					@TenNV = N'Nguyễn Văn A',
					@TuoiNV = 30,
					@DiaChi = N'123 Đường ABC, Quận 1',
					@SDT = '0123456789',
					@SoTaiKhoanNH = '1234567890',
					@MatKhau = 'MatKhauMoi'

/*5. Tao moi thong tin nhan vien
- input: MaDangNhap, CCCD, TenNV, TuoiNV , DiaChi, SDT, SoTaiKhoanNH, MatKhau
- output: trả về chuỗi: Mã đăng nhập đã tồn tại hoac N/A
- process:	a. kiểm tra xem có tồn tại nhân viên có MaDangNhap = mã đăng nhập không
				Nếu có --> Mã đăng nhập đã tồn tại
				Còn lại --> Nhập dữ liệu vào bảng NV

*/
create PROC TaoThongTinNV (	@MaDangNhap char(12),
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

declare @mdn char(12), @cc char(12), @ten nvarchar(50) ,
		@tuoi int , @dc nvarchar(60), @sodt char(10) ,
		@stk varchar(20) , @mk varchar(20), @kt nvarchar(50)
exec TaoThongTinNV 'NV0000000001', '123456789012', 'ABC', 20, 
					'Quang Ngai', '0965525315', '0987654321', 'ABCDE', @kt output
print @kt

/*6. Thu tuc cập nhật Ngày nghỉ trong bảng lịch làm
- input: ngaynghi, MaBang
- output: Trả về chuỗi: 'Cập nhật không thành công' hoặc 'Cập nhật thành công'
- process: a. cập nhật cột NgayNghi = ngaynghi, điều kiện NgayLam = ngaylam
			a.1 Nếu số dòng cập nhật = 0 thì trả về chuỗi 'Cập nhật không thành công'
			a.2	Ngược lại, trả về chuỗi 'Cập nhật thành công'
*/
create PROC CapNhatNgayNghi (@ngaynghi date, @mabang char(4), @kiemtra nvarchar(50) output)
as
begin
	declare @ngaylam date
	update LichLam
	set NgayNghi = @ngaynghi
	where MaBang = @mabang
	if @@ROWCOUNT = 0
	begin
		set @kiemtra = N'Cập nhật không thành công'
	end
	else
	begin
		set @kiemtra = N'Cập nhật thành công'
	end
end

declare @nn date, @ma char(4), @kt nvarchar(50)
exec CapNhatNgayNghi '2024-10-17', 'L000', @kt output
print @kt

/*7. Thủ tục để sửa đổi thời gian chấm công 
- input: ngày chấm công, ca làm, thời gian vào ca,  thời gian ra ca
- output: Trả về chuỗi: 'Cập nhật không thành công' hoặc 'Cập nhật thành công'
- process: a. cập nhật TGVaoCa = thời gian vào ca, TGRaCa = thời gian ra với điều kiện 
						NgayChamCong = ngày chấm công và CaLam = ca làm
			b. Nếu số dòng cập nhật = 0 thì trả về chuỗi 'Cập nhật không thành công'
				Ngược lại, trả về chuỗi 'Cập nhật thành công'

*/
create PROC CapNhatThoiGianChamCong (@mabang char(4),
									@NgayChamCong date,
									@TGVaoCa datetime, 
									@TGRaCa datetime, 
									@kiemtra nvarchar(50) output)
as
begin
	update ChamCong
	set TGVaoCa = @TGVaoCa,
		TGRaCa = @TGRaCa
	where MaBangChamCong = @mabang

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
exec CapNhatThoiGianChamCong 'L000','2024-01-01', '2024-01-01 07:20:00.000', 
								'2024-01-01 12:20:00.000', @kt output
print @kt

/*8. Trigger cập nhật số giờ làm trong tháng
- Loai: after
- Ky sinh: ChamCong
- Su kien: Insert
- Xu ly: 1. lấy MaBangChamCong từ bảng BangChamCong
		2. lấy MaBangLuong từ bảng Luong 
		3. Tính SoGioLamTrongThang = tổng giờ của (tgraca - tgvaoca) 
		4. Cập nhật bảng Luong: SoGioLamTrongThang = @SoGioLamTTrongThang với điều kiện MaBangLuong = @MaBangLuong
*/
create trigger TinhSoGioLam
on ChamCong
after insert
as
begin
    declare @MaBangChamCong char(4), 
			@MaBangLuong char(4), 
			@SoGioLamTrongThang int

    select @MaBangChamCong = inserted.MaBangChamCong from inserted

    select top 1 @MaBangLuong = Luong.MaBangLuong
    from Luong	join LuongNV on Luong.MaBangLuong = LuongNV.MaBangLuong
				join ChamCongNV on LuongNV.MaDangNhap = ChamCongNV.MaDangNhap
    where ChamCongNV.MaBangChamCong = @MaBangChamCong

    select @SoGioLamTrongThang = sum(datediff(hour, TGVaoCa, TGRaCa))
    from ChamCong join ChamCongNV on ChamCong.MaBangChamCong = ChamCongNV.MaBangChamCong
    where ChamCongNV.MaBangChamCong = @MaBangChamCong
    and month(ChamCong.NgayChamCong) = month(getdate())  
    and year(ChamCong.NgayChamCong) = year(getdate())

    update Luong
    set SoGioLamTrongThang = @SoGioLamTrongThang
    where MaBangLuong = @MaBangLuong
end

/*9. Trigger đảm bảo nhân viên không đăng ký hai ca làm việc trùng giờ trong cùng một ngày.
- Loai: for
- Ky sinh: LichLamNV
- Su kien: Insert
- Xu ly: 1. Kiểm tra có tồn tại 1 bản ghi nào trong bảng inserted trùng trong bảng LichLam 
			với điều kiện NgayLam = NgayLam 
						và CaLam = CaLam 
						và MaDangNhap = MaDangNhap 
						và MaBang khác MaBang
			1.1 Nếu có, in ra 'Nhân viên đã đăng ký ca làm việc trùng giờ trong cùng một ngày' + rollback

*/
create trigger KiemTraTrungCaLamViec
on LichLamNV
for insert
as
begin
    if exists ( select 1 
				from inserted I join LichLam LL on LL.MaBang = I.MaBang
								join LichLamNV LLNV on LLNV.MaDangNhap = I.MaDangNhap
								join LichLam LL2 on LL2.MaBang = LLNV.MaBang
        where LL.NgayLam = LL2.NgayLam
          and LL.CaLam = LL2.CaLam
          and LLNV.MaDangNhap = I.MaDangNhap
          and LLNV.MaBang <> I.MaBang  )
    begin
        print N'Nhân viên đã đăng ký ca làm việc trùng giờ trong cùng một ngày'
        rollback
    end
end

-- test
insert into LichLam values ('LL01', '2024-01-01', 'Sáng', Null)
insert into LichLamNV values ('LL01', 'NV0000000404')

/*10. Trigger Kiểm tra thêm nhân viên
- Loai: for
- Ky sinh: NhanVien
- Su kien: Insert
- Xu ly: 1.  tìm MaDangNhap, Sdt trong bảng inserted --> @MaDangNhap, @SDT
		2. kiểm tra nếu @MaDangNhap không bằng 12 ký tự --> 'Mã đăng nhập phải có đúng 12 ký tự' + rollback
		3. kiểm tra nếu @SDT không bằng 10 ký tự --> 'Số điện thoại phải có đúng 10 chữ số' + rollback	
*/
create trigger KiemTraThemNhanVien 
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
('NV0000001004', '123456789011', 'ABC', 20, 'Quang Ngai', '0965525353', '0987654321', 'ABCDE')
insert into NhanVien values 
('NV0000009', '123456789013', 'ABC', 20, 'Quang Ngai', '0965525374', '0987654321', 'ABCDE')
insert into NhanVien values 
('NV0000001005', '123456789018', 'ABC', 20, 'Quang Ngai', '09655253', '0987654321', 'ABCDE')

/*11.Thu tuc xoa thong bao
- input: MaThongBao
- output: Tra ve chuoi gia tri  ‘Error’ nếu số dòng đã xóa <= 0 / Còn lại là ‘Done’
- process: 1. xóa thông báo, điều kiện MaTB = mã thông báo
			2. kiểm tra xóa thành công hay chưa:	
				2.1 nếu @@rowcount = 0 --> 'Error'
				2.2 Ngược lại: 'Done'
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

/*12. Trigger để xóa thông báo lỗi thời
- Loai: after
- Ky sinh: ThongBao
- Su kien: Insert
- Xu ly: 1. xóa thông báo với điều kiện thời gian đã qua 1 năm: 
			ThoiGianThongBao < dateadd(year, -1, getdate())
*/
create trigger XoaThongBaoTuDong
on ThongBao
after insert
as
begin
    delete from ThongBao
    where ThoiGianThongBao < dateadd(year, -1, getdate())
end

insert into ThongBao 
values ('1002', 'Thông báo khuyến mãi trà sữa', '2023-11-21 16:12:58.487', 'Giảm giá 15% cho các loại trà sữa')
select*from ThongBao

/*13. Trigger kiểm tra tính hợp lệ của lương
- Loai: after
- Ky sinh: Luong
- Su kien: Insert, update
- Xu ly: 1. lấy MaBangLuong, TienLuong từ bảng inserted → @MaBangLuong, @TienLuong
		2. lấy MaDangNhap từ bảng LuongNV --> @MaDangNhap
		3. lấy Capbac từ bảng CapBacNV --> @CapBac
		4. tính lương mỗi giờ:	- Nếu cấp bậc = S1 -- > 15000
								-  Nếu cấp bậc = S2 -- > 17000
								- Nếu cấp bậc = SS -- > 20000
								- Còn lại là 0
		5. kiểm tra lương có hợp lý không: (ít nhất một tháng làm 12 ca và nhiều nhất làm 20 ca (1 ca làm có 5 tiếng))
			5.1 Nếu không: print  'Lương không hợp lệ! Vui lòng kiểm tra lại' + rollback
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
values ('SS01', 160, 9365, 100000)
