PGDMP      -    
            |            school    17.2    17.2 F    F           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            G           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            H           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            I           1262    24906    school    DATABASE     z   CREATE DATABASE school WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE school;
                     postgres    false            �            1255    25224 #   set_room_to_default_before_delete()    FUNCTION     +  CREATE FUNCTION public.set_room_to_default_before_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Обновляем room_number в таблице schedule на '0'
    UPDATE schedule
    SET room_number = NULL
    WHERE room_number = OLD.room_number;
    RETURN OLD;
END;
$$;
 :   DROP FUNCTION public.set_room_to_default_before_delete();
       public               postgres    false            �            1255    25137 #   update_subjects_on_teacher_change()    FUNCTION     �   CREATE FUNCTION public.update_subjects_on_teacher_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE subjects
    SET id = NEW.id
    WHERE class_name = OLD.class_name;

    RETURN NEW;
END;
$$;
 :   DROP FUNCTION public.update_subjects_on_teacher_change();
       public               postgres    false            �            1259    25028    classes    TABLE     �   CREATE TABLE public.classes (
    class_name character varying(10) DEFAULT 0 NOT NULL,
    capacity integer DEFAULT 0 NOT NULL,
    teacher_id integer DEFAULT 0,
    id integer NOT NULL
);
    DROP TABLE public.classes;
       public         heap r       postgres    false            J           0    0    TABLE classes    COMMENT       COMMENT ON TABLE public.classes IS 'Таблица классов. Включает название класса, вместимость, ссылка на закреплённого учителя за классом и порядковый номер записи.';
          public               postgres    false    219            �            1259    25096    classes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.classes_id_seq;
       public               postgres    false    219            K           0    0    classes_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;
          public               postgres    false    226            �            1259    25090    lessons    TABLE     �   CREATE TABLE public.lessons (
    lesson_number integer DEFAULT 0 NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    id integer NOT NULL
);
    DROP TABLE public.lessons;
       public         heap r       postgres    false            L           0    0    TABLE lessons    COMMENT     �   COMMENT ON TABLE public.lessons IS 'Таблица уроков. Включает номер урока, время начала и окончания занятия и порядковый номер записи.';
          public               postgres    false    225            �            1259    25102    lessons_id_seq    SEQUENCE     �   CREATE SEQUENCE public.lessons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.lessons_id_seq;
       public               postgres    false    225            M           0    0    lessons_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.lessons_id_seq OWNED BY public.lessons.id;
          public               postgres    false    227            �            1259    25050    rooms    TABLE     �   CREATE TABLE public.rooms (
    room_number character varying(10) DEFAULT 0 NOT NULL,
    subject character varying(50) DEFAULT 0,
    teacher_id integer DEFAULT 0,
    id integer NOT NULL
);
    DROP TABLE public.rooms;
       public         heap r       postgres    false            N           0    0    TABLE rooms    COMMENT     (  COMMENT ON TABLE public.rooms IS 'Таблица кабинетов. Включает номер кабинета, предмет, преподаваемый в кабинете, ссылка на учителя за этим предметом и порядковый номер записи.';
          public               postgres    false    222            �            1259    25108    rooms_id_seq    SEQUENCE     �   CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.rooms_id_seq;
       public               postgres    false    222            O           0    0    rooms_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;
          public               postgres    false    228            �            1259    25075    schedule    TABLE       CREATE TABLE public.schedule (
    day_of_week character varying(15) DEFAULT 0 NOT NULL,
    lesson_number integer DEFAULT 0 NOT NULL,
    subject_name character varying(50) DEFAULT 0,
    id integer NOT NULL,
    room_number character varying DEFAULT 0
);
    DROP TABLE public.schedule;
       public         heap r       postgres    false            P           0    0    TABLE schedule    COMMENT     �  COMMENT ON TABLE public.schedule IS 'Таблица расписания. Включает день недели, ссылку на класс, номер урока, ссылку на кабинет и предмет. Поля class_name и subject_name связаны с таблицей Subjects для определения, какие предметы проходят в каком классе. Поле room_number связано с таблицей Rooms, чтобы указать кабинет, в котором проводится урок. Используются внешние ключи для сохранения ссылочной целостности: если удаляется запись в таблице Subjects, соответствующие строки в расписании удаляются, а при удалении кабинета значение в поле room_number заменяется на NULL.';
          public               postgres    false    224            �            1259    25114    schedule_id_seq    SEQUENCE     �   CREATE SEQUENCE public.schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.schedule_id_seq;
       public               postgres    false    224            Q           0    0    schedule_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;
          public               postgres    false    229            �            1259    25039    students    TABLE     �   CREATE TABLE public.students (
    id integer NOT NULL,
    first_name character varying(50) DEFAULT 0 NOT NULL,
    last_name character varying(50) DEFAULT 0 NOT NULL,
    class_name character varying(10) DEFAULT 0 NOT NULL
);
    DROP TABLE public.students;
       public         heap r       postgres    false            R           0    0    TABLE students    COMMENT     �   COMMENT ON TABLE public.students IS 'Таблица студентов. В ней представлены имя, фамилия и класс, в котором обучается студент.';
          public               postgres    false    221            �            1259    25038    students_student_id_seq    SEQUENCE     �   CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.students_student_id_seq;
       public               postgres    false    221            S           0    0    students_student_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.id;
          public               postgres    false    220            �            1259    25060    subjects    TABLE     �   CREATE TABLE public.subjects (
    class_name character varying(10) DEFAULT 0 NOT NULL,
    subject_name character varying(50) DEFAULT 0 NOT NULL,
    teacher_id integer DEFAULT 0,
    id integer NOT NULL
);
    DROP TABLE public.subjects;
       public         heap r       postgres    false            T           0    0    TABLE subjects    COMMENT       COMMENT ON TABLE public.subjects IS 'Таблица предметов. В ней представлены название класса, название предмета и ссылка на учителя, который преподаёт предмет.';
          public               postgres    false    223            �            1259    25127    subjects_id_seq    SEQUENCE     �   CREATE SEQUENCE public.subjects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.subjects_id_seq;
       public               postgres    false    223            U           0    0    subjects_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.subjects_id_seq OWNED BY public.subjects.id;
          public               postgres    false    230            �            1259    25020    teachers    TABLE       CREATE TABLE public.teachers (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    subject character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(30) NOT NULL
);
    DROP TABLE public.teachers;
       public         heap r       postgres    false            V           0    0    TABLE teachers    COMMENT     �   COMMENT ON TABLE public.teachers IS 'Таблица учителей. В ней представлены имя, фамилия, предметная область, логин и пароль учителя.';
          public               postgres    false    218            �            1259    25019    teachers_teacher_id_seq    SEQUENCE     �   CREATE SEQUENCE public.teachers_teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.teachers_teacher_id_seq;
       public               postgres    false    218            W           0    0    teachers_teacher_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.teachers_teacher_id_seq OWNED BY public.teachers.id;
          public               postgres    false    217            {           2604    25097 
   classes id    DEFAULT     h   ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);
 9   ALTER TABLE public.classes ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    226    219            �           2604    25103 
   lessons id    DEFAULT     h   ALTER TABLE ONLY public.lessons ALTER COLUMN id SET DEFAULT nextval('public.lessons_id_seq'::regclass);
 9   ALTER TABLE public.lessons ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    227    225            �           2604    25109    rooms id    DEFAULT     d   ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);
 7   ALTER TABLE public.rooms ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    228    222            �           2604    25115    schedule id    DEFAULT     j   ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);
 :   ALTER TABLE public.schedule ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    229    224            |           2604    25135    students id    DEFAULT     r   ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_student_id_seq'::regclass);
 :   ALTER TABLE public.students ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    221    220    221            �           2604    25128    subjects id    DEFAULT     j   ALTER TABLE ONLY public.subjects ALTER COLUMN id SET DEFAULT nextval('public.subjects_id_seq'::regclass);
 :   ALTER TABLE public.subjects ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    230    223            w           2604    25136    teachers id    DEFAULT     r   ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_teacher_id_seq'::regclass);
 :   ALTER TABLE public.teachers ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    218    217    218            8          0    25028    classes 
   TABLE DATA                 public               postgres    false    219   �V       >          0    25090    lessons 
   TABLE DATA                 public               postgres    false    225   W       ;          0    25050    rooms 
   TABLE DATA                 public               postgres    false    222   �W       =          0    25075    schedule 
   TABLE DATA                 public               postgres    false    224   X       :          0    25039    students 
   TABLE DATA                 public               postgres    false    221   �X       <          0    25060    subjects 
   TABLE DATA                 public               postgres    false    223   �Y       7          0    25020    teachers 
   TABLE DATA                 public               postgres    false    218   #Z       X           0    0    classes_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.classes_id_seq', 5, true);
          public               postgres    false    226            Y           0    0    lessons_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.lessons_id_seq', 7, true);
          public               postgres    false    227            Z           0    0    rooms_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.rooms_id_seq', 3, true);
          public               postgres    false    228            [           0    0    schedule_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.schedule_id_seq', 8, true);
          public               postgres    false    229            \           0    0    students_student_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.students_student_id_seq', 12, true);
          public               postgres    false    220            ]           0    0    subjects_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.subjects_id_seq', 6, true);
          public               postgres    false    230            ^           0    0    teachers_teacher_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.teachers_teacher_id_seq', 7, true);
          public               postgres    false    217            �           2606    25032    classes classes_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_name);
 >   ALTER TABLE ONLY public.classes DROP CONSTRAINT classes_pkey;
       public                 postgres    false    219            �           2606    25094    lessons lessons_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (lesson_number);
 >   ALTER TABLE ONLY public.lessons DROP CONSTRAINT lessons_pkey;
       public                 postgres    false    225            �           2606    25054    rooms rooms_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_number);
 :   ALTER TABLE ONLY public.rooms DROP CONSTRAINT rooms_pkey;
       public                 postgres    false    222            �           2606    25044    students students_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.students DROP CONSTRAINT students_pkey;
       public                 postgres    false    221            �           2606    25064    subjects subjects_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (class_name, subject_name);
 @   ALTER TABLE ONLY public.subjects DROP CONSTRAINT subjects_pkey;
       public                 postgres    false    223    223            �           2606    25027    teachers teachers_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_email_key UNIQUE (email);
 E   ALTER TABLE ONLY public.teachers DROP CONSTRAINT teachers_email_key;
       public                 postgres    false    218            �           2606    25025    teachers teachers_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.teachers DROP CONSTRAINT teachers_pkey;
       public                 postgres    false    218            �           2620    25225 /   rooms trigger_set_room_to_default_before_delete    TRIGGER     �   CREATE TRIGGER trigger_set_room_to_default_before_delete BEFORE DELETE ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.set_room_to_default_before_delete();
 H   DROP TRIGGER trigger_set_room_to_default_before_delete ON public.rooms;
       public               postgres    false    222    232            �           2620    25138    classes update_teacher_id    TRIGGER     �   CREATE TRIGGER update_teacher_id AFTER UPDATE OF teacher_id ON public.classes FOR EACH ROW EXECUTE FUNCTION public.update_subjects_on_teacher_change();
 2   DROP TRIGGER update_teacher_id ON public.classes;
       public               postgres    false    219    219    231            �           2606    25033    classes classes_teacher_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.classes DROP CONSTRAINT classes_teacher_id_fkey;
       public               postgres    false    4754    218    219            �           2606    25055    rooms rooms_teacher_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public.rooms DROP CONSTRAINT rooms_teacher_id_fkey;
       public               postgres    false    218    222    4754            �           2606    25218 "   schedule schedule_room_number_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_room_number_fkey FOREIGN KEY (room_number) REFERENCES public.rooms(room_number) ON UPDATE CASCADE;
 L   ALTER TABLE ONLY public.schedule DROP CONSTRAINT schedule_room_number_fkey;
       public               postgres    false    4760    224    222            �           2606    25149 !   students students_class_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_class_name_fkey FOREIGN KEY (class_name) REFERENCES public.classes(class_name) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.students DROP CONSTRAINT students_class_name_fkey;
       public               postgres    false    221    219    4756            �           2606    25139 !   subjects subjects_class_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_class_name_fkey FOREIGN KEY (class_name) REFERENCES public.classes(class_name) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.subjects DROP CONSTRAINT subjects_class_name_fkey;
       public               postgres    false    4756    223    219            �           2606    25070 !   subjects subjects_teacher_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.subjects DROP CONSTRAINT subjects_teacher_id_fkey;
       public               postgres    false    218    4754    223            8   u   x���v
