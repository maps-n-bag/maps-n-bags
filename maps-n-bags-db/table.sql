-- user
create table public.user(
  id serial primary key,
  username varchar not null,
  first_name varchar,
  last_name varchar,
  email varchar,
  password varchar,
  profile_pic varchar,
  cover_pic varchar
);
-- place_type
create table public.place_type (
  id serial primary key,
  name text
);
-- plan
create table public.plan (
  id serial primary key,
  user_id int not null,
  name varchar,
  start_date date,
  end_date date,
  description varchar,
  "public" boolean,
  constraint plan_user_fk foreign key(user_id) references public."user"(id) on delete cascade
);
--tag
create table public.tag (
  id serial primary key,
  name varchar(50) not null
); 
-- region
CREATE TABLE public.region
(
    id serial NOT NULL,
    representative_place_id bigint,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT region_pkey PRIMARY KEY (id)
);
-- place
CREATE TABLE public.place
(
    id serial NOT NULL PRIMARY KEY,
    region_id bigint NOT NULL,
    "name" character varying(100) NOT NULL,
    type integer NOT NULL,
    latitude numeric (4,8),
    longitude numeric (4,8),
    rating numeric (2,1),
    description character varying(1000),
    CONSTRAINT place_region_id_fkey FOREIGN KEY (region_id)
        REFERENCES public.region (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT place_type_fk FOREIGN KEY (type)
        REFERENCES public.place_type (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);
-- representative of the update_region_cons.sql script
ALTER TABLE public.region
    ADD CONSTRAINT region_representative_place_id_fkey FOREIGN KEY (representative_place_id)
        REFERENCES public.place (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;
-- add column to place table
ALTER TABLE public.place
    ADD COLUMN rating_count integer,
    ADD COLUMN address character varying(200),
    ADD COLUMN contact character varying(20),
    ADD COLUMN website character varying(100);
-- review
CREATE TABLE public.review
(
    id serial NOT NULL PRIMARY KEY,
    place_id integer NOT NULL,
    username character varying(50),
    coment character varying(1000),
    CONSTRAINT review_place_id_fkey FOREIGN KEY (place_id)
        REFERENCES public.place (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);

-- review_image
CREATE TABLE public.review_image
(
    review_id integer NOT NULL,
    image character varying(200),
    CONSTRAINT review_image_review_id_fkey FOREIGN KEY (review_id)
        REFERENCES public.review (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);
-- place_image
CREATE TABLE public.place_image
(
    place_id integer NOT NULL,
    image character varying(200),
    CONSTRAINT place_image_place_id_fkey FOREIGN KEY (place_id)
        REFERENCES public.place (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);
-- nearby_region
CREATE TABLE public.nearby_region
(
    region_id integer NOT NULL,
    nearby_region_id integer NOT NULL,
    CONSTRAINT nearby_region_region_id_fkey FOREIGN KEY (region_id)
        REFERENCES public.region (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT nearby_region_nearby_region_id_fkey FOREIGN KEY (nearby_region_id)
        REFERENCES public.region (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);
-- distance
CREATE TABLE public.distance
(
    first_place_id integer NOT NULL,
    second_place_id integer NOT NULL,
    journey_type character varying(20),
    distance numeric (4,2),
    estimated_time time without time zone,
    CONSTRAINT distance_first_place_id_fkey FOREIGN KEY (first_place_id)
        REFERENCES public.place (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT distance_second_place_id_fkey FOREIGN KEY (second_place_id)
        REFERENCES public.place (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);
-- activity
CREATE TABLE public.activity
(
    id serial NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL,
    max_time time without time zone NOT NULL,
    min_time time without time zone NOT NULL,
    CONSTRAINT activity_name_key UNIQUE (name));
-- spot_tag
CREATE TABLE public.spot_tag
(
    place_id integer NOT NULL,
    tag_id integer NOT NULL,
    CONSTRAINT spot_tag_place_id_fkey FOREIGN KEY (place_id)
        REFERENCES public.place (id) MATCH SIMPLE,
    CONSTRAINT spot_tag_tag_id_fkey FOREIGN KEY (tag_id)
        REFERENCES public.tag (id) MATCH SIMPLE
);
CREATE OR REPLACE FUNCTION check_place_type()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.place WHERE id = NEW.place_id AND type = 1) THEN
        RAISE EXCEPTION 'The referenced place must have type = 1';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_place_type
    BEFORE INSERT ON public.spot_tag
    FOR EACH ROW
    EXECUTE FUNCTION check_place_type();
-- restaurant_tag
CREATE TABLE public.restaurant_tag
(
    place_id integer NOT NULL,
    tag_id integer NOT NULL,
    CONSTRAINT restaurant_tag_place_id_fkey FOREIGN KEY (place_id)
        REFERENCES public.place (id) MATCH SIMPLE,
    CONSTRAINT restaurant_tag_tag_id_fkey FOREIGN KEY (tag_id)
        REFERENCES public.tag (id) MATCH SIMPLE
);
CREATE FUNCTION check_place_type_resturent()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.place WHERE id = NEW.place_id AND type = 2) THEN
        RAISE EXCEPTION 'The referenced place must have type = 2';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_place_type_resturent
    BEFORE INSERT ON public.restaurant_tag
    FOR EACH ROW
    EXECUTE FUNCTION check_place_type_resturent();

-- spot_activity
CREATE TABLE public.spot_activity
(
    place_id integer NOT NULL,
    activity_id integer NOT NULL,
    tag_id integer NOT NULL,
    est_cost numeric (6,2),
    CONSTRAINT spot_activity_place_id_fkey FOREIGN KEY (place_id)
        REFERENCES public.place (id) MATCH SIMPLE,
    CONSTRAINT spot_activity_activity_id_fkey FOREIGN KEY (activity_id)
        REFERENCES public.activity (id) MATCH SIMPLE,
    CONSTRAINT spot_activity_tag_id_fkey FOREIGN KEY (tag_id)
        REFERENCES public.tag (id) MATCH SIMPLE
);


-- event
CREATE TABLE public.event
(
    id serial NOT NULL PRIMARY KEY,
    plan_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    "order" integer NOT NULL,
    place_id integer NOT NULL,
    activity_id integer NOT NULL,
    description character varying(1000),
    CONSTRAINT event_place_id_fkey FOREIGN KEY (place_id)
        REFERENCES public.place (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT event_activity_id_fkey FOREIGN KEY (activity_id)
        REFERENCES public.activity (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT event_plan_id_fkey FOREIGN KEY (plan_id)
        REFERENCES public.plan (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);
-- event_detail
CREATE TABLE public.event_detail
(
    event_id integer NOT NULL,
    checked boolean NOT NULL DEFAULT false,
    note character varying(1000),
    generated_detail varchar(2000),
    expenditure numeric (6,2),
    CONSTRAINT event_detail_event_id_fkey FOREIGN KEY (event_id)
        REFERENCES public.event (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);
-- event_image
CREATE TABLE public.event_image
(
    event_id integer NOT NULL,
    image character varying(200),
    CONSTRAINT event_image_event_id_fkey FOREIGN KEY (event_id)
        REFERENCES public.event (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION);
