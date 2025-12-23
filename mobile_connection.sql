--
-- PostgreSQL database dump
--

\restrict 8YS1Daywiam7I2Wc7qVUsDOFmeI3SJg2wUP9GXVtXLFgzlnd85PpiJi2CCMYnrN

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

-- Started on 2025-12-23 15:08:59

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 225 (class 1255 OID 16483)
-- Name: add_abonent_with_sim(character varying, character varying, date, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_abonent_with_sim(p_fio character varying, p_passport character varying, p_birth date, p_address character varying, p_phone character varying, p_tariff integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_abonent_id INT;
BEGIN
    INSERT INTO Abonent(fio, passport, birth_date, address)
    VALUES (p_fio, p_passport, p_birth, p_address)
    RETURNING abonent_id INTO new_abonent_id;
    
    INSERT INTO SimCard(phone_number, activation_date, abonent_id, tariff_id)
    VALUES (p_phone, CURRENT_DATE, new_abonent_id, p_tariff);
END;
$$;


ALTER FUNCTION public.add_abonent_with_sim(p_fio character varying, p_passport character varying, p_birth date, p_address character varying, p_phone character varying, p_tariff integer) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 16484)
-- Name: auto_add_voice_mail(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auto_add_voice_mail() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO ServiceConnection(sim_id, service_id, connect_date)
    VALUES (NEW.sim_id, 1, CURRENT_DATE); -- подключаем услугу "Голосовая почта"
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.auto_add_voice_mail() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16399)
-- Name: abonent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.abonent (
    abonent_id integer NOT NULL,
    fio character varying(100) NOT NULL,
    passport character varying(20),
    birth_date date,
    address character varying(200)
);


ALTER TABLE public.abonent OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16398)
-- Name: abonent_abonent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.abonent_abonent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.abonent_abonent_id_seq OWNER TO postgres;

--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 215
-- Name: abonent_abonent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.abonent_abonent_id_seq OWNED BY public.abonent.abonent_id;


--
-- TOC entry 222 (class 1259 OID 16434)
-- Name: service; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service (
    service_id integer NOT NULL,
    name character varying(50) NOT NULL,
    price numeric(8,2),
    description character varying(200)
);


ALTER TABLE public.service OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16433)
-- Name: service_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_service_id_seq OWNER TO postgres;

--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 221
-- Name: service_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_service_id_seq OWNED BY public.service.service_id;


--
-- TOC entry 224 (class 1259 OID 16441)
-- Name: serviceconnection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serviceconnection (
    connection_id integer NOT NULL,
    sim_id integer,
    service_id integer,
    connect_date date
);


ALTER TABLE public.serviceconnection OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16440)
-- Name: serviceconnection_connection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serviceconnection_connection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serviceconnection_connection_id_seq OWNER TO postgres;

--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 223
-- Name: serviceconnection_connection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serviceconnection_connection_id_seq OWNED BY public.serviceconnection.connection_id;


--
-- TOC entry 220 (class 1259 OID 16415)
-- Name: simcard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.simcard (
    sim_id integer NOT NULL,
    phone_number character varying(15) NOT NULL,
    activation_date date,
    abonent_id integer,
    tariff_id integer
);


ALTER TABLE public.simcard OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16414)
-- Name: simcard_sim_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.simcard_sim_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.simcard_sim_id_seq OWNER TO postgres;

--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 219
-- Name: simcard_sim_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.simcard_sim_id_seq OWNED BY public.simcard.sim_id;


--
-- TOC entry 218 (class 1259 OID 16408)
-- Name: tariff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tariff (
    tariff_id integer NOT NULL,
    name character varying(50) NOT NULL,
    monthly_fee numeric(8,2),
    minutes integer,
    internet_gb integer,
    sms_count integer
);


ALTER TABLE public.tariff OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16407)
-- Name: tariff_tariff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tariff_tariff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tariff_tariff_id_seq OWNER TO postgres;

--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 217
-- Name: tariff_tariff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tariff_tariff_id_seq OWNED BY public.tariff.tariff_id;


--
-- TOC entry 4757 (class 2604 OID 16402)
-- Name: abonent abonent_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abonent ALTER COLUMN abonent_id SET DEFAULT nextval('public.abonent_abonent_id_seq'::regclass);


--
-- TOC entry 4760 (class 2604 OID 16437)
-- Name: service service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service ALTER COLUMN service_id SET DEFAULT nextval('public.service_service_id_seq'::regclass);


--
-- TOC entry 4761 (class 2604 OID 16444)
-- Name: serviceconnection connection_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceconnection ALTER COLUMN connection_id SET DEFAULT nextval('public.serviceconnection_connection_id_seq'::regclass);


--
-- TOC entry 4759 (class 2604 OID 16418)
-- Name: simcard sim_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simcard ALTER COLUMN sim_id SET DEFAULT nextval('public.simcard_sim_id_seq'::regclass);


