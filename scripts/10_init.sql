CREATE SCHEMA IF NOT EXISTS atm;

CREATE OR REPLACE FUNCTION upd_updated_at() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE SEQUENCE atm.account_type_id_seq START WITH 1;

CREATE SEQUENCE atm.banks_id_seq START WITH 1;

CREATE SEQUENCE atm.cards_id_seq START WITH 1;

CREATE SEQUENCE atm.card_providers_id_seq START WITH 1;

CREATE SEQUENCE atm.currencies_id_seq START WITH 1;

CREATE SEQUENCE atm.document_types_id_seq START WITH 1;

CREATE SEQUENCE atm.languages_id_seq START WITH 1;

CREATE SEQUENCE atm.locations_id_seq START WITH 1;

CREATE SEQUENCE atm.timezones_id_seq START WITH 1;

CREATE SEQUENCE atm.transaction_statuses_id_seq START WITH 1;

CREATE SEQUENCE atm.transaction_type_id_seq START WITH 1;

CREATE SEQUENCE atm.user_internal_statuses_id_seq START WITH 1;

CREATE SEQUENCE atm.user_statuses_id_seq START WITH 1;

CREATE SEQUENCE atm.users_document_type_id_seq START WITH 1;

CREATE SEQUENCE atm.users_id_seq START WITH 1;

CREATE SEQUENCE atm.users_location_id_seq START WITH 1;

CREATE  TABLE atm.account_type ( 
  id                   integer DEFAULT nextval('atm.account_type_id_seq'::regclass) NOT NULL ,
  title                varchar(100)   ,
  CONSTRAINT pk_account_type_id PRIMARY KEY ( id )
 );

COMMENT ON TABLE atm.account_type IS 'тип рахунку';

COMMENT ON COLUMN atm.account_type.id IS 'account type identifier';

COMMENT ON COLUMN atm.account_type.title IS 'назва типу рахунку';

CREATE  TABLE atm.banks ( 
  id                   integer DEFAULT nextval('atm.banks_id_seq'::regclass) NOT NULL ,
  title                varchar(255)  NOT NULL ,
  location_id integer  NOT NULL ,
  address              varchar(255)  NOT NULL ,
  CONSTRAINT pk_banks_id PRIMARY KEY ( id )
 );

COMMENT ON TABLE atm.banks IS 'банки-партнери';

COMMENT ON COLUMN atm.banks.id IS 'ідентифікатор банку';

COMMENT ON COLUMN atm.banks.title IS 'назва банку';

COMMENT ON COLUMN atm.banks.location_id IS 'ідентифікатор локації банку';

COMMENT ON COLUMN atm.banks.address IS 'адрес головного офісу банку';

CREATE  TABLE atm.card_providers ( 
  id                   integer DEFAULT nextval('atm.card_providers_id_seq'::regclass) NOT NULL ,
  title                varchar(255)  NOT NULL ,
  CONSTRAINT pk_card_providers_id PRIMARY KEY ( id )
 );

COMMENT ON TABLE atm.card_providers IS 'постачальники пластикових карток';

COMMENT ON COLUMN atm.card_providers.id IS 'ідентифікатор постачальника';

COMMENT ON COLUMN atm.card_providers.title IS 'назва постачальника';

CREATE  TABLE atm.currencies ( 
  id                   integer DEFAULT nextval('atm.currencies_id_seq'::regclass) NOT NULL ,
  title                varchar(100)  NOT NULL ,
  currency_sign        char(2)   ,
  code                 varchar(3)  NOT NULL ,
  CONSTRAINT pk_currencies_id PRIMARY KEY ( id )
 );

CREATE UNIQUE INDEX uniq_idx_currencies_title ON atm.currencies ( title );

COMMENT ON INDEX atm.uniq_idx_currencies_title IS 'назва валюти повинна бути унікальною';

COMMENT ON TABLE atm.currencies IS 'валюти, що використовуються';

