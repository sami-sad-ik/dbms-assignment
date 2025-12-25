create table users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) not null,
  role VARCHAR(20) CHECK (role IN ('Customer', 'Admin')) not null
);

CREATE TABLE vehicles (
  vehicle_id SERIAL PRIMARY KEY, 
  name varchar(100) not null,
  type varchar(50) check (type IN ('car','bike','truck') ) not null,
  model int not null,
  registration_number varchar(50) unique not null,
  rental_price INT not null,
  status VARCHAR(20) CHECK (status IN ('available', 'rented', 'maintenance')) not null
)


CREATE TABLE bookings (
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id) ON DELETE CASCADE not null,
  vehicle_id INT REFERENCES vehicles(vehicle_id) ON DELETE CASCADE not null,
  start_date DATE not null,
  end_date DATE,
  status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'completed')) not null,
  total_cost INT not null
);

-- join 
select booking_id,u.name as customer_name,v.name as vehicle_name,start_date,end_date,b.status from bookings b 
join users u on b.user_id = u.user_id 
join vehicles v on b.vehicle_id = v.vehicle_id

-- the vehicles that never booked
select vehicle_id,name,type,model,registration_number,rental_price,status from vehicles v 
where not exists (
  select * from bookings b 
  where b.vehicle_id = v.vehicle_id
);

--find the available vehicle for specific type
SELECT * FROM vehicles
WHERE status = 'available'
  AND type = 'car';

--total number of bookings that had more than two bookings
SELECT
  v.name AS vehicle_name,
  COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN vehicles v
  ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2;