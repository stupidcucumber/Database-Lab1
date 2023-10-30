-- Inserting into Tables

insert into countries (country_name) values ('Worldwide'),
                                            ('Europe'),
                                            ('Ukraine'),
                                            ('United Kingdom'),
                                            ('Spain'),
                                            ('Italy'),
                                            ('Germany'),
                                            ('France'),
                                            ('Argentina'),
                                            ('Portugal'),
                                            ('Brazil'),
                                            ('United Arab Emirates'),
                                            ('USA');

insert into sponsors (sponsor_name) values ('Nestle'),
                                           ('Sony Entertainment'),
                                           ('Fly Emirates'),
                                           ('Ford Motors'),
                                           ('Coca Cola'),
                                           ('Nike'),
                                           ('Adidas'),
                                           ('Samsung'),
                                           ('Red Bull'),
                                           ('Pepsi');

insert into positions (position_name) values ('Goalkeeper'),
                                             ('Defender'),
                                             ('Midfielder'),
                                             ('Left Winger'),
                                             ('Right Winger'),
                                             ('Forward');

insert into managers (manager_name, country_id, salary) VALUES ('Pep Guardiola', 5, 15000),
                                                       ('Jose Mourinho', 10, 11500),
                                                       ('Zinedine Zidane', 8, 15000),
                                                       ('Jurgen Klopp', 7, 17000);

insert into presidents (president_name, country_id) VALUES ('Sheikh Mansour', 12),
                                                           ('Thomas Dan Friedkin', 13),
                                                           ('Florentino Perez Rodriguez', 5),
                                                           ('Thomas Charles Werner', 13);

insert into leagues (league_name, country_id) VALUES ('Premier League', 4),
                                                     ('Serie A', 6),
                                                     ('La Liga', 5);

insert into clubs (manager_id, president_id, league_id, club_name) VALUES (1, 1, 1, 'Manchester City'),
                                                                          (2, 2, 2, 'Serie A'),
                                                                          (3, 3, 3, 'La Liga'),
                                                                          (4, 4, 1, 'Liverpool');
