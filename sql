CREATE TABLE big_test (
    id BIGSERIAL,
    data TEXT
);

psql -U postgres -d testdb -c "
INSERT INTO big_test (data)
SELECT repeat(md5(random()::text), 25000)
FROM generate_series(1,40000);
"
