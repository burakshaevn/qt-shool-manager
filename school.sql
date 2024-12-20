--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2024-12-20 22:18:44

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
-- TOC entry 232 (class 1255 OID 25224)
-- Name: set_room_to_default_before_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_room_to_default_before_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Обновляем room_number в таблице schedule на '0'
    --UPDATE schedule
    --SET room_number = '0'
    --WHERE room_number = OLD.room_number;
	DELETE FROM public.schedule WHERE room_number = OLD.room_number;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.set_room_to_default_before_delete() OWNER TO postgres;

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
    class_name character varying(10) DEFAULT 0 NOT NULL,
    capacity integer DEFAULT 0 NOT NULL,
    teacher_id integer DEFAULT 0,
    id integer NOT NULL
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- TOC entry 4937 (class 0 OID 0)
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
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 226
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
-- TOC entry 225 (class 1259 OID 25090)
-- Name: lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lessons (
    lesson_number integer DEFAULT 0 NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.lessons OWNER TO postgres;

--
-- TOC entry 4939 (class 0 OID 0)
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
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 227
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lessons_id_seq OWNED BY public.lessons.id;


--
-- TOC entry 222 (class 1259 OID 25050)
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    room_number character varying(10) DEFAULT 0 NOT NULL,
    subject character varying(50) DEFAULT 0,
    teacher_id integer DEFAULT 0,
    id integer NOT NULL
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- TOC entry 4941 (class 0 OID 0)
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
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 228
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- TOC entry 224 (class 1259 OID 25075)
-- Name: schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schedule (
    day_of_week character varying(15) DEFAULT 0 NOT NULL,
    lesson_number integer DEFAULT 0 NOT NULL,
    subject_name character varying(50) DEFAULT 0,
    id integer NOT NULL,
    room_number character varying DEFAULT 0
);


ALTER TABLE public.schedule OWNER TO postgres;

--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE schedule; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.schedule IS 'Таблица расписания. Включает день недели, номер урока, предмет, порядковый номер записи и номер кабинета, где проводится занятие.';


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
-- TOC entry 4944 (class 0 OID 0)
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
    first_name character varying(50) DEFAULT 0 NOT NULL,
    last_name character varying(50) DEFAULT 0 NOT NULL,
    class_name character varying(10) DEFAULT 0 NOT NULL
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE students; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.students IS 'Таблица студентов. В ней представлены порядковый номер записи, имя, фамилия и класс, в котором обучается студент.';


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
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 220
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.id;


--
-- TOC entry 223 (class 1259 OID 25060)
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    class_name character varying(10) DEFAULT 0 NOT NULL,
    subject_name character varying(50) DEFAULT 0 NOT NULL,
    teacher_id integer DEFAULT 0,
    id integer NOT NULL
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE subjects; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.subjects IS 'Таблица предметов. В ней представлены название класса, название предмета, ссылка на учителя, который преподаёт предмет и порядковый номер записи.';


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
-- TOC entry 4948 (class 0 OID 0)
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
-- TOC entry 4949 (class 0 OID 0)
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
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 217
-- Name: teachers_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_teacher_id_seq OWNED BY public.teachers.id;


--
-- TOC entry 4731 (class 2604 OID 25097)
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- TOC entry 4750 (class 2604 OID 25103)
-- Name: lessons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons ALTER COLUMN id SET DEFAULT nextval('public.lessons_id_seq'::regclass);


--
-- TOC entry 4739 (class 2604 OID 25109)
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- TOC entry 4747 (class 2604 OID 25115)
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- TOC entry 4732 (class 2604 OID 25135)
-- Name: students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 25128)
-- Name: subjects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects ALTER COLUMN id SET DEFAULT nextval('public.subjects_id_seq'::regclass);


--
-- TOC entry 4727 (class 2604 OID 25136)
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_teacher_id_seq'::regclass);


