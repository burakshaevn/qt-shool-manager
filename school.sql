--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2024-12-16 21:13:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4920 (class 1262 OID 24906)
-- Name: school; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE school WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE school OWNER TO postgres;

\connect school

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 232 (class 1255 OID 25167)
-- Name: update_schedule_class_name(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_schedule_class_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Обновляем поле class_name в таблице schedule
    UPDATE schedule
    SET room_number = NEW.room_number
    WHERE room_number = OLD.room_number;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_schedule_class_name() OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 25137)
-- Name: update_subjects_on_teacher_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_subjects_on_teacher_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE subjects
    SET id = NEW.id
    WHERE class_name = OLD.class_name;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_subjects_on_teacher_change() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 25028)
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    class_name character varying(10) NOT NULL,
    capacity integer NOT NULL,
    teacher_id integer,
    id integer NOT NULL
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE classes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.classes IS 'Таблица классов. Включает название класса, вместимость, ссылка на закреплённого учителя за классом и порядковый номер записи.';


--
-- TOC entry 226 (class 1259 OID 25096)
-- Name: classes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.classes_id_seq OWNER TO postgres;

--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 226
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
-- TOC entry 225 (class 1259 OID 25090)
-- Name: lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lessons (
    lesson_number integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.lessons OWNER TO postgres;

--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE lessons; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.lessons IS 'Таблица уроков. Включает номер урока, время начала и окончания занятия и порядковый номер записи.';


--
-- TOC entry 227 (class 1259 OID 25102)
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lessons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lessons_id_seq OWNER TO postgres;

--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 227
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lessons_id_seq OWNED BY public.lessons.id;


--
-- TOC entry 222 (class 1259 OID 25050)
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    room_number character varying(10) NOT NULL,
    subject character varying(50),
    teacher_id integer,
    id integer NOT NULL
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE rooms; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.rooms IS 'Таблица кабинетов. Включает номер кабинета, предмет, преподаваемый в кабинете, ссылка на учителя за этим предметом и порядковый номер записи.';


--
-- TOC entry 228 (class 1259 OID 25108)
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rooms_id_seq OWNER TO postgres;

--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 228
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- TOC entry 224 (class 1259 OID 25075)
-- Name: schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schedule (
    day_of_week character varying(15) NOT NULL,
    lesson_number integer NOT NULL,
    subject_name character varying(50),
    id integer NOT NULL,
    room_number character varying
);


ALTER TABLE public.schedule OWNER TO postgres;

--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE schedule; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.schedule IS 'Таблица расписания. Включает день недели, ссылку на класс, номер урока, ссылку на кабинет и предмет. Поля class_name и subject_name связаны с таблицей Subjects для определения, какие предметы проходят в каком классе. Поле room_number связано с таблицей Rooms, чтобы указать кабинет, в котором проводится урок. Используются внешние ключи для сохранения ссылочной целостности: если удаляется запись в таблице Subjects, соответствующие строки в расписании удаляются, а при удалении кабинета значение в поле room_number заменяется на NULL.';


--
-- TOC entry 229 (class 1259 OID 25114)
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schedule_id_seq OWNER TO postgres;

--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 229
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;


--
-- TOC entry 221 (class 1259 OID 25039)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    class_name character varying(10) NOT NULL
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE students; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.students IS 'Таблица студентов. В ней представлены имя, фамилия и класс, в котором обучается студент.';


--
-- TOC entry 220 (class 1259 OID 25038)
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 220
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.id;


--
-- TOC entry 223 (class 1259 OID 25060)
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    class_name character varying(10) NOT NULL,
    subject_name character varying(50) NOT NULL,
    teacher_id integer,
    id integer NOT NULL
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE subjects; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.subjects IS 'Таблица предметов. В ней представлены название класса, название предмета и ссылка на учителя, который преподаёт предмет.';


--
-- TOC entry 230 (class 1259 OID 25127)
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subjects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subjects_id_seq OWNER TO postgres;

--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 230
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subjects_id_seq OWNED BY public.subjects.id;


--
-- TOC entry 218 (class 1259 OID 25020)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    subject character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(30) NOT NULL
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE teachers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.teachers IS 'Таблица учителей. В ней представлены имя, фамилия, предметная область, логин и пароль учителя.';


--
-- TOC entry 217 (class 1259 OID 25019)
-- Name: teachers_teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teachers_teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teachers_teacher_id_seq OWNER TO postgres;

--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 217
-- Name: teachers_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_teacher_id_seq OWNED BY public.teachers.id;


--
-- TOC entry 4728 (class 2604 OID 25097)
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- TOC entry 4733 (class 2604 OID 25103)
-- Name: lessons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons ALTER COLUMN id SET DEFAULT nextval('public.lessons_id_seq'::regclass);


--
-- TOC entry 4730 (class 2604 OID 25109)
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- TOC entry 4732 (class 2604 OID 25115)
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- TOC entry 4729 (class 2604 OID 25135)
-- Name: students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- TOC entry 4731 (class 2604 OID 25128)
-- Name: subjects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects ALTER COLUMN id SET DEFAULT nextval('public.subjects_id_seq'::regclass);


--
-- TOC entry 4727 (class 2604 OID 25136)
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_teacher_id_seq'::regclass);


--
-- TOC entry 4903 (class 0 OID 25028)
-- Dependencies: 219
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.classes VALUES ('11B', 28, 2, 2);
INSERT INTO public.classes VALUES ('9C', 25, 3, 3);
INSERT INTO public.classes VALUES ('10Б', 10, 5, 5);
INSERT INTO public.classes VALUES ('E32', 33, NULL, 4);
INSERT INTO public.classes VALUES ('10А', 30, NULL, 1);


--
-- TOC entry 4909 (class 0 OID 25090)
-- Dependencies: 225
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lessons VALUES (3, '10:00:00', '10:45:00', 3);
INSERT INTO public.lessons VALUES (4, '11:00:00', '11:45:00', 4);
INSERT INTO public.lessons VALUES (5, '12:00:00', '12:45:00', 5);
INSERT INTO public.lessons VALUES (6, '13:00:00', '13:45:00', 6);
INSERT INTO public.lessons VALUES (2, '09:00:00', '09:45:00', 2);


--
-- TOC entry 4906 (class 0 OID 25050)
-- Dependencies: 222
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rooms VALUES ('102', 'Физика', 2, 2);
INSERT INTO public.rooms VALUES ('103', 'Русский язык', 3, 3);
INSERT INTO public.rooms VALUES ('101', 'Математика', 7, 1);


--
-- TOC entry 4908 (class 0 OID 25075)
-- Dependencies: 224
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schedule VALUES ('Четверг', 3, 'Математика', 7, '101');
INSERT INTO public.schedule VALUES ('Пятница', 5, 'Химия', 8, '103');
INSERT INTO public.schedule VALUES ('Вторник', 4, 'Химия', 4, '103');


--
-- TOC entry 4905 (class 0 OID 25039)
-- Dependencies: 221
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.students VALUES (3, 'Петр', 'Сидоров', '11B');
INSERT INTO public.students VALUES (4, 'Анна', 'Кузнецова', '9C');
INSERT INTO public.students VALUES (2, 'Мария', 'Смирнова', '10А');
INSERT INTO public.students VALUES (5, 'Олег', 'Елекеев', '10А');
INSERT INTO public.students VALUES (6, 'Чингиз', 'Шамсутдинов', '10А');


--
-- TOC entry 4907 (class 0 OID 25060)
-- Dependencies: 223
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.subjects VALUES ('11B', 'Русский язык', 3, 3);
INSERT INTO public.subjects VALUES ('9C', 'Физика', 2, 6);
INSERT INTO public.subjects VALUES ('10А', 'Физика', NULL, 2);


--
-- TOC entry 4902 (class 0 OID 25020)
-- Dependencies: 218
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teachers VALUES (2, 'Сергей', 'Иванов', 'Физика', 'ivanov.sergey@school.com', 'password2');
INSERT INTO public.teachers VALUES (3, 'Елена', 'Соколова', 'Русский язык', 'sokolova.elena@school.com', 'password3');
INSERT INTO public.teachers VALUES (7, 'Иван', 'Иванов', 'Математика', 'test12@mail.com', 'test12');
INSERT INTO public.teachers VALUES (5, 'Никита', 'Компилятор', 'Математика и информатика', 'nikita.compilator@icloud.com', 'hello_world_123');
INSERT INTO public.teachers VALUES (6, 'Светлана', 'Клюева', 'Директор', 'svetlana.klueva@mail.com', 'admin');
INSERT INTO public.teachers VALUES (8, 'Татьяна', 'Краснова', 'Физика', 'tatyana.krasnova@mail.ru', 'tatyana_krasnova123');


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 226
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classes_id_seq', 5, true);


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 227
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lessons_id_seq', 7, true);


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 228
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_id_seq', 3, true);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 229
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.schedule_id_seq', 8, true);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 220
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 12, true);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 230
-- Name: subjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subjects_id_seq', 6, true);


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 217
-- Name: teachers_teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teachers_teacher_id_seq', 7, true);


