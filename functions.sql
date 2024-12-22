-- Login / Signup
CREATE OR REPLACE FUNCTION login(p_username VARCHAR, p_password VARCHAR)
    RETURNS INT AS $$
DECLARE
    user_count INT;
    is_valid BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO user_count
    FROM Customer
    WHERE username = p_username;

    IF user_count = 0 THEN
        RETURN 0; -- No account found
    END IF;

    SELECT crypt(p_password, password) = password INTO is_valid
    FROM Customer
    WHERE username = p_username;

    IF is_valid THEN
        RETURN 1; -- Login successfully
    ELSE
        RETURN -1; -- Wrong password
    end if;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sign_up(
    p_username VARCHAR,
    p_email VARCHAR, p_phone VARCHAR,
    p_dob DATE,
    p_password VARCHAR
)
    RETURNS INT AS $$
DECLARE
    user_exists INT;
    hashed VARCHAR;
BEGIN
    SELECT COUNT(*) INTO user_exists
    FROM Customer
    WHERE username = p_username OR email = p_email;

    IF user_exists > 0 THEN
        RETURN 0; -- User already exists
    ELSE
        SELECT crypt(p_password, gen_salt('bf')) INTO hashed;

        INSERT INTO customer(username, email, phone, dob, password)
        VALUES (p_username, p_email, p_phone, p_dob, hashed);
        RETURN 1; -- User created successfully
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Movie
CREATE OR REPLACE FUNCTION add_movie(
    p_title VARCHAR,
    p_original_language VARCHAR,
    p_tagline TEXT,
    p_release_date DATE,
    p_url TEXT,
    p_length INT
)
    RETURNS INT AS $$
BEGIN
    INSERT INTO Movie (title, tagline, original_language, status, release_date, poster_url, length)
    VALUES (p_title, p_tagline, p_original_language, 'Active', p_release_date, p_url, p_length);
    RETURN 1; -- Movie added successfully
END;
$$ LANGUAGE plpgsql;

-- Schedule