--
-- TOC entry 4920 (class 0 OID 25028)
-- Dependencies: 219
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.classes VALUES ('10Б', 10, 5, 5);
INSERT INTO public.classes VALUES ('11А', 25, 10, 6);
INSERT INTO public.classes VALUES ('9Г', 15, 3, 3);


--
-- TOC entry 4926 (class 0 OID 25090)
-- Dependencies: 225
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lessons VALUES (3, '10:00:00', '10:45:00', 3);
INSERT INTO public.lessons VALUES (4, '11:00:00', '11:45:00', 4);
INSERT INTO public.lessons VALUES (5, '12:00:00', '12:45:00', 5);
INSERT INTO public.lessons VALUES (2, '09:00:00', '09:45:00', 2);
INSERT INTO public.lessons VALUES (6, '13:00:00', '13:45:00', 6);
INSERT INTO public.lessons VALUES (1, '08:00:00', '08:45:00', 7);


--
-- TOC entry 4923 (class 0 OID 25050)
-- Dependencies: 222
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rooms VALUES ('103', 'Русский язык', 3, 3);
INSERT INTO public.rooms VALUES ('102', 'Физика', 2, 2);


--
-- TOC entry 4925 (class 0 OID 25075)
-- Dependencies: 224
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schedule VALUES ('Вторник', 4, 'Химия', 4, '103');
INSERT INTO public.schedule VALUES ('Пятница', 5, 'Химия', 8, '103');


--
-- TOC entry 4922 (class 0 OID 25039)
-- Dependencies: 221
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.students VALUES (5, 'Иван', 'Боздунов', '11А');
INSERT INTO public.students VALUES (6, 'Ильдар', 'Попов', '11А');
INSERT INTO public.students VALUES (9, 'Раиль', 'Гараев', '11А');
INSERT INTO public.students VALUES (10, 'Артём', 'Скутырлов', '11А');
INSERT INTO public.students VALUES (11, 'Виталий', 'Норох', '11А');
INSERT INTO public.students VALUES (12, 'Дмитрий', 'Мещанов', '11А');
INSERT INTO public.students VALUES (13, 'Айлита', 'Шарипова', '11А');
INSERT INTO public.students VALUES (14, 'Дарья', 'Ушакова', '11А');
INSERT INTO public.students VALUES (15, 'Инна', 'Громова', '11А');
INSERT INTO public.students VALUES (16, 'Дарина', 'Фёдорова', '11А');
INSERT INTO public.students VALUES (17, 'Римма', 'Клементьева', '11А');
INSERT INTO public.students VALUES (18, 'Дарья', 'Фаустова', '11А');
INSERT INTO public.students VALUES (19, 'Алина', 'Ямалтдинова', '11А');
INSERT INTO public.students VALUES (8, 'Константин', 'Андреев', '9Г');
INSERT INTO public.students VALUES (7, 'Артур', 'Газизов', '9Г');
INSERT INTO public.students VALUES (20, 'Даниил', 'Летяев', '9Г');
INSERT INTO public.students VALUES (21, 'Артём', 'Закон', '9Г');
INSERT INTO public.students VALUES (22, 'Тимур', 'Гусев', '9Г');
INSERT INTO public.students VALUES (23, 'Александр', 'Кудряшов', '9Г');
INSERT INTO public.students VALUES (24, 'Чингис', 'Шамсутдинов', '9Г');
INSERT INTO public.students VALUES (4, 'Алина', 'Миннибаева', '9Г');
INSERT INTO public.students VALUES (25, 'Анна', 'Ибряева', '11А');
INSERT INTO public.students VALUES (26, 'Диана', 'Хусаинова', '11А');
INSERT INTO public.students VALUES (27, 'Диана', 'Шароян', '11А');
INSERT INTO public.students VALUES (28, 'Дарина', 'Зотова', '11А');


--
-- TOC entry 4924 (class 0 OID 25060)
-- Dependencies: 223
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.subjects VALUES ('9Г', 'Русский язык', 7, 7);
INSERT INTO public.subjects VALUES ('9Г', 'Физика', 2, 6);


