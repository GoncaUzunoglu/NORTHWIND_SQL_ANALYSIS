CASE_1 KATEGORİLERE GÖRE SATIŞ ANALİZİ

-- Ürün kategorilerine göre satış performansını değerlendirmek istiyoruz.
-- Hangi ürün kategorilerinin daha popüler olduğunu ve hangi kategorilerin daha fazla gelir getirdiğini belirlemek için bir analiz yaptığımızda

-- Her bir ürün kategorisinin:
-- Toplam sipariş sayısı,
-- Toplam satış miktarı,
-- Toplam gelir,
-- Ortalama satış miktarı  gibi bilgiler içeren bir rapor oluşturulacak.

-- Bu rapor, hangi kategorilerin daha fazla satıldığını ve hangi kategorilerin daha fazla gelir elde ettiğini belirlemek için kullanılacak.

-- Analiz Sonuçları:

-- Hangi ürün kategorilerinin daha popüler olduğunu ve müşterilerin hangi ürün kategorilerine daha fazla ilgi gösterdiğini belirlemek için kullanılabilir.
-- Hangi kategorilerin daha fazla gelir getirdiğini ve bu kategorilerin özelliklerini inceleyerek pazarlama stratejileri optimize edilebilir.




	SELECT
    c.category_name AS "Kategori",
    COUNT(DISTINCT o.order_id) AS "Sipariş Sayısı",
    SUM(od.quantity) AS "Toplam Satış Miktarı",
    CAST(SUM(od.quantity * od.unit_price) AS NUMERIC(10, 2)) AS "Toplam Gelir",
    CAST(AVG(od.quantity) AS NUMERIC(10, 2)) AS "Ortalama Satış Miktarı"
FROM
    categories c
LEFT JOIN
    products p ON c.category_id = p.category_id
LEFT JOIN
    order_details od ON p.product_id = od.product_id
LEFT JOIN
    orders o ON od.order_id = o.order_id
GROUP BY
    c.category_name
ORDER BY
    "Toplam Gelir" DESC;
-------------------------------------------------------------------------------------------------------------------------------------------


CASE_2 ÜRÜN_SATIŞ ANALİZİ

--Ürünlerin satış performansını analiz etmek istiyoruz.
--Şirket, hangi ürünlerin daha popüler olduğunu ve hangi ürünlerin daha fazla gelir getirdiğini belirlemek istiyor.

--Ürünlerin Satış Analizi:

--Hangi ürünlerin daha fazla satıldığını ve daha fazla gelir elde ettiğini görmek için herbir ürün için toplam sipariş sayısı ve toplam gelir analizi yapılacak.
--Ürün ID'si,
--ürün adı,
--kategori,
--sipariş tarihi,
--toplam sipariş sayısı,
--toplam satış miktarı,
--toplam fiyat ,
--toplam indirim        gibi bilgiler içeren bir rapor oluşturulacak.

--Bu rapor, ürünlerin performansını değerlendirmek ve pazarlama stratejilerini optimize etmek için kullanılacak.

--Analiz Sonuçları:

--En çok sipariş edilen ürünler belirlenecek ve bu ürünlerin hangi kategorilere ait olduğu incelenecek.
--Hangi ürünlerin en yüksek geliri sağladığı ve bu ürünlerin özellikleri üzerinde durulacak.
--Toplam indirim miktarı üzerinden müşterilere sunulan avantajlar değerlendirilecek ve indirimlerin satış
--performansına etkisi analiz edilecek.
--Northwind şirketinin ürünlerin satış performansını değerlendirmesi ve stratejik kararlar alması
--için kapsamlı bir analiz sunar.
	
	SELECT
    p.product_id AS "Ürün ID",
    p.product_name AS "Ürün Adı",
    c.category_name AS "Kategori",
    TO_CHAR(o.order_date, 'DD-MM-YYYY') AS "Sipariş Tarihi",
    COUNT(o.order_id) AS "Toplam Sipariş Sayısı",
    SUM(od.quantity) AS "Toplam Satış Miktarı",
    SUM(od.unit_price * od.quantity) AS "Toplam Fiyat",
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS "Toplam İndirim",
    CASE 
        WHEN SUM(od.quantity * od.unit_price) = 0 THEN 0 -- İndirim miktarı sıfırsa, indirim yüzdesi 0 olacak
        ELSE CAST(SUM((od.unit_price * od.quantity * od.discount) / (od.unit_price * od.quantity)) * 100 AS NUMERIC(10, 2)) 
    END AS "Toplam İndirim Yüzdesi"
FROM
    products p
INNER JOIN
    categories c ON p.category_id = c.category_id