COMMENT ON COLUMN atm.currencies.id IS 'ідентифікатор валюти';

COMMENT ON COLUMN atm.currencies.title IS 'назва валюти';

COMMENT ON COLUMN atm.currencies.currency_sign IS 'символ валюти, якщо існує';

COMMENT ON COLUMN atm.currencies.code IS 'ISO код валюти, 3 символи';

CREATE  TABLE atm.document_types ( 
  id                   integer DEFAULT nextval('atm.document_types_id_seq'::regclass) NOT NULL ,
  title                varchar(255)  NOT NULL ,
  CONSTRAINT pk_document_types_id PRIMARY KEY ( id )
 );

CREATE UNIQUE INDEX uniq_idx_document_types_title ON atm.document_types ( title );

COMMENT ON INDEX atm.uniq_idx_document_types_title IS 'тип документу повинен бути унікальним';

COMMENT ON TABLE atm.document_types IS 'тип документу (паспорт, водійське посвідчення, тощо)';

COMMENT ON COLUMN atm.document_types.id IS 'ідентифікатор документу';

COMMENT ON COLUMN atm.document_types.title IS 'назва документу';

CREATE  TABLE atm.languages ( 
  id                   smallint DEFAULT nextval('atm.languages_id_seq'::regclass) NOT NULL ,
  "iso_639-1"          varchar(20)  NOT NULL ,
  title                varchar(255)  NOT NULL ,
  CONSTRAINT pk_languages_id PRIMARY KEY ( id )
 );

CREATE UNIQUE INDEX uniq_idx_languages_title ON atm.languages ( title );

COMMENT ON INDEX atm.uniq_idx_languages_title IS 'мови не повинні дублюватися';

CREATE UNIQUE INDEX uniq_idx_languages_iso ON atm.languages ( "iso_639-1" );

COMMENT ON INDEX atm.uniq_idx_languages_iso IS 'мови не повинні дублюватися';

COMMENT ON TABLE atm.languages IS 'доступні мови';

COMMENT ON COLUMN atm.languages.id IS 'ідентифікатор мови';

COMMENT ON COLUMN atm.languages."iso_639-1" IS 'ISO 639-1 стандарт для визначення мови';

COMMENT ON COLUMN atm.languages.title IS 'повна назва мови';

CREATE  TABLE atm.locations ( 
  id                   integer DEFAULT nextval('atm.locations_id_seq'::regclass) NOT NULL ,
  code                 varchar(2)  NOT NULL ,
  city                 varchar(255)   ,
  region               varchar(255)   ,
  country_name         varchar(255)   ,
  CONSTRAINT pk_tbl_id PRIMARY KEY ( id )
 );

COMMENT ON TABLE atm.locations IS 'таблиця країн, регіонів, міст, сел.';

COMMENT ON COLUMN atm.locations.code IS 'ISO 3166-1 Alpha-2 код країни';

COMMENT ON COLUMN atm.locations.city IS 'місто, село';

COMMENT ON COLUMN atm.locations.region IS 'регіон (область, край, тощо)';

COMMENT ON COLUMN atm.locations.country_name IS 'назва країни';

CREATE  TABLE atm.timezones ( 
  id                   integer DEFAULT nextval('atm.timezones_id_seq'::regclass) NOT NULL ,
  title                varchar(255)  NOT NULL ,
  CONSTRAINT pk_timezones_id PRIMARY KEY ( id )
 );

CREATE UNIQUE INDEX uniq_idx_timezones_title ON atm.timezones ( title );

COMMENT ON INDEX atm.uniq_idx_timezones_title IS 'таймзони не повинні дублюватися';

COMMENT ON TABLE atm.timezones IS 'доступні таймзони Використовується для корректного відображенні операцій в разних часових поясах.';

COMMENT ON COLUMN atm.timezones.id IS 'primary key';

COMMENT ON COLUMN atm.timezones.title IS 'назва таймзони';