--
-- TOC entry 4919 (class 0 OID 25020)
-- Dependencies: 218
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teachers VALUES (2, 'Сергей', 'Иванов', 'Физика', 'ivanov.sergey@school.com', 'password2');
INSERT INTO public.teachers VALUES (3, 'Елена', 'Соколова', 'Русский язык', 'sokolova.elena@school.com', 'password3');
INSERT INTO public.teachers VALUES (5, 'Никита', 'Компилятор', 'Математика и информатика', 'nikita.compilator@icloud.com', 'hello_world_123');
INSERT INTO public.teachers VALUES (6, 'Светлана', 'Клюева', 'Директор', 'svetlana.klueva@mail.com', 'admin');
INSERT INTO public.teachers VALUES (7, 'Иван', 'Иванов', 'Математика', '453re3wko@mail.xaz', 'test12');
INSERT INTO public.teachers VALUES (8, 'Артур', 'Галиуллиин', 'Физкультура', 'artur.galiullin@boxing.com', 'op45gk342');
INSERT INTO public.teachers VALUES (9, 'Егор', 'Жупиков', 'Физкультура', 'egor.zhupikov@boxing.com', '%$R^tguyh4393');
INSERT INTO public.teachers VALUES (10, 'Татьяна', 'Краснова', 'Физика', 'tatyana.krasnova@mail.ru', '643yi@(*jr');


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 226
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classes_id_seq', 5, true);


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 227
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lessons_id_seq', 7, true);


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 228
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_id_seq', 3, true);


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 229
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.schedule_id_seq', 8, true);


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 220
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 12, true);


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 230
-- Name: subjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subjects_id_seq', 6, true);


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 217
-- Name: teachers_teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teachers_teacher_id_seq', 7, true);


--
-- TOC entry 4756 (class 2606 OID 25032)
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_name);


--
-- TOC entry 4764 (class 2606 OID 25094)
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (lesson_number);


--
-- TOC entry 4760 (class 2606 OID 25054)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_number);


--
-- TOC entry 4758 (class 2606 OID 25044)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- TOC entry 4762 (class 2606 OID 25064)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (class_name, subject_name);


--
-- TOC entry 4752 (class 2606 OID 25027)
-- Name: teachers teachers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_email_key UNIQUE (email);


--
-- TOC entry 4754 (class 2606 OID 25025)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- TOC entry 4772 (class 2620 OID 25225)
-- Name: rooms trigger_set_room_to_default_before_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_set_room_to_default_before_delete BEFORE DELETE ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.set_room_to_default_before_delete();


--
-- TOC entry 4771 (class 2620 OID 25138)
-- Name: classes update_teacher_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_teacher_id AFTER UPDATE OF teacher_id ON public.classes FOR EACH ROW EXECUTE FUNCTION public.update_subjects_on_teacher_change();


--
-- TOC entry 4765 (class 2606 OID 25434)
-- Name: classes classes_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE CASCADE;


--
-- TOC entry 4767 (class 2606 OID 25439)
-- Name: rooms rooms_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE CASCADE;


--
-- TOC entry 4770 (class 2606 OID 25218)
-- Name: schedule schedule_room_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_room_number_fkey FOREIGN KEY (room_number) REFERENCES public.rooms(room_number) ON UPDATE CASCADE;


--
-- TOC entry 4766 (class 2606 OID 25149)
-- Name: students students_class_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_class_name_fkey FOREIGN KEY (class_name) REFERENCES public.classes(class_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4768 (class 2606 OID 25139)
-- Name: subjects subjects_class_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_class_name_fkey FOREIGN KEY (class_name) REFERENCES public.classes(class_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4769 (class 2606 OID 25444)
-- Name: subjects subjects_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE CASCADE;


-- Completed on 2024-12-20 22:18:44

--
-- PostgreSQL database dump complete
--