INNER JOIN
    order_details od ON p.product_id = od.product_id
INNER JOIN
    orders o ON od.order_id = o.order_id
GROUP BY
    p.product_id, p.product_name, c.category_name, o.order_date
ORDER BY
    "Toplam Sipariş Sayısı" DESC;
	
	--------------------------------------------------------------------------------------------------------------------------------------------
	CASE_3 MÜŞTERİ ANALİZİ

--Müşterilerin satın alma alışkanlıklarını ve harcama eğilimlerini anlamak ve müşteri tabanını daha iyi hedeflemek için müşteri analizi yapmak istiyorIZ.

--Her bir müşterinin;
--toplam sipariş sayısını
--toplam harcamasını
--ortalama sipariş değerini analiz edilecek

--Müşteri ID'si
--şirket adı, 
--ülke,
--toplam sipariş sayısı, 
--toplam harcama
--ortalama sipariş değeri gibi bilgiler içeren bir rapor oluşturulacak.

--Bu rapor, hangi müşterilerin daha fazla alışveriş yaptığını ve ne kadar harcama yaptığını belirlemek için kullanılacak.

--Analiz Sonuçları:

--En çok sipariş veren müşteriler belirlenecek ve bu müşterilerin hangi ülkelerden olduğu incelenecek.
--Müşterilerin harcama alışkanlıkları ve ortalama sipariş değerleri üzerinde durulacak.
--Müşteri segmentasyonu ve özelleştirilmiş pazarlama stratejileri için veri tabanı analizi sağlayacak.
--Bu senaryo, Northwind şirketinin müşteri tabanını anlaması ve stratejik kararlar alması için önemli bir analiz sağlar. 
--Müşteri analizi, şirketin pazarlama, satış ve müşteri hizmetleri stratejilerini optimize etmesine yardımcı olabilir.


SELECT
    c.customer_id AS "Müşteri ID",
    c.company_name AS "Şirket Adı",
    c.city AS "Şehir",
    c.country AS "Ülke",
    c.contact_name AS "Müşteri Adı ",
    COUNT(o.order_id) AS "Toplam Sipariş Sayısı",
    SUM(od.quantity * od.unit_price) AS "Toplam Harcama",
    AVG(od.quantity * od.unit_price) AS "Ortalama Sipariş Fiyatı"
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.customer_id
LEFT JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY
    c.customer_id, c.company_name, c.city, c.country, c.contact_name
ORDER BY
    "Toplam Sipariş Sayısı" DESC;
------------------------------------------------------------------------------------------------------------------
CASE_4 PERSONEL PERFORMANSI


SELECT * FROM employees;

--En çok satış yapan personeli bulmak için, her bir personelin toplam satış miktarını hesaplamamız gerekiyor.

SELECT
    e.employee_id AS "Personel ID",
    CONCAT(e.first_name, ' ', e.last_name) AS "Personel Adı",
    COUNT(DISTINCT o.order_id) AS "Toplam Satış Sayısı"
FROM
    employees e
LEFT JOIN
    orders o ON e.employee_id = o.employee_id
GROUP BY
    e.employee_id, e.first_name, e.last_name
ORDER BY "Toplam Satış Sayısı" DESC
 
 
 --Personellerin satış performansını değerlendirmemiz ve hangi personellerin daha fazla gelir elde ettiğini ve daha yüksek ortalama sipariş değerlerine 
--sahip olduğunu belirlememiz isteniyor


SELECT
    e.employee_id AS "Personel ID",
    CONCAT(e.first_name, ' ', e.last_name) AS "Personel Adı",
    COUNT(DISTINCT o.order_id) AS "Toplam Satış Sayısı",
    ROUND(SUM(od.quantity * od.unit_price)::NUMERIC, 2) AS "Toplam Gelir",
    ROUND(AVG(od.unit_price)::NUMERIC, 2) AS "Ortalama Birim Fiyat"
FROM
    employees e
LEFT JOIN
    orders o ON e.employee_id = o.employee_id
LEFT JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY
    e.employee_id, e.first_name, e.last_name
ORDER BY
    "Toplam Satış Sayısı" DESC;


--Bu analiz, her bir personelin hangi kategorilerde daha başarılı olduğunu belirlemenize yardımcı olabilir ve işletmenin hangi 
--kategorilerde daha fazla satış yapabileceğini anlamamıza yardımcı olur.


