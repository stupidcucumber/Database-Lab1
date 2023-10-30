CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR,

    last_date TIMESTAMP,
    last_user TEXT
);

CREATE TABLE sponsors (
    sponsor_id SERIAL PRIMARY KEY,
    sponsor_name VARCHAR,

    last_date TIMESTAMP,
    last_user TEXT
);

CREATE TABLE positions (
    position_id SERIAL PRIMARY KEY,
    position_name VARCHAR,

    last_date TIMESTAMP,
    last_user TEXT
);

CREATE TABLE stadiums (
    stadium_id SERIAL PRIMARY KEY,
    stadium_name VARCHAR,
    country_id INTEGER,
    capacity INTEGER,

    CONSTRAINT fk_country
                      FOREIGN KEY (country_id)
                      REFERENCES countries(country_id)
);

CREATE TABLE managers (
    manager_id SERIAL PRIMARY KEY,
    manager_name VARCHAR,
    country_id INTEGER,
    salary INTEGER,

    last_date TIMESTAMP,
    last_user TEXT,

    CONSTRAINT fk_country
                      FOREIGN KEY (country_id)
                      REFERENCES countries(country_id)
);

CREATE TABLE presidents (
    president_id SERIAL PRIMARY KEY,
    president_name VARCHAR,
    country_id INTEGER,

    last_date TIMESTAMP,
    last_user TEXT,

    CONSTRAINT fk_country
                        FOREIGN KEY (country_id)
                        REFERENCES countries(country_id)
);

CREATE TABLE referees (
    referee_id SERIAL PRIMARY KEY,
    referee_name VARCHAR,
    country_id INTEGER,

    CONSTRAINT fk_country
                      FOREIGN KEY (country_id)
                      REFERENCES countries(country_id)
);

CREATE TABLE leagues (
    league_id SERIAL PRIMARY KEY,
    league_name VARCHAR,
    country_id INTEGER,

    CONSTRAINT fk_country
                     FOREIGN KEY (country_id)
                     REFERENCES countries(country_id)
);

CREATE TABLE clubs (
    club_id SERIAL PRIMARY KEY,
    manager_id INTEGER,
    president_id INTEGER,
    league_id INTEGER,
    club_name VARCHAR,

    CONSTRAINT fk_manager
                   FOREIGN KEY (manager_id)
                   REFERENCES managers(manager_id),
    CONSTRAINT fk_president
                   FOREIGN KEY (president_id)
                   REFERENCES presidents(president_id),
    CONSTRAINT fk_league
                   FOREIGN KEY (league_id)
                   REFERENCES leagues(league_id)
);

CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    club_id INTEGER,
    player_name VARCHAR,
    country_id INTEGER,
    position_id INTEGER,
    salary INTEGER,
    contract_activated TIMESTAMP,

    last_date TIMESTAMP,
    last_user TEXT,

    CONSTRAINT fk_country
                     FOREIGN KEY (country_id)
                     REFERENCES countries(country_id),
    CONSTRAINT fk_position
                     FOREIGN KEY (position_id)
                     REFERENCES positions(position_id),
    CONSTRAINT fk_club
                     FOREIGN KEY (club_id)
                     REFERENCES clubs(club_id)
);

CREATE TABLE positioning (
    positioning_id SERIAL PRIMARY KEY,
    position_id INTEGER,
    player_id INTEGER,

    CONSTRAINT fk_position
                         FOREIGN KEY (position_id)
                         REFERENCES positions(position_id),
    CONSTRAINT fk_player
                         FOREIGN KEY (player_id)
                         REFERENCES players(player_id)
);

CREATE TABLE tournaments (
    tournament_id SERIAL PRIMARY KEY,
    tournament_name VARCHAR,
    country_id INTEGER,
    date TIMESTAMP,

    CONSTRAINT fk_country
                         FOREIGN KEY (country_id)
                         REFERENCES countries(country_id)
);

CREATE TABLE matches (
    match_id SERIAL PRIMARY KEY,
    tournament_id INTEGER,
    first_club_id INTEGER,
    second_club_id INTEGER,
    referee_id INTEGER,
    date TIMESTAMP,

    CONSTRAINT fk_tournament
                     FOREIGN KEY (tournament_id)
                     REFERENCES tournaments(tournament_id),
    CONSTRAINT fk_first_club
                     FOREIGN KEY (first_club_id)
                     REFERENCES clubs(club_id),
    CONSTRAINT fk_second_club
                     FOREIGN KEY (second_club_id)
                     REFERENCES clubs(club_id),
    CONSTRAINT fk_referee
                     FOREIGN KEY (referee_id)
                     REFERENCES referees(referee_id)
);



CREATE TABLE sponsoring (
    sponsoring_id SERIAL PRIMARY KEY,
    sponsor_id INTEGER,
    tournament_id INTEGER,

    CONSTRAINT fk_sponsor
                        FOREIGN KEY (sponsor_id)
                        REFERENCES sponsors(sponsor_id),
    CONSTRAINT fk_tournament
                        FOREIGN KEY (tournament_id)
                        REFERENCES tournaments(tournament_id)
);

CREATE TABLE winners (
    winner_id SERIAL PRIMARY KEY,
    tournament_id INTEGER,
    club_id INTEGER,

    CONSTRAINT fk_tournament
                    FOREIGN KEY (tournament_id)
                    REFERENCES tournaments(tournament_id),
    CONSTRAINT fk_club
                    FOREIGN KEY (club_id)
                    REFERENCES clubs(club_id)
);


