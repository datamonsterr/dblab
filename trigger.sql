-- trigger for setting status to inactive when adding new schedule
CREATE OR REPLACE FUNCTION update_movie_status_from_today()
    RETURNS TRIGGER AS $$
BEGIN
    -- Check if there are any schedules for the movie from today onwards
    IF NOT EXISTS (
        SELECT 1
        FROM Schedule
        WHERE movie_id = OLD.movie_id
          AND schedule_movie_date >= CURRENT_DATE
    ) THEN
        -- If no schedules exist from today, set the movie status to 'Inactive'
        UPDATE Movie
        SET status = 'Inactive'
        WHERE movie_id = OLD.movie_id;
    ELSE
        UPDATE Movie
        SET status = 'Active'
        WHERE movie_id = OLD.movie_id;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_movie_schedule_from_today
    AFTER DELETE OR UPDATE ON Schedule
    FOR EACH ROW
EXECUTE FUNCTION update_movie_status_from_today();
