WITH
     accounts_uuid AS (
        INSERT INTO atm.accounts(uuid, user_id, currency_id, amount, bank_id, account_type_id) VALUES
            (uuid_generate_v4(), 1, 140, 2400.00, 1, 1),
            (uuid_generate_v4(), 1, 142, 350.00, 3, 1),
            (uuid_generate_v4(), 2, 140, 2400.00, 1, 1),
            (uuid_generate_v4(), 2, 142, 350.00, 3, 2)
        RETURNING uuid
    ),
     accounts_array AS (
        SELECT array_agg(uuid) as uuids FROM accounts_uuid
    ),
     cards_data AS (
         INSERT INTO atm.cards(owner, expire, provider_id, card_number, pin, account_uuid, created_at, user_id) VALUES
            ('JOHN DOE', '2024-12-01', 1, '5678657856747876', '9fe8593a8a330607d76796b35c64c600', (select uuids[1] from accounts_array), now() - interval '1 year', 1),
            ('John Doe', '2023-10-01', 2, '5679999999747876', '9fe0000a8a330607d76796b35c64c600', (select uuids[2] from accounts_array), now() - interval '10 months', 1),
            ('JANE DOE', '2024-12-01', 1, '5633333333747876', '9fe8590000000000076796b35c64c600', (select uuids[3] from accounts_array), now() - interval '2 years', 2),
            ('Jane Doe', '2024-12-01', 2, '5678657851111111', '9fe8593a8a3306072222222222222220', (select uuids[4] from accounts_array), now() - interval '1 year', 2)
         RETURNING id
     ),
     cards_ids_array AS (
         SELECT array_agg(id) as ids FROM cards_data
     )
INSERT INTO atm.transaction_logs(from_account_uuid, to_account_uuid, transaction_type_id, created_at, amount, status_id, card_id) VALUES
  ((SELECT uuids[1] FROM accounts_array), null, 1, now() - interval '6 months', 120.00, 1, (SELECT ids[1] FROM cards_ids_array)),
  ((SELECT uuids[1] FROM accounts_array), null, 2, now() - interval '5 months', 120.00, 1, (SELECT ids[1] FROM cards_ids_array)),
  ((SELECT uuids[1] FROM accounts_array), (SELECT uuids[3] FROM accounts_array), 3, now() - interval '4 months', 99.00, 2, (SELECT ids[1] FROM cards_ids_array)),
  ((SELECT uuids[1] FROM accounts_array), (SELECT uuids[3] FROM accounts_array), 3, now() - interval '3 months', 19.00, 1, (SELECT ids[1] FROM cards_ids_array)),
  ((SELECT uuids[1] FROM accounts_array), (SELECT uuids[3] FROM accounts_array), 3, now() - interval '3 months', 39.00, 1, (SELECT ids[1] FROM cards_ids_array)),
  ((SELECT uuids[3] FROM accounts_array), null, 2, now() - interval '2 months', 120.00, 1, (SELECT ids[3] FROM cards_ids_array)),
  ((SELECT uuids[3] FROM accounts_array), null, 2, now() - interval '2 months', 13.00, 1, (SELECT ids[3] FROM cards_ids_array)),
  ((SELECT uuids[3] FROM accounts_array), null, 1, now() - interval '2 months', 13.00, 1, (SELECT ids[3] FROM cards_ids_array)),
  ((SELECT uuids[3] FROM accounts_array), null, 1, now() - interval '2 months', 93.00, 1, (SELECT ids[3] FROM cards_ids_array));
