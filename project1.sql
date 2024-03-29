select * from public.sales_dataset_rfm_prj
-- 1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN priceeach TYPE numeric USING (TRIM(priceeach)::numeric);

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN quantityordered TYPE integer USING (trim(quantityordered)::integer);

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN sales TYPE numeric USING (trim(sales)::numeric);

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN orderdate TYPE date USING (to_date(trim(orderdate), 'YYYY-MM-DD'));

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN msrp TYPE integer USING (trim(msrp)::integer);

--2. Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
SELECT
  COUNT(*) AS total_records,
  COUNT(CASE WHEN ordernumber IS NULL THEN 1 END) AS ordernumber_null_count,
  COUNT(CASE WHEN quantityordered IS NULL THEN 1 END) AS quantityordered_null_count,
  COUNT(CASE WHEN priceeach IS NULL THEN 1 END) AS priceeach_null_count,
  COUNT(CASE WHEN orderlinenumber IS NULL THEN 1 END) AS orderlinenumber_null_count,
  COUNT(CASE WHEN sales IS NULL THEN 1 END) AS sales_null_count,
  COUNT(CASE WHEN orderdate IS NULL THEN 1 END) AS orderdate_null_count
FROM SALES_DATASET_RFM_PRJ;

/*3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường.*/
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN CONTACTLASTNAME VARCHAR(255),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255);

-- Tìm vị trí của dấu gạch ngang
UPDATE SALES_DATASET_RFM_PRJ
SET
  CONTACTLASTNAME = SUBSTRING(contactfullname FROM 1 FOR POSITION('-' IN contactfullname) - 1),
  CONTACTFIRSTNAME = SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname) + 1);
-- Chuyển đổi chuỗi sau khi tách
UPDATE SALES_DATASET_RFM_PRJ
SET
  CONTACTLASTNAME = CONCAT(UPPER(LEFT(contactfullname, 1)), LOWER(SUBSTRING(contactfullname, 2, POSITION('-' IN contactfullname) - 2))),
  CONTACTFIRSTNAME = CONCAT(UPPER(SUBSTRING(contactfullname, POSITION('-' IN contactfullname) + 1, 1)), LOWER(SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname) + 2)));

/*4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE */
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN QTR_ID INT,
ADD COLUMN MONTH_ID INT,
ADD COLUMN YEAR_ID INT;

UPDATE SALES_DATASET_RFM_PRJ
SET
  QTR_ID = EXTRACT(QUARTER FROM TO_TIMESTAMP(ORDERDATE, 'MM/DD/YYYY HH24:MI')),
  MONTH_ID = EXTRACT(MONTH FROM TO_TIMESTAMP(ORDERDATE, 'MM/DD/YYYY HH24:MI')),
  YEAR_ID = EXTRACT(YEAR FROM TO_TIMESTAMP(ORDERDATE, 'MM/DD/YYYY HH24:MI'));

/*Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó*/
-- Sử dụng IQR/BOX PLOT tìm ra outlier
WITH twt_min_max_value as(
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3
  FROM SALES_DATASET_RFM_PRJ
),
OutlierRange AS (
  SELECT
    Q1,
    Q3,
    (Q3 - Q1) * 1.5 AS IQR,
    Q1 - (Q3 - Q1) * 1.5 AS Min_value
    Q3 + (Q3 - Q1) * 1.5 AS Max_value
  FROM twt_min_max_value
)
SELECT *
FROM SALES_DATASET_RFM_PRJ, OutlierRange
WHERE quantityordered < Min_value
   OR quantityordered > Max_value;
--cách 2: sử dụng Z-score = (users-avg)/stddev
WITH cte AS(
  SELECT
    AVG(quantityordered) AS mean,
    STDDEV(quantityordered) AS stddev
  FROM SALES_DATASET_RFM_PRJ
), ZScores AS (
  SELECT
    ordernumber,
    quantityordered,
    (quantityordered - mean) / stddev AS zscore
  FROM SALES_DATASET_RFM_PRJ, Stats
)
SELECT *
FROM cte
WHERE ABS(zscore) > 3;

/*6. khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN*/
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT *
FROM SALES_DATASET_RFM_PRJ;
