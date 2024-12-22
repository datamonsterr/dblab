-- Test login / signup
DELETE FROM customer WHERE username in ('test_1', 'test_2');
SELECT sign_up('test_1', 'test_1@gmail.com', '0123456789', '1999-09-19', 'abcxyz123456');
SELECT sign_up('test_2', 'test_2@gmail.com', '0123456789', '1997-07-17', '123456');
SELECT * FROM customer WHERE username in ('test_1', 'test_2');

SELECT login('test_2', '12345678');

-- Test movie
SELECT add_movie('test 1', 'English','This is a test', CURRENT_DATE, 'abc.com', 123);