Q���W((M��L�K�I,.N-Vs�	uV�P74tR�Q0� b Ҵ��$B��3H����1�����D�.C�FS"u�5�����Q0!޶	 �0��@�\\ �K6      >   y   x���v
Q���W((M��L��I-.��+Vs�	uV�0�QP74�2 !u���6ִ��$l�	H�!�	�pL�3����#�	�ę`�e�d�1�3�L0�2�D� d�L0��� w$T      ;   i   x���v
Q���W((M��L�+���-Vs�	uV�P740R�QP���ہxׅ@�iZsy���}��拍��w\ةp������v���h ��3�      =   �   x���v
Q���W((M��L�+N�HM)�IUs�	uV�P�0�¾{/l���w_��w\إ��`���~a΅��{�4P�������_����5�'qV\��|���d�R�q{�B�@�����:�&N���bܱ&�&� L�� I�o�      :   �   x���v
Q���W((M��L�+.)MI�+)Vs�	uV�0�QP�0��֋M�A�v\�ra�ņ�.l�:�kZsya�	Ȁ	���a�.6_��m��2"j�L�yF 3�\� t̎��P����f��34�0�XMAf̻�������M�w�V�wI0�d�r`����Hn���{.6^l����"��� D��2      <   ~   x���v
Q���W((M��L�+.M�JM.)Vs�	uV�P74tR�QP���b��Ƌ�v]�qa�����/v_��2"Mk.Ob�t��h�v �ua�o��`F��&`1�/��h�.. ͨO�      7   �  x����J�@��}�� ��x7u�EA*�권�`C���I#ݵ՝b7
"
*>@����+�y#�$m��B !�����/s�%-_(�h���ݥĨPGh�G�g�����ђ�}ق/��(��'�3�Ɵ0��c�Uly��.�sI�YaT8g��k*W'B\q�L'�� e�4�E�'@� �@��ڛ��m�F}#Mva oa�R�W9��)�6ـ���������x_vv~�3q�pS�l�XK�H�k������X8��m����DvQdk�C|`&o�_�x�U�\���#.w���x�\�V(c���bf9��=��h]=����_����p��l�����	�Q���U֠�3:b�,;.ā2�P��;<�%�x1��+Z;d��͐�!/z��4Vr�En>�D���}�     