SELECT
    e.employee_id AS "Personel ID",
    CONCAT(e.first_name, ' ', e.last_name) AS "Personel Adı",
    c.category_name AS "Kategori Adı",
    COUNT(DISTINCT o.order_id) AS "Toplam Satış Sayısı",
    ROUND(SUM(od.quantity * od.unit_price)::NUMERIC, 2) AS "Toplam Gelir",
    ROUND(AVG(od.unit_price)::NUMERIC, 2) AS "Ortalama Birim Fiyat"
FROM
    employees e
LEFT JOIN
    orders o ON e.employee_id = o.employee_id
LEFT JOIN
    order_details od ON o.order_id = od.order_id
LEFT JOIN
    products p ON od.product_id = p.product_id
LEFT JOIN
    categories c ON p.category_id = c.category_id
GROUP BY
    e.employee_id, e.first_name, e.last_name, c.category_name
ORDER BY
    e.employee_id, "Toplam Gelir" DESC;


--Şirketin iş süreçlerini yöneten bir satış ekibi var. Bu ekibin performansını izlemek ve analiz etmek
--için bir rapor oluşturulması gerekiyor. Bu rapor, her bir çalışanın satış performansını ayrıntılı bir şekilde göstermelidir.

--Her bir çalışanın ;
--adı soyadı, 
--çalışan ID'si, 
--toplam sipariş sayısı, 
--toplam satış miktarı, 
--toplam gelir ve ortalama satış miktarı bilgilerini içermelidir.



SELECT
    e.employee_id AS "Çalışan ID",
    CONCAT(e.first_name, ' ', e.last_name) AS "Çalışan Adı",
    COUNT(o.order_id) AS "Toplam Sipariş Sayısı",
    SUM(od.quantity) AS "Toplam Satış Miktarı",
    SUM(od.quantity * od.unit_price) AS "Toplam Gelir",
    AVG(od.quantity) AS "Ortalama Satış Miktarı",
    TO_CHAR(o.order_date, 'DD-MM-YYYY') AS "Sipariş Tarihi"  -- Sipariş tarihi sütunu formatlandı
FROM
    employees e
LEFT JOIN
    orders o ON e.employee_id = o.employee_id
LEFT JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY
    e.employee_id, e.first_name, e.last_name, o.order_date  -- Sipariş tarihi sütunu gruplama kriterleri arasına eklendi
ORDER BY
    "Toplam Sipariş Sayısı" DESC;
-----------------------------------------------------------------------------------------------------------------------------

CASE_5 SEVKİYAT ŞİRKETİ PERFORMANS ANALİZİ


--Sevkiyat yapan şirketleri bulmak için, siparişlerin gönderildiği şirketleri listelememiz gerekiyor.



SELECT DISTINCT shipper_id, company_name AS "Sevkiyat Yapan Şirketler"
FROM shippers;
 
--Sevkiyat yapan şirketlerin yıllık toplam sipariş sayısını ülke bazında bulmak için,

--siparişlerin gönderildiği tarihleri ve sevkiyat yapan şirketlerin ülke bilgilerini içeren verilere ihtiyacımız var.

---YIL  BAZINDA


SELECT
    s.shipper_id,
    s.company_name AS "Şirket Adı",
    EXTRACT(YEAR FROM o.shipped_date) AS "Yıl",
    COUNT(DISTINCT o.order_id) AS "Toplam Sipariş Sayısı",
   c.country AS "Ülke"
FROM
    shippers s
LEFT JOIN
    orders o ON s.shipper_id = o.ship_via
LEFT JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY
    s.shipper_id, s.company_name, EXTRACT(YEAR FROM o.shipped_date), c.country
ORDER BY
    "Yıl", "Toplam Sipariş Sayısı" DESC;



-----
SELECT
    s.company_name AS "Şirket Adı",
    COUNT(o.order_id) AS "Toplam Sipariş Sayısı",
    SUM(od.quantity) AS "Toplam Ürün Adedi",
    SUM(od.quantity * od.unit_price) AS "Toplam Gelir"
FROM
    shippers s
LEFT JOIN
    orders o ON s.shipper_id = o.ship_via
LEFT JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY
    s.company_name
ORDER BY
    "Toplam Sipariş Sayısı" DESC;
	
	----------------4
	SELECT
    s.shipper_id,
    s.company_name AS "Şirket Adı",
    TO_CHAR(o.shipped_date, 'DD-MM-YYYY') AS "Sevkiyat Tarihi",
    ROUND(AVG(EXTRACT(DAY FROM (o.shipped_date - o.order_date) * INTERVAL '1 DAY'))::NUMERIC, 0) AS "Ortalama Sipariş Teslim Süresi",
    COUNT(DISTINCT o.order_id) AS "Toplam Sipariş Sayısı",
    SUM(od.quantity * od.unit_price) AS "Toplam Gelir",
    c.country AS "Ülke"