-- Defining triggers, functions and other stuff
CREATE OR REPLACE FUNCTION sponsor_stamp() RETURNS trigger AS $sponsor_stamp$
    BEGIN
        IF NEW.sponsor_name IS NULL THEN
            RAISE EXCEPTION 'Sponsor name cannot be empty!';
        end if;

        NEW.last_date := current_timestamp;
        NEW.last_user := current_user;

        RETURN NEW;
    END;
$sponsor_stamp$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION player_stamp() RETURNS trigger AS $player_stamp$
    BEGIN
        IF NEW.player_name IS NULL THEN
            RAISE EXCEPTION 'Player name cannot be empty!';
        END IF;

        IF NEW.country_id IS NULL THEN
            RAISE EXCEPTION 'Players country cannot be empty!';
        END IF;

        IF NEW.salary < 0 THEN
            RAISE EXCEPTION 'Player salary cannot be negative!';
        end if;

        NEW.last_date := current_timestamp;
        NEW.last_user := current_user;

        RETURN NEW;
    END;
$player_stamp$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION validate_match() RETURNS trigger AS $validate_match$
    BEGIN
        IF NEW.first_club_id = NEW.second_club_id THEN
            RAISE EXCEPTION 'It cannot be the same club!';
        END IF;
    END;
$validate_match$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION president_stamp() RETURNS TRIGGER AS $president_stamp$
    BEGIN
        IF NEW.president_name IS NULL THEN
            RAISE EXCEPTION 'President name cannot be null!';
        end if;

        NEW.last_date := current_timestamp;
        NEW.last_user := current_user;

        RETURN NEW;
    END;
$president_stamp$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION country_stamp() RETURNS trigger as $country_stamp$
    BEGIN
        IF NEW.country_name IS NULL THEN
            RAISE EXCEPTION 'Country name cannot be empty!';
        end if;

        NEW.last_date := current_timestamp;
        NEW.last_user := current_user;

        RETURN NEW;
    END;
$country_stamp$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION stadium_stamp() RETURNS trigger as $stadium_stamp$
    BEGIN
        IF NEW.stadium_name IS NULL THEN
            RAISE EXCEPTION 'Stadium name cannot be empty!';
        end if;

        IF NEW.capacity < 0 THEN
            RAISE EXCEPTION 'Stadium capacity cannot be negative!';
        end if;

        RETURN NEW;
    END;
$stadium_stamp$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION manager_stamp() RETURNS trigger as $manager_stamp$
    BEGIN
        IF NEW.manager_name IS NULL THEN
            RAISE EXCEPTION 'Manager name cannot be null!';
        END IF;

        IF NEW.salary IS NULL OR NEW.salary < 0 THEN
            RAISE EXCEPTION 'Salary cannot be null or empty!';
        END IF;

        NEW.last_date := current_timestamp;
        NEW.last_user := current_user;

        RETURN NEW;
    END;
$manager_stamp$ LANGUAGE plpgsql;


CREATE PROCEDURE raise_manager_salary(_manager_id INTEGER, new_salary INTEGER)
LANGUAGE SQL
AS $$
    UPDATE managers
    SET salary = new_salary
    WHERE manager_id = _manager_id;
$$;


CREATE PROCEDURE raise_player_salary(_player_id INTEGER, new_salary INTEGER)
LANGUAGE SQL
AS $$
    UPDATE players
    SET salary = new_salary
    WHERE player_id = _player_id;
$$;


CREATE PROCEDURE set_winner(_club_id INTEGER, _tournament_id INTEGER)
LANGUAGE SQL
AS $$
    INSERT INTO winners (tournament_id, club_id) VALUES (_club_id, _tournament_id);
$$;


CREATE OR REPLACE PROCEDURE update_player_position(_player_id INTEGER, _position_name VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    pos INTEGER;
BEGIN
    IF NOT EXISTS (SELECT position_id INTO pos FROM positions WHERE position_name = _position_name ) THEN
        INSERT INTO positions (position_name) VALUES (_position_name);
    END IF;

    UPDATE players
    SET position_id = pos
    WHERE player_id = _player_id;

    SELECT position_id INTO pos
    FROM positions
    WHERE position_name = _position_name;

    insert into positioning (position_id, player_id) VALUES (pos, _player_id);
END;
$$;


CREATE TRIGGER player_stamp BEFORE INSERT OR UPDATE ON players
    FOR EACH ROW EXECUTE FUNCTION player_stamp();
CREATE TRIGGER country_stamp BEFORE INSERT OR UPDATE ON countries
    FOR EACH ROW EXECUTE FUNCTION country_stamp();
CREATE TRIGGER stadium_stamp BEFORE INSERT OR UPDATE ON stadiums
    FOR EACH ROW EXECUTE FUNCTION stadium_stamp();
CREATE TRIGGER sponsor_stamp BEFORE INSERT OR UPDATE ON sponsors
    FOR EACH ROW EXECUTE FUNCTION sponsor_stamp();
CREATE TRIGGER manager_stamp BEFORE INSERT OR UPDATE ON managers
    FOR EACH ROW EXECUTE FUNCTION manager_stamp();
CREATE TRIGGER validate_match BEFORE INSERT OR UPDATE ON matches
    FOR EACH ROW EXECUTE FUNCTION validate_match();