--
-- TOC entry 4758 (class 2604 OID 16411)
-- Name: tariff tariff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tariff ALTER COLUMN tariff_id SET DEFAULT nextval('public.tariff_tariff_id_seq'::regclass);


--
-- TOC entry 4925 (class 0 OID 16399)
-- Dependencies: 216
-- Data for Name: abonent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.abonent (abonent_id, fio, passport, birth_date, address) FROM stdin;
1	Иванов Иван Иванович	1111 111111	1990-01-01	Москва
2	Петров Петр Петрович	1111 111112	1991-02-02	СПб
4	Кузнецов Алексей Игоревич	1111 111114	1989-04-04	Самара
5	Смирнова Анна Олеговна	1111 111115	1993-05-05	Тула
6	Попов Михаил Андреевич	1111 111116	1988-06-06	Тверь
7	Васильев Денис Романович	1111 111117	1994-07-07	Пермь
8	Новикова Мария Сергеевна	1111 111118	1995-08-08	Ижевск
9	Федоров Артем Николаевич	1111 111119	1996-09-09	Воронеж
10	Морозова Елена Викторовна	1111 111120	1987-10-10	Омск
11	Алексеев Павел Юрьевич	1111 111121	1990-11-11	Курск
12	Орлова Дарья Дмитриевна	1111 111122	1997-12-12	Белгород
13	Никитин Илья Максимович	1111 111123	1991-01-13	Брянск
14	Зайцева Ольга Петровна	1111 111124	1992-02-14	Рязань
15	Егоров Андрей Владимирович	1111 111125	1986-03-15	Липецк
16	Павлова Ксения Игоревна	1111 111126	1998-04-16	Калуга
17	Макаров Тимофей Аркадьевич	1111 111127	1985-05-17	Томск
18	Белова Наталья Андреевна	1111 111128	1993-06-18	Иркутск
19	Григорьев Вадим Олегович	1111 111129	1994-07-19	Челябинск
20	Романова Юлия Николаевна	1111 111130	1996-08-20	Уфа
21	Иванова Екатерина Сергеевна	1111 111131	1999-09-09	Новосибирск
3	Сидоров Сергей Сергеевич	1111 111113	1992-03-03	Санкт-Петербург
23	Петрова Алина Игоревна	1111 111132	2000-02-02	Казань
\.


--
-- TOC entry 4931 (class 0 OID 16434)
-- Dependencies: 222
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service (service_id, name, price, description) FROM stdin;
1	Голосовая почта	50.00	Автоответчик
2	Антиспам	30.00	Блокировка спама
3	Роуминг	300.00	Международный роуминг
4	Интернет+	100.00	Доп. трафик
5	Безлимит соцсети	150.00	Соцсети
6	Музыка	120.00	Музыкальный сервис
7	Видео	200.00	Видео-сервисы
8	Детский контроль	80.00	Родительский контроль
9	Антивирус	90.00	Защита
10	Облако	70.00	Хранение данных
11	Межд. звонки	250.00	За границу
12	SMS-пакет	60.00	SMS
13	Ночной интернет	110.00	Ночь
14	Игры	130.00	Игры
15	Навигация	40.00	GPS
16	Бизнес-пакет	500.00	Бизнес
17	VPN	180.00	Защита
18	Фильтрация	75.00	Контент
19	PRO	300.00	Подписка
20	Экстренные SMS	20.00	Оповещения
\.


--
-- TOC entry 4933 (class 0 OID 16441)
-- Dependencies: 224
-- Data for Name: serviceconnection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serviceconnection (connection_id, sim_id, service_id, connect_date) FROM stdin;
1	1	1	2024-02-01
3	3	3	2024-02-03
4	4	4	2024-02-04
5	5	5	2024-02-05
6	6	6	2024-02-06
7	7	7	2024-02-07
8	8	8	2024-02-08
9	9	9	2024-02-09
10	10	10	2024-02-10
11	11	11	2024-02-11
12	12	12	2024-02-12
13	13	13	2024-02-13
14	14	14	2024-02-14
15	15	15	2024-02-15
16	16	16	2024-02-16
17	17	17	2024-02-17
18	18	18	2024-02-18
19	19	19	2024-02-19
20	20	20	2024-02-20
21	21	1	2024-12-02
22	23	1	2025-12-21
\.


--
-- TOC entry 4929 (class 0 OID 16415)
-- Dependencies: 220
-- Data for Name: simcard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.simcard (sim_id, phone_number, activation_date, abonent_id, tariff_id) FROM stdin;
1	+79990000001	2024-01-01	1	1
2	+79990000002	2024-01-02	2	2
3	+79990000003	2024-01-03	3	3
4	+79990000004	2024-01-04	4	4
5	+79990000005	2024-01-05	5	5
6	+79990000006	2024-01-06	6	6
7	+79990000007	2024-01-07	7	7
8	+79990000008	2024-01-08	8	8
9	+79990000009	2024-01-09	9	9
10	+79990000010	2024-01-10	10	10
11	+79990000011	2024-01-11	11	11
12	+79990000012	2024-01-12	12	12
13	+79990000013	2024-01-13	13	13
14	+79990000014	2024-01-14	14	14
15	+79990000015	2024-01-15	15	15
16	+79990000016	2024-01-16	16	16
17	+79990000017	2024-01-17	17	17
18	+79990000018	2024-01-18	18	18
19	+79990000019	2024-01-19	19	19
20	+79990000020	2024-01-20	20	20
21	+79990000021	2024-12-01	21	1
22	+79990000022	2025-12-21	23	2
23	+79990000023	2025-12-21	1	3
\.