CREATE  TABLE atm.transaction_statuses ( 
  id                   integer DEFAULT nextval('atm.transaction_statuses_id_seq'::regclass) NOT NULL ,
  title                varchar(100)  NOT NULL ,
  CONSTRAINT pk_transaction_statuses_id PRIMARY KEY ( id )
 );

CREATE UNIQUE INDEX uniq_idx_transaction_statuses ON atm.transaction_statuses ( title );

COMMENT ON INDEX atm.uniq_idx_transaction_statuses IS 'статуси транзакції повинні бути унікальними';

COMMENT ON TABLE atm.transaction_statuses IS 'статус транзакциї (операції)';

COMMENT ON COLUMN atm.transaction_statuses.id IS 'status identifier';

COMMENT ON COLUMN atm.transaction_statuses.title IS 'назва статусу транзакції';

CREATE  TABLE atm.transaction_type ( 
  id                   integer DEFAULT nextval('atm.transaction_type_id_seq'::regclass) NOT NULL ,
  title                varchar(100)  NOT NULL ,
  CONSTRAINT pk_transaction_type_id_id PRIMARY KEY ( id )
 );

CREATE UNIQUE INDEX idx_transaction_type ON atm.transaction_type ( title );

COMMENT ON INDEX atm.idx_transaction_type IS 'назва типів транзакцій повинна бути унікальною';

COMMENT ON TABLE atm.transaction_type IS 'тип транзакції (операції)';

COMMENT ON COLUMN atm.transaction_type.title IS 'назва типу транзакції';

CREATE  TABLE atm.user_internal_statuses ( 
  id                   smallint DEFAULT nextval('atm.user_internal_statuses_id_seq'::regclass) NOT NULL ,
  title                varchar(100)  NOT NULL ,
  CONSTRAINT pk_user_internal_statuses_id PRIMARY KEY ( id )
 );

COMMENT ON CONSTRAINT pk_user_internal_statuses_id ON atm.user_internal_statuses IS 'identifier index';

CREATE UNIQUE INDEX uniq_idx_internal_statuses_title ON atm.user_internal_statuses ( title );

COMMENT ON INDEX atm.uniq_idx_internal_statuses_title IS 'назва внутрішнього статусу повинна бути унікальною';

COMMENT ON TABLE atm.user_internal_statuses IS 'внутрішній статус користувача';

COMMENT ON COLUMN atm.user_internal_statuses.id IS 'ідентифікатор внутрішнього статусу';

COMMENT ON COLUMN atm.user_internal_statuses.title IS 'назва внутрішнього статусу';

CREATE  TABLE atm.user_statuses ( 
  id                   smallint DEFAULT nextval('atm.user_statuses_id_seq'::regclass) NOT NULL ,
  title                varchar(100)  NOT NULL ,
  CONSTRAINT pk_user_statuses_id PRIMARY KEY ( id )
 );

CREATE UNIQUE INDEX uniq_idx_user_statuses_title ON atm.user_statuses ( title );

COMMENT ON INDEX atm.uniq_idx_user_statuses_title IS 'назва статуса повиння бути унікальною';

COMMENT ON TABLE atm.user_statuses IS 'статуси для  користувачів';

COMMENT ON COLUMN atm.user_statuses.id IS 'ідентифікатор статусу';

COMMENT ON COLUMN atm.user_statuses.title IS 'назва статусу';

