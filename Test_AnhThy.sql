/*Bài tập 1 (Python hoặc SQL) */

-- Tạo bảng và chèn dữ liệu
CREATE TABLE StockPrices (
    no INT PRIMARY KEY,
    date DATE,
    stock CHAR(1),
    price INT
);

INSERT INTO StockPrices (no, date, stock, price) VALUES
(1, '1997-05-20', 'A', 26),
(2, '1997-05-21', 'A', 25),
(3, '1997-05-23', 'A', 30),
(4, '1997-05-24', 'A', 28),
(5, '1997-05-27', 'A', 34),
(6, '1997-05-28', 'A', NULL),
(7, '1997-05-29', 'A', 26),
(8, '1997-08-29', 'B', NULL),
(9, '1997-09-01', 'B', 20),
(10, '1997-09-02', 'B', 35),
(11, '1997-09-04', 'B', 39);

--Truy vấn để cập nhật dữ liệu giá bị thiếu
WITH CTE AS (
    SELECT 
        no,
        date,
        stock,
        price,
        LAG(price) OVER (PARTITION BY stock ORDER BY date) AS prev_price,
        LEAD(price) OVER (PARTITION BY stock ORDER BY date) AS next_price
    FROM 
        StockPrices
)
UPDATE StockPrices
SET price = COALESCE(
        (SELECT prev_price FROM CTE WHERE CTE.no = StockPrices.no),
        (SELECT next_price FROM CTE WHERE CTE.no = StockPrices.no)
    )
WHERE price IS NULL;
-- Truy vấn để xem kết quả
SELECT * FROM StockPrices ORDER BY stock, date;


/* Bài tập 2 multi booking (SQL): */
USE draft;
GO
DROP TABLE IF EXISTS gap;
CREATE TABLE gap (
    cusid INT,
    booking_id INT,
    start_time INT,
    end_time INT
);
INSERT INTO gap (cusid, booking_id, start_time, end_time) VALUES
(1, 1, 5, 8),
(1, 2, 9, 13),
(1, 3, 10, 12),
(1, 4, 11, 12),
(1, 5, 10, 13),
(1, 9, 9, 10),
(1, 6, 20, 23),
(2, 8, 10, 12),
(2, 9, 9, 11),
(2, 10, 9, 10),
(2, 11, 14, 16),
(2, 13, 17, 19),
(2, 14, 18, 20),
(2, 15, 19, 21),
(2, 15, 20, 23);
SELECT * FROM gap ORDER BY cusid, start_time;
SELECT 
    g1.cusid,
    g1.booking_id,
    g1.start_time,
    g1.end_time,
    LAG(g1.end_time, 1) OVER (PARTITION BY g1.cusid ORDER BY g1.start_time, g1.end_time) AS prev_end,
    LEAD(g1.start_time, 1) OVER (PARTITION BY g1.cusid ORDER BY g1.start_time, g1.end_time) AS is_start,
    DENSE_RANK() OVER (PARTITION BY g1.cusid ORDER BY g1.start_time) AS [group], -- Changed 'group' to [group]
    CASE 
        WHEN LAG(g1.end_time) OVER (PARTITION BY g1.cusid ORDER BY g1.start_time, g1.end_time) IS NOT NULL 
             AND LAG(g1.end_time) OVER (PARTITION BY g1.cusid ORDER BY g1.start_time, g1.end_time) > g1.start_time 
             THEN 'Multi Booking'
        WHEN LEAD(g1.start_time) OVER (PARTITION BY g1.cusid ORDER BY g1.start_time, g1.end_time) IS NOT NULL 
             AND LEAD(g1.start_time) OVER (PARTITION BY g1.cusid ORDER BY g1.start_time, g1.end_time) < g1.end_time 
             THEN 'Multi Booking'
        ELSE 'Single Booking'
    END AS booking_type
FROM 
    gap g1
ORDER BY 
    g1.cusid, 
    g1.start_time;


/*Bài tập 3 Phân bổ lead (SQL) */
-- Tạo bảng NhomKH để lưu danh sách khách hàng và nhóm của họ
CREATE TABLE NhomKH (
    MaKH INT,
    Nhom VARCHAR(10)
);
-- Tạo bảng KetQua để lưu kết quả phân phối
CREATE TABLE KetQua (
    MaKH INT,
    Nhom VARCHAR(10),
    NhomCon CHAR(1)
);
-- Tạo bảng cấu hình để quản lý phân phối
CREATE TABLE DistributionConfig (
    NhomKH VARCHAR(10),
    NhomCon CHAR(1),
    TyTrongMin FLOAT,
    TyTrongMax FLOAT,
    PRIMARY KEY (NhomKH, NhomCon)
);
-- Chèn dữ liệu cấu hình cho từng nhóm và kênh phân phối
INSERT INTO DistributionConfig (NhomKH, NhomCon, TyTrongMin, TyTrongMax) VALUES
('HOT', 'A', 0.0, 0.4),
('HOT', 'B', 0.4, 0.7),
('HOT', 'C', 0.7, 1.0),
('Normal', 'A', 0.0, 0.3),
('Normal', 'B', 0.3, 0.6),
('Normal', 'C', 0.6, 1.0),
('Hard Rock', 'A', 0.0, 0.1),
('Hard Rock', 'B', 0.1, 0.4),
('Hard Rock', 'C', 0.4, 1.0);
-- Sử dụng số phát sinh ngẫu nhiên từ master.dbo.spt_values để tạo dữ liệu
DECLARE @TotalHOT INT = 400, @TotalNormal INT = 350, @TotalHardRock INT = 350;

-- Chèn các khách hàng HOT
;WITH NumberedKH AS (
    SELECT TOP (@TotalHOT) 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS MaKH
    FROM master.dbo.spt_values
)
INSERT INTO NhomKH (MaKH, Nhom)
SELECT MaKH, 'HOT' AS Nhom FROM NumberedKH;

-- Chèn các khách hàng Normal
;WITH NumberedKH AS (
    SELECT TOP (@TotalNormal) 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS MaKH
    FROM master.dbo.spt_values
)
INSERT INTO NhomKH (MaKH, Nhom)
SELECT MaKH + @TotalHOT, 'Normal' AS Nhom FROM NumberedKH;

-- Chèn các khách hàng Hard Rock
;WITH NumberedKH AS (
    SELECT TOP (@TotalHardRock) 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS MaKH
    FROM master.dbo.spt_values
)
INSERT INTO NhomKH (MaKH, Nhom)
SELECT MaKH + @TotalHOT + @TotalNormal, 'Hard Rock' AS Nhom FROM NumberedKH;
-- Phân phối khách hàng dựa trên cấu hình
WITH CTE_RankedKH AS (
    SELECT 
        MaKH, 
        Nhom, 
        CAST(ROW_NUMBER() OVER (PARTITION BY Nhom ORDER BY MaKH) AS FLOAT) / COUNT(*) OVER (PARTITION BY Nhom) AS Ratio
    FROM NhomKH
)
INSERT INTO KetQua (MaKH, Nhom, NhomCon)
SELECT 
    rk.MaKH, 
    rk.Nhom, 
    dc.NhomCon
FROM 
    CTE_RankedKH rk
JOIN 
    DistributionConfig dc ON rk.Nhom = dc.NhomKH
WHERE 
    rk.Ratio > dc.TyTrongMin AND rk.Ratio <= dc.TyTrongMax;

SELECT * FROM KetQua ORDER BY Nhom, NhomCon, MaKH;