--
-- TOC entry 4927 (class 0 OID 16408)
-- Dependencies: 218
-- Data for Name: tariff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tariff (tariff_id, name, monthly_fee, minutes, internet_gb, sms_count) FROM stdin;
1	Старт	300.00	200	5	100
2	Оптимум	500.00	500	15	300
3	Комфорт	700.00	800	30	500
4	Безлимит S	900.00	1500	50	1000
5	Безлимит M	1200.00	3000	100	2000
6	Безлимит L	1500.00	5000	200	5000
7	Студент	400.00	600	20	300
8	Пенсионный	250.00	300	5	100
9	Семейный	800.00	1200	40	800
10	Бизнес	2000.00	10000	500	10000
11	Регион	350.00	300	10	200
12	Город	450.00	500	15	300
13	Интернет+	600.00	0	60	0
14	Интернет MAX	1000.00	0	150	0
15	Звонки+	400.00	1000	5	100
16	SMS+	350.00	300	5	1000
17	Детский	300.00	200	5	200
18	Турист	700.00	500	20	300
19	Роуминг+	1100.00	1000	30	500
20	VIP	3000.00	20000	1000	20000
\.


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 215
-- Name: abonent_abonent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.abonent_abonent_id_seq', 24, true);


--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 221
-- Name: service_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_service_id_seq', 20, true);


--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 223
-- Name: serviceconnection_connection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serviceconnection_connection_id_seq', 22, true);


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 219
-- Name: simcard_sim_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.simcard_sim_id_seq', 23, true);


--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 217
-- Name: tariff_tariff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tariff_tariff_id_seq', 20, true);


--
-- TOC entry 4763 (class 2606 OID 16406)
-- Name: abonent abonent_passport_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abonent
    ADD CONSTRAINT abonent_passport_key UNIQUE (passport);


--
-- TOC entry 4765 (class 2606 OID 16404)
-- Name: abonent abonent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abonent
    ADD CONSTRAINT abonent_pkey PRIMARY KEY (abonent_id);


--
-- TOC entry 4773 (class 2606 OID 16439)
-- Name: service service_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (service_id);


--
-- TOC entry 4775 (class 2606 OID 16446)
-- Name: serviceconnection serviceconnection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceconnection
    ADD CONSTRAINT serviceconnection_pkey PRIMARY KEY (connection_id);


--
-- TOC entry 4769 (class 2606 OID 16422)
-- Name: simcard simcard_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simcard
    ADD CONSTRAINT simcard_phone_number_key UNIQUE (phone_number);


--
-- TOC entry 4771 (class 2606 OID 16420)
-- Name: simcard simcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simcard
    ADD CONSTRAINT simcard_pkey PRIMARY KEY (sim_id);


--
-- TOC entry 4767 (class 2606 OID 16413)
-- Name: tariff tariff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tariff
    ADD CONSTRAINT tariff_pkey PRIMARY KEY (tariff_id);


--
-- TOC entry 4780 (class 2620 OID 16485)
-- Name: simcard trg_auto_voice_mail; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_auto_voice_mail AFTER INSERT ON public.simcard FOR EACH ROW EXECUTE FUNCTION public.auto_add_voice_mail();


--
-- TOC entry 4778 (class 2606 OID 16452)
-- Name: serviceconnection serviceconnection_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceconnection
    ADD CONSTRAINT serviceconnection_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.service(service_id);


--
-- TOC entry 4779 (class 2606 OID 16473)
-- Name: serviceconnection serviceconnection_sim_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceconnection
    ADD CONSTRAINT serviceconnection_sim_id_fkey FOREIGN KEY (sim_id) REFERENCES public.simcard(sim_id) ON DELETE CASCADE;


--
-- TOC entry 4776 (class 2606 OID 16423)
-- Name: simcard simcard_abonent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simcard
    ADD CONSTRAINT simcard_abonent_id_fkey FOREIGN KEY (abonent_id) REFERENCES public.abonent(abonent_id);


--
-- TOC entry 4777 (class 2606 OID 16428)
-- Name: simcard simcard_tariff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simcard
    ADD CONSTRAINT simcard_tariff_id_fkey FOREIGN KEY (tariff_id) REFERENCES public.tariff(tariff_id);


-- Completed on 2025-12-23 15:08:59

--
-- PostgreSQL database dump complete
--

\unrestrict 8YS1Daywiam7I2Wc7qVUsDOFmeI3SJg2wUP9GXVtXLFgzlnd85PpiJi2CCMYnrN

