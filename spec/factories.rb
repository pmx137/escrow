FactoryGirl.define do
  factory :user do
    firstname 'John'
    lastname 'Doe'
    email 'user@user.com'
    password User.password_generate
    password_digest '$2a$10$5TYF9Mm9HbpOWuOq/0LngeRo3QzJD9jt8sX5KDVNZ7l0P9LcI4VWu'
    auth_token '1234'
    bypass_humanizer true
  end
  factory :payer, :class => User do
    firstname 'Warren'
    lastname 'Buffet'
    account_owner 'Warren Bufet'
    account_no '12 3456 7890 1234 5678 9000 02'
    email 'warren@buffet.com'
    mobile '600 600 600'
    password User.password_generate
    password_digest '$2a$10$5TYF9Mm9HbpOWuOq/0LngeRo3QzJD9jt8sX5KDVNZ7l0P9LcI4VWu'
    auth_token '1235'
    bypass_humanizer true
  end

  factory :recipient, :class => User do
    firstname 'Jurek'
    lastname 'Owsiak'
    account_owner 'Jurek Owsiak'
    account_no '12 3456 7890 1234 5678 9000 03'
    email 'jurek@wosp.org'
    password User.password_generate
    password_digest '$2a$10$5TYF9Mm9HbpOWuOq/0LngeRo3QzJD9jt8sX5KDVNZ7l0P9LcI4VWu'
    auth_token '1236'
    bypass_humanizer true
  end

  factory :payment do
    payer_id payer
    recipient_id recipient
    title 'zlecenie budowy serwisu'
    amount 20000
    end_date '2012-12-31'
    payment_date '2012-01-01'
    payment_state -1
    is_deleted false
    is_disputed false
    service_url 'http://wp.pl'
    details { random_string }
    ip '128.0.0.2'
    url_token 'xxx'
    r_account_owner 'John Doe'
    r_account_no '12 3456 7890 1234 5678 9000 01'
    is_asked false
    bypass_humanizer true
  end

  factory :pay_for_recipient, :class=> Payment do
    p_firstname 'Warren'
    p_lastname 'Buffet'
    p_email 'warren@buffet.com'
    p_mobile '600 600 600'
    r_firstname 'Henry'
    r_lastname 'Ford'
    r_email 'henry@ford.com'
    title 'zlecenie budowy serwisu www'
    amount 10000
    end_date '2012-12-31'
    payment_date '2012-01-01'
    payment_state -1
    is_deleted false
    is_disputed false
    service_url 'http://onet.pl'
    details { random_string }
    ip '128.0.0.2'
    url_token 'xxx'
    r_account_owner 'Henry Ford'
    r_account_no '12 3456 7890 1234 5678 9000 01'
    is_asked false
    bypass_humanizer true
  end

  factory :ask_for_payment, :class=> Payment do
    p_firstname 'John'
    p_lastname 'Travolta'
    p_email 'john1@wp.pl'
    p_mobile '501234563'
    r_firstname 'Jurek'
    r_lastname 'Owsiak'
    r_email 'jurek@wosp.org'
    title 'zlecenie budowy serwisu www'
    amount 10000
    end_date '2012-12-31'
    payment_date '2012-01-01'
    payment_state -1
    is_deleted false
    is_disputed false
    service_url 'http://onet.pl'
    details { random_string }
    ip '128.0.0.2'
    url_token 'xxx'
    r_account_owner 'Jurek Owsiak'
    r_account_no '12 3456 7890 1234 5678 9000 03'
    is_asked false
    bypass_humanizer true
  end

  factory :new_payment, :class => Payment do
    title 'zlecenie budowy serwisu nr X'
    amount 20000
    p_firstname 'John'
    p_lastname 'Travolta'
    p_email 'john@wp.pl'
    p_mobile '501234567'
    end_date '2012-12-31'
    payment_date '2012-11-20'
    payment_state -1
    is_deleted false
    is_disputed false
    service_url 'http://onet.pl'
    details { random_string }
    url_token 'xxx'
    r_firstname 'Henry'
    r_lastname 'Ford'
    r_email 'henry@ford.com'
    r_account_owner 'John Doe'
    r_account_no '12 3456 7890 1234 5678 9000 01'
    is_asked false
    bypass_humanizer true
  end

  factory :dispute do
    payment
    complainant_id recipient
    defendant_id payer
    amount_to_pay 1000
    dispute_state 0
    end_date '2013-01-10'
    is_deleted false
    is_ended false
    complaint { random_string }
    judgment { random_string }
  end

  factory :dispute_comment do
    dispute dispute
    user payer
    body { random_string }
    payment payment
  end

  factory :dispute_reply, :class => DisputeComment do
    dispute dispute
    user recipient
    body { random_string }
    payment payment
  end
end


def random_email_address
  "#{random_string}@example.com"
end

def random_string
  letters = *'a'..'z'
  random_string_for_uniqueness = ''
  10.times { random_string_for_uniqueness += letters[rand(letters.size - 1)] }
  random_string_for_uniqueness
end