CREATE  TABLE atm.users ( 
  id                   bigint DEFAULT nextval('atm.users_id_seq'::regclass) NOT NULL ,
  created_at           timestamptz(12) DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  updated_at           timestamptz(12) DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  removed_at           timestamptz(12)   ,
  first_name           varchar(255)  NOT NULL ,
  last_name            varchar(255)  NOT NULL ,
  middle_name          varchar(255)   ,
  primary_phone        varchar(100)  NOT NULL ,
  additional_phone     varchar(100)   ,
  email                varchar(255)   ,
  status_id            smallint  NOT NULL ,
  language_id          smallint  NOT NULL ,
  timezone_id          smallint  NOT NULL ,
  birthday             date   ,
  internal_status_id   smallint  NOT NULL ,
  location_id          integer DEFAULT nextval('atm.users_location_id_seq'::regclass) NOT NULL ,
  zip                  varchar(100)  NOT NULL ,
  address_1             varchar(255)  NOT NULL ,
  address_2            varchar(255)   ,
  ipn                  varchar(12)  NOT NULL ,
  document_number      varchar(100)  NOT NULL ,
  document_type_id     smallint DEFAULT nextval('atm.users_document_type_id_seq'::regclass) NOT NULL ,
  document_date        date   ,
  document_authority   varchar(255)   ,
  CONSTRAINT pk_users_id PRIMARY KEY ( id )
 );

CREATE TRIGGER t_users_upd
  BEFORE UPDATE
  ON atm.users
  FOR EACH ROW
EXECUTE PROCEDURE upd_updated_at();

CREATE INDEX idx_users_created_at ON atm.users ( created_at  DESC  );

COMMENT ON INDEX atm.idx_users_created_at IS 'індекс для швидкого сортування останніх створених користувачів';

CREATE INDEX idx_users_email ON atm.users ( email  ASC  );

COMMENT ON INDEX atm.idx_users_email IS 'індекс для швидкого пошуку по email';

CREATE INDEX idx_users_document_number ON atm.users ( document_number  ASC  );

COMMENT ON INDEX atm.idx_users_document_number IS 'індекс для швидкого пошуку по номеру документу';

COMMENT ON TABLE atm.users IS 'таблиця користувачів';

COMMENT ON COLUMN atm.users.created_at IS 'дата створення користувача';

COMMENT ON COLUMN atm.users.updated_at IS 'дата останнього апдейту даних користувача';

COMMENT ON COLUMN atm.users.removed_at IS 'дата видалення користувача, або його блокування. Якщо користувач активний - null.';

COMMENT ON COLUMN atm.users.first_name IS 'ім''я користувача';

COMMENT ON COLUMN atm.users.last_name IS 'прізвище користувача';

COMMENT ON COLUMN atm.users.middle_name IS 'по-батькові, або middle name';

COMMENT ON COLUMN atm.users.primary_phone IS 'основний номер телефону';

COMMENT ON COLUMN atm.users.additional_phone IS 'додатковий номер телефону';

COMMENT ON COLUMN atm.users.email IS 'адрес електронної пошти';

COMMENT ON COLUMN atm.users.status_id IS 'статус користувача';

COMMENT ON COLUMN atm.users.language_id IS 'мова користувача';

COMMENT ON COLUMN atm.users.timezone_id IS 'таймзона користувача';

COMMENT ON COLUMN atm.users.birthday IS 'дата народження';

COMMENT ON COLUMN atm.users.internal_status_id IS 'внутрішній статус користувача';

COMMENT ON COLUMN atm.users.location_id IS 'місто, або локація користувача';

COMMENT ON COLUMN atm.users.zip IS 'адресний індекс';

COMMENT ON COLUMN atm.users.address_1 IS 'перша строка адресу';

COMMENT ON COLUMN atm.users.address_2 IS 'друга строка адресу';

COMMENT ON COLUMN atm.users.ipn IS 'Індивідуальний Податковий Номер користувача';

COMMENT ON COLUMN atm.users.document_number IS 'номер документу користувача';

COMMENT ON COLUMN atm.users.document_type_id IS 'тип документу користувача (паспорт, водійське посвідчення, тощо)';

COMMENT ON COLUMN atm.users.document_date IS 'дата видачі документу';

COMMENT ON COLUMN atm.users.document_authority IS 'орган що видав документ';