--
-- TOC entry 4739 (class 2606 OID 25032)
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_name);


--
-- TOC entry 4747 (class 2606 OID 25094)
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (lesson_number);


--
-- TOC entry 4743 (class 2606 OID 25054)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_number);


--
-- TOC entry 4741 (class 2606 OID 25044)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- TOC entry 4745 (class 2606 OID 25064)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (class_name, subject_name);


--
-- TOC entry 4735 (class 2606 OID 25027)
-- Name: teachers teachers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_email_key UNIQUE (email);


--
-- TOC entry 4737 (class 2606 OID 25025)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- TOC entry 4755 (class 2620 OID 25168)
-- Name: rooms update_class_name_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_class_name_trigger AFTER UPDATE OF room_number ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.update_schedule_class_name();


--
-- TOC entry 4754 (class 2620 OID 25138)
-- Name: classes update_teacher_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_teacher_id AFTER UPDATE OF teacher_id ON public.classes FOR EACH ROW EXECUTE FUNCTION public.update_subjects_on_teacher_change();


--
-- TOC entry 4748 (class 2606 OID 25033)
-- Name: classes classes_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE SET NULL;


--
-- TOC entry 4750 (class 2606 OID 25055)
-- Name: rooms rooms_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE SET NULL;


--
-- TOC entry 4753 (class 2606 OID 25181)
-- Name: schedule schedule_room_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_room_number_fkey FOREIGN KEY (room_number) REFERENCES public.rooms(room_number) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4749 (class 2606 OID 25149)
-- Name: students students_class_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_class_name_fkey FOREIGN KEY (class_name) REFERENCES public.classes(class_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4751 (class 2606 OID 25139)
-- Name: subjects subjects_class_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_class_name_fkey FOREIGN KEY (class_name) REFERENCES public.classes(class_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4752 (class 2606 OID 25070)
-- Name: subjects subjects_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE CASCADE;


-- Completed on 2024-12-16 21:13:29

--
-- PostgreSQL database dump complete
--

