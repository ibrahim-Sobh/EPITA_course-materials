--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

-- Started on 2021-11-01 12:18:39 CET

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
-- TOC entry 3613 (class 1262 OID 14020)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 3613
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 6 (class 2615 OID 16411)
-- Name: medical; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA medical;


ALTER SCHEMA medical OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 212 (class 1259 OID 16422)
-- Name: APPOINTMENT; Type: TABLE; Schema: medical; Owner: postgres
--

CREATE TABLE medical."APPOINTMENT" (
    app_date date NOT NULL,
    app_time time without time zone NOT NULL,
    app_duration numeric(3,0) NOT NULL,
    app_reason text,
    app_doc_id integer NOT NULL,
    app_pat_id integer NOT NULL,
    app_bill_id integer NOT NULL
);


ALTER TABLE medical."APPOINTMENT" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16450)
-- Name: BILL; Type: TABLE; Schema: medical; Owner: postgres
--

CREATE TABLE medical."BILL" (
    bill_id integer NOT NULL,
    bill_amountinsured money,
    bill_amountnotinsured money,
    bill_datesent date,
    bill_status character varying(25) NOT NULL,
    bill_app_id integer NOT NULL,
    bill_pay_id integer NOT NULL
);


ALTER TABLE medical."BILL" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16417)
-- Name: DOCTORS; Type: TABLE; Schema: medical; Owner: postgres
--

CREATE TABLE medical."DOCTORS" (
    doc_physcianidnumber integer NOT NULL,
    doc_firstname character varying(25) NOT NULL,
    doc_lastname character varying(25) NOT NULL
);


ALTER TABLE medical."DOCTORS" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16458)
-- Name: INSURANCE_COMPNAY; Type: TABLE; Schema: medical; Owner: postgres
--

CREATE TABLE medical."INSURANCE_COMPNAY" (
    ins_id integer NOT NULL,
    ins_name character varying(25) NOT NULL,
    ins_benef integer NOT NULL,
    ins_phonenumber numeric(20,0),
    ins_claimaddress text
);


ALTER TABLE medical."INSURANCE_COMPNAY" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16439)
-- Name: PATIENT; Type: TABLE; Schema: medical; Owner: postgres
--

CREATE TABLE medical."PATIENT" (
    pat_id integer NOT NULL,
    pat_firstname character varying(25) NOT NULL,
    pat_lastname character varying(25) NOT NULL,
    pat_address text,
    pat_city character varying(20),
    pat_state character varying(20),
    pat_insurance integer
);


ALTER TABLE medical."PATIENT" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16453)
-- Name: PAYMENT; Type: TABLE; Schema: medical; Owner: postgres
--

CREATE TABLE medical."PAYMENT" (
    pay_receiptnumber integer NOT NULL,
    pay_amount money,
    pay_date date,
    pay_method character varying(25),
    pay_bill_id integer NOT NULL,
    pay_pat_id integer NOT NULL,
    pay_ins_id integer NOT NULL
);


ALTER TABLE medical."PAYMENT" OWNER TO postgres;

--
-- TOC entry 3458 (class 2606 OID 16473)
-- Name: BILL BILL_pkey; Type: CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."BILL"
    ADD CONSTRAINT "BILL_pkey" PRIMARY KEY (bill_id);


--
-- TOC entry 3454 (class 2606 OID 16466)
-- Name: APPOINTMENT Booking; Type: CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."APPOINTMENT"
    ADD CONSTRAINT "Booking" PRIMARY KEY (app_doc_id, app_pat_id, app_date, app_time);


--
-- TOC entry 3462 (class 2606 OID 16464)
-- Name: INSURANCE_COMPNAY INSURANCE_COMPNAY_pkey; Type: CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."INSURANCE_COMPNAY"
    ADD CONSTRAINT "INSURANCE_COMPNAY_pkey" PRIMARY KEY (ins_id);


--
-- TOC entry 3456 (class 2606 OID 16443)
-- Name: PATIENT PATIENT_pkey; Type: CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."PATIENT"
    ADD CONSTRAINT "PATIENT_pkey" PRIMARY KEY (pat_id);


--
-- TOC entry 3452 (class 2606 OID 16421)
-- Name: DOCTORS doctors_pkey; Type: CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."DOCTORS"
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (doc_physcianidnumber);


--
-- TOC entry 3460 (class 2606 OID 16500)
-- Name: PAYMENT paymentfraction; Type: CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."PAYMENT"
    ADD CONSTRAINT paymentfraction PRIMARY KEY (pay_bill_id, pay_receiptnumber);


--
-- TOC entry 3463 (class 2606 OID 16432)
-- Name: APPOINTMENT Doctor; Type: FK CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."APPOINTMENT"
    ADD CONSTRAINT "Doctor" FOREIGN KEY (app_doc_id) REFERENCES medical."DOCTORS"(doc_physcianidnumber) NOT VALID;


--
-- TOC entry 3468 (class 2606 OID 16489)
-- Name: PAYMENT InsurancePaymentBy; Type: FK CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."PAYMENT"
    ADD CONSTRAINT "InsurancePaymentBy" FOREIGN KEY (pay_ins_id) REFERENCES medical."INSURANCE_COMPNAY"(ins_id) NOT VALID;


--
-- TOC entry 3466 (class 2606 OID 16494)
-- Name: PATIENT InsuredBy; Type: FK CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."PATIENT"
    ADD CONSTRAINT "InsuredBy" FOREIGN KEY (pat_insurance) REFERENCES medical."INSURANCE_COMPNAY"(ins_id) NOT VALID;


--
-- TOC entry 3464 (class 2606 OID 16467)
-- Name: APPOINTMENT Patient; Type: FK CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."APPOINTMENT"
    ADD CONSTRAINT "Patient" FOREIGN KEY (app_pat_id) REFERENCES medical."PATIENT"(pat_id) NOT VALID;


--
-- TOC entry 3467 (class 2606 OID 16484)
-- Name: PAYMENT PaymentBy; Type: FK CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."PAYMENT"
    ADD CONSTRAINT "PaymentBy" FOREIGN KEY (pay_pat_id) REFERENCES medical."PATIENT"(pat_id) NOT VALID;


--
-- TOC entry 3465 (class 2606 OID 16479)
-- Name: APPOINTMENT Receipt; Type: FK CONSTRAINT; Schema: medical; Owner: postgres
--

ALTER TABLE ONLY medical."APPOINTMENT"
    ADD CONSTRAINT "Receipt" FOREIGN KEY (app_bill_id) REFERENCES medical."BILL"(bill_id) NOT VALID;


-- Completed on 2021-11-01 12:18:40 CET

--
-- PostgreSQL database dump complete
--