CREATE  TABLE atm.accounts ( 
  uuid                 uuid  NOT NULL ,
  user_id              integer  NOT NULL ,
  currency_id          integer  NOT NULL ,
  amount               numeric(12,2)  NOT NULL ,
  bank_id              integer  NOT NULL ,
  account_type_id      smallint NOT NULL ,
  CONSTRAINT pk_accounts_uuid PRIMARY KEY ( uuid )
 );

COMMENT ON TABLE atm.accounts IS 'рахунки';

COMMENT ON COLUMN atm.accounts.uuid IS 'ідентифікатор рахунку. UUID формат використовується для запобіганню колізій серед різних банків.';

COMMENT ON COLUMN atm.accounts.user_id IS 'ідентифікатор користувача в системі';

COMMENT ON COLUMN atm.accounts.currency_id IS 'ідентифікатор валюти';

COMMENT ON COLUMN atm.accounts.amount IS 'баланс рахунку';

COMMENT ON COLUMN atm.accounts.bank_id IS 'ідентифікатор банку';

COMMENT ON COLUMN atm.accounts.account_type_id IS 'тип рахунку користувача';

CREATE  TABLE atm.cards ( 
  id                   bigint DEFAULT nextval('atm.cards_id_seq'::regclass) NOT NULL ,
  "owner"              varchar(100)  NOT NULL ,
  expire               date  NOT NULL ,
  provider_id          integer  NOT NULL ,
  card_number          varchar(40)  NOT NULL ,
  pin                  varchar(100)  NOT NULL ,
  account_uuid         uuid  NOT NULL ,
  created_at           timestamptz(12)  NOT NULL ,
  CONSTRAINT pk_cards_id PRIMARY KEY ( id )
 );

CREATE INDEX idx_cards_card_number ON atm.cards ( card_number  ASC  );

COMMENT ON INDEX atm.idx_cards_card_number IS 'для швидкого пошуку картки по номеру';

COMMENT ON TABLE atm.cards IS 'credit/debit cards table';

COMMENT ON COLUMN atm.cards.id IS 'ідентифікатор картки';

COMMENT ON COLUMN atm.cards."owner" IS 'власник картки';

COMMENT ON COLUMN atm.cards.expire IS 'кінцева дата картки';

COMMENT ON COLUMN atm.cards.provider_id IS 'банк, що видав картку';

COMMENT ON COLUMN atm.cards.card_number IS 'номер картки';

COMMENT ON COLUMN atm.cards.pin IS 'ПІН-код (захешований)';

COMMENT ON COLUMN atm.cards.account_uuid IS 'ідентифікатор рахунку';

COMMENT ON COLUMN atm.cards.created_at IS 'дата видання картки';

CREATE  TABLE atm.transaction_logs ( 
  from_account_uuid    uuid  NOT NULL ,
  to_account_uuid      uuid,
  transaction_type_id  smallint  NOT NULL ,
  created_at           timestamptz(12) DEFAULT CURRENT_TIMESTAMP  ,
  amount               numeric(12,2)  NOT NULL ,
  status_id            smallint  NOT NULL ,
  card_id              bigint  NOT NULL 
 );

CREATE INDEX idx_transaction_logs_from_account_uuid ON atm.transaction_logs ( from_account_uuid  ASC  );

COMMENT ON INDEX atm.idx_transaction_logs_from_account_uuid IS 'для швидкого пошуку транзакцій по номеру рахунку';

CREATE INDEX idx_transaction_logs ON atm.transaction_logs ( transaction_type_id );

COMMENT ON INDEX atm.idx_transaction_logs IS 'для швидкого пошуку по типу транзакції';

CREATE INDEX idx_transaction_logs_to_account_uuid ON atm.transaction_logs ( to_account_uuid  ASC  );

COMMENT ON INDEX atm.idx_transaction_logs_to_account_uuid IS 'для швидкого пошуку по номеру рахунку на який зачисляються кошти';

CREATE INDEX idx_transaction_logs_card_id ON atm.transaction_logs ( card_id  ASC  );