FROM
    shippers s
LEFT JOIN
    orders o ON s.shipper_id = o.ship_via
LEFT JOIN
    customers c ON o.customer_id = c.customer_id
LEFT JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY
    s.shipper_id, s.company_name, o.shipped_date, c.country
ORDER BY
    "Sevkiyat Tarihi", "Toplam Sipariş Sayısı" DESC;


-- NORTHWİND şirketi, siparişlerin zamanında ve hızlı bir şekilde müşterilere ulaştırılmasını sağlamak istiyor.
--Bu nedenle, şirketin farklı kargo şirketleriyle olan işbirliğinin sevkiyat performansını nasıl etkilediğini analiz etmek istiyoruz.

--Her kargo şirketi için sevkiyat tarihine göre ortalama teslim süresi ve toplam sipariş sayısı.
--Sipariş sayısına göre sıralanmış bir liste, her bir kargo şirketi için sevkiyat tarihi bazında ortalama teslim süresi ile birlikte.
--şirketin sevkiyat performansını değerlendirmek ve kargo şirketleri arasındaki performans farklarını belirlemek için kullanılabilir.


SELECT
    s.shipper_id,
    s.company_name AS "Şirket Adı",
    TO_CHAR(o.shipped_date, 'DD-MM-YYYY') AS "Sevkiyat Tarihi",
    ROUND(AVG(EXTRACT(DAY FROM (o.shipped_date - o.order_date) * INTERVAL '1 DAY'))::NUMERIC, 0) AS "Ortalama Sipariş Teslim Süresi",
    COUNT(DISTINCT o.order_id) AS "Toplam Sipariş Sayısı",
    c.country AS "Ülke"
FROM
    shippers s
LEFT JOIN
    orders o ON s.shipper_id = o.ship_via
LEFT JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY
    s.shipper_id, s.company_name, o.shipped_date, c.country
ORDER BY
    "Sevkiyat Tarihi", "Toplam Sipariş Sayısı" DESC;
	--------------------------------------------------------------------------------
	
	CASE_6 MÜŞTERİ SEGMENTASYONU VE SATIN ALMA DAVRANIŞI ANALİZİ

-- Müşteri segmentasyonu ve satın alma davranışını anlamak için bir analiz yapılacak.
-- Müşterilerin farklı segmentlere ayrılması ve her segmentin satın alma davranışı incelenecek.

-- Müşteri segmentlerinin oluşturulması için birkaç faktör kullanılabilir, örneğin:
-- Toplam harcama miktarı,
-- Sipariş sayısı,
-- Ortalama sipariş değeri gibi.

-- Her bir müşteri segmentinin:
-- Toplam müşteri sayısı,
-- Toplam harcama miktarı,
-- Ortalama sipariş sayısı ve değeri gibi bilgiler içeren bir rapor oluşturulacak.

-- Bu rapor, müşteri segmentlerini anlamanıza ve pazarlama stratejilerimizi belirlememize yardımcı olacaktır.

-- Analiz Sonuçları:
-- Hangi müşteri segmentlerinin daha karlı olduğunu belirlemek için kullanılabilir.
-- Her bir segmentin satın alma davranışını anlayarak özelleştirilmiş pazarlama stratejileri geliştirebiliriz.


SELECT
    "Müşteri Segmenti",
    COUNT(DISTINCT customer_id) AS "Toplam Müşteri Sayısı",
    SUM(total_amount) AS "Toplam Harcama",
    AVG(order_count) AS "Ortalama Sipariş Sayısı",
    AVG(ortalama_siparis_degeri) AS "Ortalama Sipariş Değeri"
FROM
    (
        SELECT
            c.customer_id,
            CASE
                WHEN SUM(od.quantity * od.unit_price) <= 1000 THEN 'Düşük Harcama'
                WHEN SUM(od.quantity * od.unit_price) > 1000 AND SUM(od.quantity * od.unit_price) <= 5000 THEN 'Orta Harcama'
                ELSE 'Yüksek Harcama'
            END AS "Müşteri Segmenti",
            COUNT(DISTINCT o.order_id) AS "order_count",
            SUM(od.quantity * od.unit_price) AS "total_amount",
            AVG(od.quantity * od.unit_price) AS "ortalama_siparis_degeri"
        FROM
            customers c
        LEFT JOIN
            orders o ON c.customer_id = o.customer_id
        LEFT JOIN
            order_details od ON o.order_id = od.order_id
        GROUP BY
            c.customer_id
    ) AS segment_summary
GROUP BY
    "Müşteri Segmenti"
ORDER BY
    "Toplam Harcama" DESC;