COMMENT ON INDEX atm.idx_transaction_logs_card_id IS 'для швидкого пошуку по номеру картки';

CREATE INDEX idx_transaction_logs_created_at ON atm.transaction_logs ( created_at  DESC  );

COMMENT ON INDEX atm.idx_transaction_logs_created_at IS 'для швидкого пошуку по даті транзакції';

COMMENT ON TABLE atm.transaction_logs IS 'лог транзакцій (операцій)';

COMMENT ON COLUMN atm.transaction_logs.from_account_uuid IS 'рахунок с якого виконується списання';

COMMENT ON COLUMN atm.transaction_logs.to_account_uuid IS 'рахунок куди  зачисляються кошти';

COMMENT ON COLUMN atm.transaction_logs.transaction_type_id IS 'ідентифікатор типу транзакції';

COMMENT ON COLUMN atm.transaction_logs.created_at IS 'дата транзакції';

COMMENT ON COLUMN atm.transaction_logs.amount IS 'сума транзакцій (може бути нижче 0)';

COMMENT ON COLUMN atm.transaction_logs.status_id IS 'ідентифікатор статусу транзакциї';

COMMENT ON COLUMN atm.transaction_logs.card_id IS 'картка, що використовувалась';

ALTER TABLE atm.accounts ADD CONSTRAINT fk_accounts_users FOREIGN KEY ( user_id ) REFERENCES atm.users( id );

ALTER TABLE atm.accounts ADD CONSTRAINT fk_accounts_currencies FOREIGN KEY ( currency_id ) REFERENCES atm.currencies( id );

ALTER TABLE atm.accounts ADD CONSTRAINT fk_accounts_banks FOREIGN KEY ( bank_id ) REFERENCES atm.banks( id );

ALTER TABLE atm.accounts ADD CONSTRAINT fk_accounts_account_type FOREIGN KEY ( account_type_id ) REFERENCES atm.account_type( id );

ALTER TABLE atm.cards ADD CONSTRAINT fk_cards_card_providers FOREIGN KEY ( provider_id ) REFERENCES atm.card_providers( id );

ALTER TABLE atm.cards ADD CONSTRAINT fk_cards_accounts FOREIGN KEY ( account_uuid ) REFERENCES atm.accounts( uuid );

ALTER TABLE atm.transaction_logs ADD CONSTRAINT fk_transaction_logs_accounts FOREIGN KEY ( from_account_uuid ) REFERENCES atm.accounts( uuid );

ALTER TABLE atm.transaction_logs ADD CONSTRAINT fk_transaction_logs_transaction_type FOREIGN KEY ( transaction_type_id ) REFERENCES atm.transaction_type( id );

ALTER TABLE atm.transaction_logs ADD CONSTRAINT fk_transaction_logs_transaction_statuses FOREIGN KEY ( status_id ) REFERENCES atm.transaction_statuses( id );

ALTER TABLE atm.users ADD CONSTRAINT fk_users_user_statuses FOREIGN KEY ( status_id ) REFERENCES atm.user_statuses( id );

ALTER TABLE atm.users ADD CONSTRAINT fk_users_user_internal_statuses FOREIGN KEY ( internal_status_id ) REFERENCES atm.user_internal_statuses( id );

ALTER TABLE atm.users ADD CONSTRAINT fk_users_languages FOREIGN KEY ( language_id ) REFERENCES atm.languages( id );

ALTER TABLE atm.users ADD CONSTRAINT fk_users_timezones FOREIGN KEY ( timezone_id ) REFERENCES atm.timezones( id );

ALTER TABLE atm.users ADD CONSTRAINT fk_users_locations FOREIGN KEY ( location_id ) REFERENCES atm.locations( id );

ALTER TABLE atm.users ADD CONSTRAINT fk_users_document_types FOREIGN KEY ( document_type_id ) REFERENCES atm.document_types( id );

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

